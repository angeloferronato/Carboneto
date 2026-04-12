import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import { Messaging } from "firebase-admin/messaging";
import * as logger from "firebase-functions/logger";

// 1. Inicializa o Admin e garante a tipagem correta para o Messaging
admin.initializeApp();
const messaging: Messaging = admin.messaging();

export const sendNotificationToUser = onDocumentCreated(
  "users/{userId}/notifications/{notificationId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    // Dados exatos que vieram do seu NotificationModel.toJson() no Flutter
    const notificationData = snapshot.data();
    const type: string = notificationData.Type; 
    const fromUserId: string = notificationData.FromUserId;
    const targetId: string = notificationData.TargetId || ""; // Pode ser nulo/vazio
    
    // O usuário que vai receber (Dono da coleção)
    const receiverId = event.params.userId;

    // Se o remetente for o próprio destinatário (ex: curtiu o próprio treino), ignora
    if (fromUserId === receiverId) {
      return;
    }

    try {
      // 2. Busca os tokens do Destinatário
      const receiverDoc = await admin.firestore().collection("users").doc(receiverId).get();
      if (!receiverDoc.exists) return;

      const fcmTokens: string[] = receiverDoc.data()?.FcmTokens || [];
      if (fcmTokens.length === 0) return;

      // 3. Busca o Username do Remetente (Quem curtiu/seguiu)
      let name = "Alguém";
      if (fromUserId) {
        const senderDoc = await admin.firestore().collection("users").doc(fromUserId).get();
        if (senderDoc.exists) {
          // Usa o Username, ajustado para começar com '@' se preferir o estilo rede social
          name = senderDoc.data()?.Username || "Alguém"; 
        }
      }

      // 4. Traduz o 'Type' para o texto da notificação (Espelho do seu método em Dart)
      let actionText = "interagiu com você.";
      let titulo = "Carboneto";

      switch (type) {
        case "followNotice":
          actionText = "começou a seguir você.";
          titulo = "Novo seguidor";
          break;
        case "followAccepted":
          actionText = "aceitou seu pedido para seguir.";
          break;
        case "followRequest":
          actionText = "pediu para seguir você.";
          titulo = "Pedido para seguir";
          break;
        case "like":
          actionText = "curtiu seu treino.";
          break;
      }

      const notificationBody = `@${name} ${actionText}`;

      // 5. Monta a carga da notificação
      const payload = {
        notification: {
          title: titulo,
          body: notificationBody,
        },
        data: {
          // Passamos os dados invisíveis para o Flutter saber o que abrir no clique
          actionType: type,
          targetId: targetId,
          fromUserId: fromUserId, 
          notificationId: event.params.notificationId,
        },
        tokens: fcmTokens,
      };

      // 6. Envia para todos os aparelhos do usuário
      const response = await messaging.sendEachForMulticast(payload);
      logger.info(`${response.successCount} notificações de '${type}' enviadas.`);

      // 7. Limpeza de tokens inválidos (App desinstalado)
      if (response.failureCount > 0) {
        const tokensToRemove: string[] = [];
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            const erro = resp.error;
            if (erro?.code === "messaging/invalid-registration-token" ||
                erro?.code === "messaging/registration-token-not-registered") {
              tokensToRemove.push(fcmTokens[idx] || '');
            }
          }
        });

        if (tokensToRemove.length > 0) {
          await admin.firestore().collection("users").doc(receiverId).update({
            FcmTokens: admin.firestore.FieldValue.arrayRemove(...tokensToRemove),
          });
        }
      }

    } catch (error) {
      logger.error("Erro ao processar notificação:", error);
    }
  }
);
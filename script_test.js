const admin = require("firebase-admin");

const serviceAccount = require('./private_key_firebase.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function migrateTrainings() {
  const trainingsSnapshot = await db.collection("allTrainings").get();

  if (trainingsSnapshot.empty) {
    console.log("Nenhum treino encontrado.");
    return;
  }

  console.log(`Encontrados ${trainingsSnapshot.size} treinos.`);

  const BATCH_LIMIT = 500;
  let batch = db.batch();
  let operationCount = 0;

  for (const doc of trainingsSnapshot.docs) {
    const trainingData = doc.data();

    const authorId = trainingData.AuthorID;

    if (!authorId) {
      console.warn(`Treino ${doc.id} sem AuthorID. Ignorado.`);
      continue;
    }

    const userRef = db.collection("users").doc(authorId);
    const userSnap = await userRef.get();

    if (!userSnap.exists) {
      console.warn(`Usuário ${authorId} não encontrado.`);
      continue;
    }

    const userData = userSnap.data();

    batch.update(doc.ref, {
      Creator: {
        Name: userData.Name ?? "",
        ProfilePicture: userData.ProfilePicture ?? null,
        IsVerified: userData.IsVerified ?? false,
      },
    });

    operationCount++;

    // 🔹 Commit automático ao atingir o limite
    if (operationCount === BATCH_LIMIT) {
      await batch.commit();
      batch = db.batch();
      operationCount = 0;
      console.log("Batch commitado (500).");
    }
  }

  // 🔹 Commit final
  if (operationCount > 0) {
    await batch.commit();
    console.log("Batch final commitado.");
  }

  console.log("✅ Migração concluída.");
}

migrateTrainings()
  .then(() => process.exit(0))
  .catch(err => {
    console.error("❌ Erro na migração:", err);
    process.exit(1);
  });

const admin = require('firebase-admin');
const serviceAccount = require('./private_key_firebase.json');
const { MeiliSearch } = require("meilisearch");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const meiliClient = new MeiliSearch({
    host: 'https://shared-meredith-carboneto-2c512dda.koyeb.app',
    apiKey: 'EDWxYEAJrvPoHIR-gHJSNS3-p6J80XASaechuGNXYIo',
});

// Função auxiliar para esperar 1 segundo no loop
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function popularExerciciosAntigos () {
    try {
        const db = admin.firestore();
        const snapshot = await db.collection('allTrainings').get();

        const documentosParaMeilisearch = [];

        snapshot.forEach((doc) => {
            const data = doc.data();
            documentosParaMeilisearch.push({
                id: data.Id,
                ...data
            });
        });

        if (documentosParaMeilisearch.length === 0) {
            console.log("Nenhum exercício encontrado no Firestore para importar.");
            return;
        }

        const index = meiliClient.index('trainings_index');
        
        console.log(`Enviando ${documentosParaMeilisearch.length} exercícios para a fila...`);
        
        // 1. Envia os documentos
        const task = await index.addDocuments(documentosParaMeilisearch, { primaryKey: 'id' });
        console.log(`Tarefa criada (ID: ${task.taskUid}). Consultando o servidor...`);

        // 2. Loop universal para verificar o status da tarefa
        let taskResult;
        while (true) {
            // Busca o status atual da tarefa no Meilisearch
            taskResult = await meiliClient.tasks.getTask(task.taskUid);
            
            // Se o status for diferente de 'enqueued' (na fila) ou 'processing' (processando), significa que acabou.
            if (taskResult.status !== 'enqueued' && taskResult.status !== 'processing') {
                break;
            }
            
            // Espera 1 segundo antes de perguntar ao servidor de novo
            await sleep(1000);
        }

        // 3. Verifica o resultado final
        if (taskResult.status === 'succeeded') {
            console.log(`✅ Sucesso! Os documentos foram indexados.`);
        } else {
            console.error(`❌ Falha na indexação pelo Meilisearch:`, JSON.stringify(taskResult.error, null, 2));
        }

    } catch (error) {
        console.error("[ERRO FATAL NO SCRIPT]", error);
    }
};

popularExerciciosAntigos();
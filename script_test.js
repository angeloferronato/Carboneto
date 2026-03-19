const admin = require('firebase-admin');
const serviceAccount = require('./private_key_firebase.json');

// 1. Inicialize o SDK (certifique-se de ter o serviceAccountKey.json)

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();

async function renameFieldInSubcategories() {
  const collectionRef = db.collection('allExercises');
  const snapshot = await collectionRef.get();

  if (snapshot.empty) {
    console.log('Nenhum documento encontrado.');
    return;
  }

  let batch = db.batch();
  let count = 0;

  for (const doc of snapshot.docs) {
    const data = doc.data();
    
    // Verificamos se o campo antigo "ID" existe no documento
    if (data.hasOwnProperty('ID')) {
      const valorOriginal = data.ID;
      const docRef = collectionRef.doc(doc.id);

      // Atualizamos o documento:
      // 1. Criamos o novo campo "Id" com o valor antigo
      // 2. Removemos o campo "ID" antigo usando FieldValue.delete()
      batch.update(docRef, {
        Id: valorOriginal,
        ID: admin.firestore.FieldValue.delete()
      });

      count++;
    }

    // Limite de 500 operações por batch
    if (count >= 500) {
      await batch.commit();
      batch = db.batch();
      count = 0;
    }
  }

  if (count > 0) {
    await batch.commit();
  }

  console.log(`Sucesso: ${count} documentos atualizados (campo ID -> Id).`);
}

renameFieldInSubcategories().catch(console.error);
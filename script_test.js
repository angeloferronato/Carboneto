const admin = require('firebase-admin');
const serviceAccount = require('./private_key_firebase.json')

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function addCreatorToExercises() {
  const exercisesSnap = await db.collection("allExercises").get();

  if (exercisesSnap.empty) {
    console.log("Nenhum exercício encontrado.");
    return;
  }

  // 🔥 Cache de usuários (evita leituras repetidas)
  const userCache = new Map();

  let updated = 0;
  let skipped = 0;

  for (const exerciseDoc of exercisesSnap.docs) {
    const exercise = exerciseDoc.data();

    // 🧯 Já tem Creator
    if (exercise.Creator) {
      skipped++;
      continue;
    }

    // ❌ Sem autor
    if (!exercise.AuthorID) {
      skipped++;
      continue;
    }

    let userData;

    // ⚡ Cache
    if (userCache.has(exercise.AuthorID)) {
      userData = userCache.get(exercise.AuthorID);
    } else {
      const userSnap = await db
        .collection("users")
        .doc(exercise.AuthorID)
        .get();

      if (!userSnap.exists) {
        skipped++;
        continue;
      }

      userData = userSnap.data();
      userCache.set(exercise.AuthorID, userData);
    }

    const creator = {
      IsVerified: userData.IsVerified ?? false,
      Name: userData.Name ?? "",
      ProfilePicture: userData.ProfilePicture ?? "",
    };

    await exerciseDoc.ref.update({ Creator: creator });
    updated++;
  }

  console.log(`✅ Creator criado em ${updated} exercícios.`);
  console.log(`⏭️ Exercícios ignorados: ${skipped}`);
}

addCreatorToExercises()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
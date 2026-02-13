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

  let batch = db.batch();
  let updated = 0;

  for (const exerciseDoc of exercisesSnap.docs) {
    const exercise = exerciseDoc.data();

    let keywords = [...exercise.Categories];
    keywords.push(...[exercise.Creator.Name, exercise.Title]);


    const searchExercise = {
      Title: exercise.Title,
      TitleLower: exercise.Title.toLowerCase(),
      Creator: {
        Name: exercise.Creator.Name,
        ProfilePicture: exercise.Creator.ProfilePicture,
        IsVerified: exercise.Creator.IsVerified,
      },
      Categories: exercise.Categories,
      Duration: exercise.Duration ?? 0,
      Repetitions: exercise.Repetitions ?? 0,
      Keywords: keywords,
      AuthorID: exercise.AuthorID,
      Thumbnail: exercise.Thumbnail,
    }

    batch.set(db.collection('exercisesSearch').doc(exerciseDoc.id), searchExercise, {merge: true});

    updated++;
  };

  await batch.commit();
}

addCreatorToExercises()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
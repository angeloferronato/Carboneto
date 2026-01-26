const admin = require('firebase-admin');
const serviceAccount = require('./private_key_firebase.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function changeAuthorIdField() {
    const exercisesSnap = await db.collection('allExercises').get();

    let batch = db.batch();
    let operationCount = 0;

    for (const exerciseDoc of exercisesSnap.docs) {
        const exercise = exerciseDoc.data();

        const oldAuthorId = exercise.AuthorId ?? '';

        if (exercise.AuthorId) {
            batch.update(exerciseDoc.ref, {
                AuthorID: oldAuthorId,
                AuthorId: admin.firestore.FieldValue.delete(),
            })
        }

        operationCount++;

        if (operationCount == 500) {
            await batch.commit();
            batch = db.batch();
            operationCount = 0;
        }
    }

    if (operationCount > 0) {
        await batch.commit();
    }
}

changeAuthorIdField()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });
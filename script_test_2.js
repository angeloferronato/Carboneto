const admin = require('firebase-admin');
const serviceAccount = require('./private_key_firebase.json');
const { FieldPath, FieldValue } = require('firebase-admin/firestore');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function addUserSearch() {
    const exercisesSnap = await db.collection('allExercises').where('AuthorID', '==', 'admin').get();

    let batch = db.batch();
    

    for (const trainingDoc of trainingsSnap.docs) {
        const training = trainingDoc.data();

        if (training.AuthorID == 'admin') {
            batch.update(admin.firestore().collection('allExercises').where('Author'),
                {
                    AuthorID: '2RZob7cJyNXJpSNn7eJpxkxHPhx2',
                },
            )
            operationCount++;

            if (operationCount == 500) {
                await batch.commit();
                batch = db.batch();
                operationCount = 0;
            }
        }   
    }


    exercisesSnap.forEach(
        (doc) => batch.update(doc.ref, {
            AuthorID: '2RZob7cJyNXJpSNn7eJpxkxHPhx2',
        })
    )
    await batch.commit();

    
}

addUserSearch()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });
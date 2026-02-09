const admin = require('firebase-admin');
const serviceAccount = require('./private_key_firebase.json');
const { FieldPath, FieldValue } = require('firebase-admin/firestore');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function addUserSearch() {
    const usersSnap = await db.collection('users').get();

    let batch = db.batch();
    let operationCount = 0;

    for (const userDoc of usersSnap.docs) {
        const user = userDoc.data();

        if (user.Id !== 'nFykWztnGsdVWuhrdiH1aA9TAF32') {
            batch.set(admin.firestore().collection('users').doc(user.Id).collection('following').doc('nFykWztnGsdVWuhrdiH1aA9TAF32'),
                {
                    CreatedAt: FieldValue.serverTimestamp(),
                },
                {
                    merge: true,
                }
            )

            batch.set(admin.firestore().collection('users').doc('nFykWztnGsdVWuhrdiH1aA9TAF32').collection('followers').doc(user.Id),
                {
                    CreatedAt: FieldValue.serverTimestamp(),
                },
                {
                    merge: true,
                }
            )
            

            operationCount++;

            if (operationCount == 500) {
                await batch.commit();
                batch = db.batch();
                operationCount = 0;
            }
        }

        
    }

    if (operationCount > 0) {
        await batch.commit();
    }
}

addUserSearch()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });
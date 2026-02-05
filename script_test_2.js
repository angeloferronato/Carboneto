const admin = require('firebase-admin');
const serviceAccount = require('./private_key_firebase.json');

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


        batch.set(admin.firestore().collection('userSearch').doc(user.Id),
            {
                Username: user.Username,
                UsernameLower: user.Username.toLowerCase(),
                Name: user.Name,
                NameLower: user.Name.toLowerCase(),
                ProfilePicture: user.ProfilePicture,
                CreatedAt: admin.firestore.FieldValue.serverTimestamp(),
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
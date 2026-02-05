"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncFollowCount = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const firestore_2 = require("firebase-admin/firestore");
const firebase_1 = require("../firebase");
exports.syncFollowCount = (0, firestore_1.onDocumentWritten)('users/{userId}/followers/{followerId}', async (event) => {
    const userId = event.params.userId;
    const followerId = event.params.followerId;
    const beforeExists = event.data?.before.exists;
    const afterExists = event.data?.after.exists;
    if (beforeExists === afterExists)
        return null;
    const increment = afterExists ? 1 : -1;
    const batch = firebase_1.db.batch();
    batch.set(firebase_1.db.collection('users').doc(userId), {
        FollowersCount: firestore_2.FieldValue.increment(increment),
    }, { merge: true });
    batch.set(firebase_1.db.collection('users').doc(followerId), {
        FollowingCount: firestore_2.FieldValue.increment(increment),
    }, { merge: true });
    await batch.commit();
    return null;
});
//# sourceMappingURL=followers.js.map
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { FieldValue } from 'firebase-admin/firestore';
import { db } from '../firebase';

export const syncFollowCount = onDocumentWritten(
    'users/{userId}/followers/{followerId}',
    async (event) => {
        const userId = event.params.userId;
        const followerId = event.params.followerId;

        const beforeExists = event.data?.before.exists;
        const afterExists = event.data?.after.exists;

        if (beforeExists === afterExists) return null;

        const increment = afterExists ? 1 : -1;

        const batch = db.batch();

        batch.set(db.collection('users').doc(userId), {
            FollowersCount: FieldValue.increment(increment),
        }, { merge: true });

        batch.set(db.collection('users').doc(followerId), {
            FollowingCount: FieldValue.increment(increment),
        }, { merge:true })

        await batch.commit();

        return null;
    }
);
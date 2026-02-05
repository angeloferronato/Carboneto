import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../firebase";
import { UserData } from "../types";


export const syncSearchUser = onDocumentUpdated(
    "users/{userId}",
    async (event) => {
        const before = event.data?.before.data() as UserData | null;
        const after = event.data?.after.data() as UserData | null;

        if (!before || !after) return null;

        const relevantFields = ['Name', 'ProfilePicture', 'Username'];

        const hasRelevantChange = relevantFields.some(
            (field) => before[field] != after[field],
        )

        if (!hasRelevantChange) return null;

        await db.collection('userSearch').doc(event.params.userId).set({
            Name: after.Name,
            NameLower: after.Name.toLowerCase(),
            ProfilePicture: after.ProfilePicture,
            Username: after.Username,
            UsernameLower: after.Username.toLowerCase(),
        }, { merge: true })

        return null;
    }
)


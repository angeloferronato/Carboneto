import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../firebase";
import type { Creator } from "../types";

export const syncCreatorInTrainings = onDocumentUpdated(
  "users/{userId}",
  async (event) => {
    const userId = event.params.userId;

    const before = event.data?.before.data();
    const after = event.data?.after.data();

    if (!before || !after) {
      return null;
    }

    const relevantFields: (keyof Creator)[] = ['Name', 'ProfilePicture', 'IsVerified'];

    const hasRelevantChange = relevantFields.some(
        (field) => before[field] !== after[field]
    );

    if (!hasRelevantChange) return null;

    const creator: Creator = {
      Name: after.Name,
      ProfilePicture: after.ProfilePicture,
      IsVerified: after.IsVerified,
    };


    const trainingsSnap = await db
      .collection("allTrainings")
      .where("AuthorID", "==", userId)
      .get();

    if (trainingsSnap.empty) {
      return null;
    }


    let batch = db.batch();

    let batchCount = 0;

    for (const trainingDoc of trainingsSnap.docs) {
        batch.update(
            trainingDoc.ref,
            { Creator: creator }
        );
        batchCount++

        if (batchCount === 450) {
            await batch.commit();
            batchCount = 0;
            batch = db.batch();
        }
    }

    if (batchCount > 0) {
        await batch.commit();
    }

    return null;
  }
);
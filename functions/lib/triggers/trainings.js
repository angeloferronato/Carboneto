"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncCreatorInTrainings = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const firebase_1 = require("../firebase");
exports.syncCreatorInTrainings = (0, firestore_1.onDocumentUpdated)("users/{userId}", async (event) => {
    const userId = event.params.userId;
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after) {
        return null;
    }
    const relevantFields = ['Name', 'ProfilePicture', 'IsVerified'];
    const hasRelevantChange = relevantFields.some((field) => before[field] !== after[field]);
    if (!hasRelevantChange)
        return null;
    const creator = {
        Name: after.Name,
        ProfilePicture: after.ProfilePicture,
        IsVerified: after.IsVerified,
    };
    const trainingsSnap = await firebase_1.db
        .collection("allTrainings")
        .where("AuthorID", "==", userId)
        .get();
    if (trainingsSnap.empty) {
        return null;
    }
    let batch = firebase_1.db.batch();
    let batchCount = 0;
    for (const trainingDoc of trainingsSnap.docs) {
        batch.update(trainingDoc.ref, { Creator: creator });
        batchCount++;
        if (batchCount === 450) {
            await batch.commit();
            batchCount = 0;
            batch = firebase_1.db.batch();
        }
    }
    if (batchCount > 0) {
        await batch.commit();
    }
    return null;
});
//# sourceMappingURL=trainings.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateExerciseSearch = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const firebase_1 = require("../firebase");
exports.updateExerciseSearch = (0, firestore_1.onDocumentWritten)("allExercises/{exerciseId}", async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!after) {
        await firebase_1.db.collection('exercisesSearch').doc(event.params.exerciseId).delete();
        return null;
    }
    if (before) {
        const relevantFields = ['Title', 'Duration', 'Repetition', 'Creator', 'Thumbnail', 'Type'];
        const hasRelevantChange = relevantFields.some((field) => JSON.stringify(before[field]) !== JSON.stringify(after[field]));
        if (!hasRelevantChange)
            return null;
    }
    await firebase_1.db.collection('exercisesSearch').doc(event.params.exerciseId).set({
        AuthorID: after?.AuthorID,
        Title: after?.Title,
        Duration: after?.Duration,
        Repetition: after?.Repetition,
        Creator: after?.Creator,
        Thumbnail: after?.Thumbnail,
        Categories: after?.Categories,
        TitleLower: after?.Title.toLowerCase(),
    }, {
        merge: true,
    });
    return null;
});
//# sourceMappingURL=updateExerciseSearch.js.map
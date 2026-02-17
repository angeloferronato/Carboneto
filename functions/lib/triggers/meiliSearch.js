"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncMeiliTrainings = exports.syncMeiliExercises = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const meilisearch_1 = require("meilisearch");
const meiliClient = new meilisearch_1.MeiliSearch({
    host: 'https://shared-meredith-carboneto-2c512dda.koyeb.app/',
    apiKey: 'EDWxYEAJrvPoHIR-gHJSNS3-p6J80XASaechuGNXYIo',
});
function createSync(collectionName, indexName) {
    return (0, firestore_1.onDocumentWritten)(`${collectionName}/{docId}`, async (event) => {
        const docId = event.params.docId;
        const index = meiliClient.index(indexName);
        if (!event.data?.after.exists) {
            await index.deleteDocument(docId);
            return null;
        }
        const data = event.data?.after.data();
        const meiliDoc = {
            id: docId,
            ...data
        };
        await index.addDocuments([meiliDoc]);
        return null;
    });
}
exports.syncMeiliExercises = createSync('allExercises', 'exercises_index');
exports.syncMeiliTrainings = createSync('allTrainings', 'trainings_index');
//# sourceMappingURL=meiliSearch.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncMeiliTrainingLikes = exports.syncMeiliUsers = exports.syncMeiliCategories = exports.syncMeiliTrainings = exports.syncMeiliExercises = void 0;
// meiliSearch.ts
const firestore_1 = require("firebase-functions/v2/firestore");
const meilisearch_1 = require("meilisearch");
const meiliClient = new meilisearch_1.MeiliSearch({
    host: 'http://140.238.186.227:7700',
    apiKey: 'hGFUGI775FAI7TF976TFITUFUTFITtuf78',
});
function createSync(collectionName, indexName) {
    return (0, firestore_1.onDocumentWritten)(`${collectionName}/{docId}`, async (event) => {
        const docId = event.params.docId;
        const index = meiliClient.index(indexName);
        try {
            if (!event.data?.after.exists) {
                await index.deleteDocument(docId);
                return null;
            }
            const data = event.data?.after.data();
            // Adaptando para usar o campo ID que você prefere ou o docId
            // No Meilisearch, o campo 'id' é obrigatório como chave primária
            const meiliDoc = {
                id: docId,
                ...data,
            };
            await index.addDocuments([meiliDoc], { primaryKey: 'id' });
            return null;
        }
        catch (e) {
            console.error(`Erro na sincronização Meili: ${docId}`, e);
        }
    });
}
exports.syncMeiliExercises = createSync('allExercises', 'allExercises');
exports.syncMeiliTrainings = createSync('allTrainings', 'allTrainings');
exports.syncMeiliCategories = createSync('subCategories', 'subCategories');
exports.syncMeiliUsers = createSync('users', 'users');
exports.syncMeiliTrainingLikes = createSync('trainingLikes', 'trainingLikes');
//# sourceMappingURL=meiliSearch.js.map
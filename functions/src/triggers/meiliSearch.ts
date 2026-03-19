// meiliSearch.ts
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { MeiliSearch } from "meilisearch";

const meiliClient = new MeiliSearch({
    host: 'http://140.238.186.227:7700',
    apiKey: '', // Se quise a chave peça para os Donos do código(vulgo resenharapaze)
});

function createSync(collectionName: string, indexName: string) {
    return onDocumentWritten(`${collectionName}/{docId}`, async (event) => {
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
        } catch (e) {
            console.error(`Erro na sincronização Meili: ${docId}`, e);
        }
    });
}

export const syncMeiliExercises = createSync('allExercises', 'allExercises');
export const syncMeiliTrainings = createSync('allTrainings', 'allTrainings');
export const syncMeiliCategories = createSync('subCategories', 'subCategories');
export const syncMeiliUsers = createSync('users', 'users');
export const syncMeiliTrainingLikes = createSync('trainingLikes', 'trainingLikes');
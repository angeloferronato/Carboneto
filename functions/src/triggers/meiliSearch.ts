import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { MeiliSearch } from "meilisearch";

const meiliClient = new MeiliSearch({
    host: 'https://shared-meredith-carboneto-2c512dda.koyeb.app',
    apiKey: 'EDWxYEAJrvPoHIR-gHJSNS3-p6J80XASaechuGNXYIo',
})

function createSync(collectionName: string, indexName: string) {
    return onDocumentWritten(
        `${collectionName}/{docId}`,
        async (event) => {
            const docId = event.params.docId;
            const index = meiliClient.index(indexName);

            try {
                if (!event.data?.after.exists) {
                    console.log(`[SUCESSO] Deletando ${docId} do índice ${indexName}`);
                    await index.deleteDocument(docId);
                    return null;
                }

                const data = event.data?.after.data();

                const meiliDoc = {
                    id: docId,
                    ...data
                };

                console.log(`[TENTANDO] Enviando ${docId} para ${indexName}...`);

                await index.addDocuments([meiliDoc], { primaryKey: 'id' });
                console.log(`[SUCESSO] Documento ${docId} sincronizado com Meilisearch!`);
                return null;
            } catch (e) {
                console.error(`[ERRO FATAL] Falha ao sincronizar ${docId}:`, e);
            }
            
        }
    )
}

export const syncMeiliExercises = createSync('allExercises', 'exercises_index');
export const syncMeiliTrainings = createSync('allTrainings', 'trainings_index');
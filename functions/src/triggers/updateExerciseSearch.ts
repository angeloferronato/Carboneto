import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { db } from "../firebase";
import { ExerciseData } from "../types";

export const updateExerciseSearch = onDocumentWritten(
    "allExercises/{exerciseId}",
    async (event) => {
        const before = event.data?.before.data() as ExerciseData | undefined;
        const after = event.data?.after.data() as ExerciseData | undefined;

        if (!after) {
            await db.collection('exercisesSearch').doc(event.params.exerciseId).delete();
            return null;
        }

        if (before) {
            const relevantFields = ['Title', 'Duration', 'Repetition', 'Creator', 'Thumbnail', 'Type'];
    
            const hasRelevantChange = relevantFields.some(
                (field) => JSON.stringify(before[field]) !== JSON.stringify(after[field])
            );

            if (!hasRelevantChange) return null;
        }
        
        await db.collection('exercisesSearch').doc(event.params.exerciseId).set({
            AuthorID: after?.AuthorID,
            Title:  after?.Title,
            Duration: after?.Duration,
            Repetition: after?.Repetition,
            Creator:  after?.Creator,
            Thumbnail: after?.Thumbnail,
            Categories: after?.Categories,
            TitleLower: after?.Title.toLowerCase(),
        },
        {
            merge: true,
        });
        return null;

    }
)
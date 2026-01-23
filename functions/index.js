const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {setGlobalOptions} = require("firebase-functions/v2");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

setGlobalOptions({
  region: "southamerica-east1",
});

exports.syncCreatorData = onDocumentUpdated(
    "users/{userId}",
    async (event) => {
      const before = event.data.before.data();
      const after = event.data.after.data();
      const userId = event.params.userId;

      if (!before || !after) return null;

      const hasChanged =
        before.Name !== after.Name ||
        before.ProfilePicture !== after.ProfilePicture ||
        before.IsVerified !== after.IsVerified;

      if (!hasChanged) return null;

      const updatedCreator = {
        Name: after.Name,
        ProfilePicture: after.ProfilePicture,
        IsVerified: after.IsVerified,
      };

      const trainingsSnap = await db
          .collection("allTrainings")
          .where("AuthorID", "==", userId)
          .get();

      const batch = db.batch();
      trainingsSnap.forEach((doc) => {
        batch.update(doc.ref, {Creator: updatedCreator});
      });

      await batch.commit();
      return null;
    });

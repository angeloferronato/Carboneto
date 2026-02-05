"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncSearchUser = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const firebase_1 = require("../firebase");
exports.syncSearchUser = (0, firestore_1.onDocumentUpdated)("users/{userId}", async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after)
        return null;
    const relevantFields = ['Name', 'ProfilePicture', 'Username'];
    const hasRelevantChange = relevantFields.some((field) => before[field] != after[field]);
    if (!hasRelevantChange)
        return null;
    await firebase_1.db.collection('userSearch').doc(event.params.userId).set({
        Name: after.Name,
        NameLower: after.Name.toLowerCase(),
        ProfilePicture: after.ProfilePicture,
        Username: after.Username,
        UsernameLower: after.Username.toLowerCase(),
    }, { merge: true });
    return null;
});
//# sourceMappingURL=updateUserSearch.js.map
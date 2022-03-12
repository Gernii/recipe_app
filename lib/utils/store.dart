import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> updateFavorites(String uid, String recipeId) {
  DocumentReference favoritesReference =
      FirebaseFirestore.instance.collection('users').doc(uid);

  return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
    if (postSnapshot.exists) {
      // Extend 'favorites' if the list does not contain the recipe ID:
      if (!postSnapshot['favorites'].contains(recipeId)) {
        tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayUnion([recipeId])
        });
        // Delete the recipe ID from 'favorites':
      } else {
        tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayRemove([recipeId])
        });
      }
    } else {
      // Create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document:
      tx.set(favoritesReference, {
        'favorites': [recipeId]
      });
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    return false;
  });
}

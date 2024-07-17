import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the Firebase authentication instance.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Provider for the Firestore instance.
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// Provider for the Firestore document reference of the current user.
final userRefFirestore = Provider<DocumentReference<UserModel>>(
  (ref) => ref
      .read(firestoreProvider)
      .collection('users')
      .doc(ref.read(firebaseAuthProvider).currentUser?.uid)
      .withConverter(
        fromFirestore: (snapshot, _) => UserModel.fromMap(snapshot.data()!),
        toFirestore: (model, _) => model.toMap(),
      ),
);

/// Provider for the Firestore document reference of the current user's favorites.
final userFavRefFirestore = Provider<DocumentReference<Set<String>>>(
  (ref) => ref
      .read(firestoreProvider)
      .collection('usersFavorites')
      .doc(ref.read(firebaseAuthProvider).currentUser?.uid)
      .withConverter(
        fromFirestore: (snapshot, _) => Set<String>.from(snapshot.data()!['items']),
        toFirestore: (model, _) => {'items': List.from(model)},
      ),
);

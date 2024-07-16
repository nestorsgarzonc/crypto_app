import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
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

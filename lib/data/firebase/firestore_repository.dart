import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreRepository<T> {
  FirestoreRepository({
    required this.companyUuid,
    required this.resourcePath,
  });

  final String companyUuid;
  final String resourcePath;
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T value);

  String get collectionPath => '/companies/$companyUuid/$resourcePath';

  CollectionReference<T> get collection =>
      FirebaseFirestore.instance.collection(collectionPath).withConverter(
            fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
            toFirestore: (value, _) => toJson(value),
          );
}

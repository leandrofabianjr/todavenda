import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/companies/models/Company.dart';
import 'package:todavenda/companies/services/companies_repository.dart';

class CompaniesRepositoryFirestore implements CompaniesRepository {
  static const companiesCollectionPath = 'companies';

  CollectionReference<Company?> get companiesCollection =>
      FirebaseFirestore.instance
          .collection(companiesCollectionPath)
          .withConverter(
            fromFirestore: (snapshot, _) => Company.fromJson(snapshot.data()!),
            toFirestore: (value, _) => value?.toJson() ?? {},
          );

  @override
  Future<List<Company>> loadByUser({required String userUuid}) async {
    final snapshot =
        await companiesCollection.where('users', arrayContains: userUuid).get();
    return snapshot.docs.map((e) => e.data()!).toList();
  }
}

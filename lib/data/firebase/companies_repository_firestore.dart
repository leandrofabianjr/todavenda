import 'package:todavenda/companies/models/company.dart';
import 'package:todavenda/companies/services/companies_repository.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';

class CompaniesRepositoryFirestore extends FirestoreRepository<Company>
    implements CompaniesRepository {
  CompaniesRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: '');

  @override
  String get collectionPath => '/companies';

  @override
  Future<Company> load() async {
    final snapshot = await collection.doc(companyUuid).get();
    return snapshot.data()!;
  }

  @override
  Company fromJson(Map<String, dynamic> json) => Company.fromJson(json);

  @override
  Map<String, dynamic> toJson(Company value) => value.toJson();
}

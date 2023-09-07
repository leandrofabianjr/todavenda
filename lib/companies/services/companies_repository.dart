import '../models/Company.dart';

abstract class CompaniesRepository {
  Future<List<Company>> loadByUser({required String userUuid});
}

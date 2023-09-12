import '../models/company.dart';

abstract class CompaniesRepository {
  Future<Company> load();
}

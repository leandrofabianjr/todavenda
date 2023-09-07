import '../models/client.dart';

abstract class ClientsRepository {
  Future<Client> loadClientByUuid(String uuid);

  Future<List<Client>> loadClients({required String companyUuid});

  Future<Client> createClient({
    required String companyUuid,
    required String name,
    String? phone,
    String? address,
    String? observation,
  });

  Future<void> removeClient(String uuid);
}

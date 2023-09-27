import '../models/client.dart';

abstract class ClientsRepository {
  Future<Client> loadClientByUuid(String uuid);

  Future<List<Client>> loadClients();

  Future<List<Client>> searchClients({required String term});

  Future<Client> saveClient({
    String? uuid,
    required String name,
    String? phone,
    String? address,
    String? observation,
  });

  Future<void> removeClient(String uuid);
}

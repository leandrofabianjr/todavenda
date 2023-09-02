import '../models/client.dart';

abstract class ClientsRepository {
  Future<Client> loadClientByUuid(String uuid);

  Future<List<Client>> loadClients();

  Future<Client> createClient({
    required String name,
  });

  Future<void> removeClient(String uuid);
}

import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/clients/services/client_on_credit_owings_repository.dart';
import 'package:todavenda/sales/sales.dart';

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

  Future<Client> addOwing(Client client, Payment relativeTo);

  ClientOnCreditOwingsRepository owingsRepository(
    Client client,
    String productUuid,
  );
}

import 'package:collection/collection.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ClientsRepositoryFirestore extends FirestoreRepository<Client>
    implements ClientsRepository {
  ClientsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'clients');

  List<Client> _clients = [];

  @override
  Client fromJson(Map<String, dynamic> json) => Client.fromJson(json);

  @override
  Map<String, dynamic> toJson(Client value) => value.toJson();

  @override
  Future<Client> saveClient({
    String? uuid,
    required String name,
    String? phone,
    String? address,
    String? observation,
  }) async {
    final client = Client(
      uuid: uuid ?? _uuid.v4(),
      name: name,
      phone: phone,
      address: address,
      observation: observation,
    );
    await collection.doc(client.uuid).set(client);

    final index = _clients.indexOf(client);
    if (index == -1) {
      _clients.add(client);
      _clients.sortBy((e) => e.name);
    } else {
      _clients[index] = client;
    }
    return client;
  }

  @override
  Future<Client> loadClientByUuid(String uuid) async {
    final client = await collection.doc(uuid).get();
    return client.data()!;
  }

  @override
  Future<List<Client>> loadClients() async {
    if (_clients.isEmpty) {
      final snapshot = await collection.get();
      _clients = snapshot.docs.map((e) => e.data()).toList();
      _clients.sortBy((e) => e.name);
    }
    return _clients;
  }

  @override
  Future<void> removeClient(String uuid) async {
    await collection.doc(uuid).delete();
    _clients.removeWhere((e) => e.uuid == uuid);
  }

  @override
  Future<List<Client>> searchClients({required String term}) async => _clients
      .where((p) => p.name.contains(RegExp(term, caseSensitive: false)))
      .toList();
}

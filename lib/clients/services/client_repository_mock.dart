import 'package:uuid/uuid.dart';

import '../models/client.dart';
import 'client_repository.dart';

const _delay = Duration(milliseconds: 800);

var uuid = const Uuid();

final mockClients = [
  Client(
    uuid: uuid.v4(),
    name: 'João',
  ),
  Client(
    uuid: uuid.v4(),
    name: 'Maria',
  ),
  Client(
    uuid: uuid.v4(),
    name: 'José',
  ),
];

class ClientsRepositoryMock implements ClientsRepository {
  final _clients = mockClients;

  Future<T> _delayed<T>(T Function() callback) {
    return Future.delayed(_delay, callback);
  }

  @override
  Future<Client> loadClientByUuid(String uuid) async =>
      _delayed(() => _clients.firstWhere((p) => p.uuid == uuid));

  @override
  Future<List<Client>> loadClients() => _delayed(() => _clients);

  @override
  Future<Client> createClient({required String name}) async {
    final client = Client(
      uuid: uuid.v4(),
      name: name,
    );
    await _delayed(() => _clients.add(client));
    return client;
  }

  @override
  Future<void> removeClient(String uuid) async =>
      _delayed(() => _clients.removeWhere((p) => p.uuid == uuid));
}

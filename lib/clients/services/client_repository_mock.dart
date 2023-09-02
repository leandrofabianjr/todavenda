import 'package:uuid/uuid.dart';

import '../models/client.dart';
import 'client_repository.dart';

const _delay = Duration(milliseconds: 800);

var uuid = const Uuid();

final mockClients = [
  Client(
      uuid: uuid.v4(),
      name: 'João',
      address: 'Rua dos Bobos, nº 0',
      phone: '41999999999',
      observation: 'É um cara legal'),
  Client(
    uuid: uuid.v4(),
    name: 'Maria',
    address: 'Rua Santo Amaro, nº 23',
    observation: 'Não tem telefone? 🤨',
  ),
  Client(
    uuid: uuid.v4(),
    name: 'José',
    phone: '5488888888',
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
  Future<Client> createClient({
    required String name,
    String? phone,
    String? address,
    String? observation,
  }) async {
    final client = Client(
      uuid: uuid.v4(),
      name: name,
      phone: phone,
      address: address,
      observation: observation,
    );
    await _delayed(() => _clients.add(client));
    return client;
  }

  @override
  Future<void> removeClient(String uuid) async =>
      _delayed(() => _clients.removeWhere((p) => p.uuid == uuid));
}

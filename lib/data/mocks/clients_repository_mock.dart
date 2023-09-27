import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../../clients/models/client.dart';
import '../../clients/services/clients_repository.dart';

const _delay = Duration(milliseconds: 800);

const _uuid = Uuid();

final mockClients = [
  Client(
      uuid: _uuid.v4(),
      name: 'João',
      address: 'Rua dos Bobos, nº 0',
      phone: '41999999999',
      observation: 'É um cara legal'),
  Client(
    uuid: _uuid.v4(),
    name: 'Maria',
    address: 'Rua Santo Amaro, nº 23',
    observation: 'Não tem telefone? 🤨',
  ),
  Client(
    uuid: _uuid.v4(),
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
  Future<List<Client>> searchClients({required String term}) async => _delayed(
        () => _clients
            .where((p) => p.name.contains(RegExp(term, caseSensitive: false)))
            .toList(),
      );

  @override
  Future<List<Client>> loadClients() => _delayed(() => _clients);

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

    final index = _clients.indexOf(client);
    if (index == -1) {
      _clients.add(client);
      _clients.sortBy((e) => e.name);
    } else {
      _clients[index] = client;
    }

    return await _delayed(() => client);
  }

  @override
  Future<void> removeClient(String uuid) async =>
      _delayed(() => _clients.removeWhere((p) => p.uuid == uuid));
}

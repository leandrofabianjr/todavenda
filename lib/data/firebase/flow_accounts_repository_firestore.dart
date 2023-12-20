import 'package:collection/collection.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class FlowAccountsRepositoryFirestore extends FirestoreRepository<FlowAccount>
    implements FlowAccountsRepository {
  var _accounts = <FlowAccount>[];

  FlowAccountsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'flowAccounts');

  @override
  FlowAccount fromJson(Map<String, dynamic> json) => FlowAccount(
        uuid: json['uuid'],
        name: json['name'],
        description: json['description'],
        currentAmount: (json['currentAmount'] ?? 0).toDouble(),
      );

  @override
  Map<String, dynamic> toJson(FlowAccount value) => value.toJson();

  @override
  Future<FlowAccount> save({
    String? uuid,
    required String name,
    String? description,
    required double currentAmount,
  }) async {
    final account = FlowAccount(
      uuid: uuid ?? _uuid.v4(),
      name: name,
      description: description,
      currentAmount: currentAmount,
    );
    await collection.doc(account.uuid).set(account);
    final index = _accounts.indexOf(account);
    if (index == -1) {
      _accounts.add(account);
      _accounts.sortBy((e) => e.name);
    } else {
      _accounts[index] = account;
    }
    return account;
  }

  @override
  Future<List<FlowAccount>> load() async {
    if (_accounts.isEmpty) {
      final snapshot = await collection.get();
      _accounts = snapshot.docs.map((e) => e.data()).toList();
      _accounts.sortBy((e) => e.name);
    }
    return _accounts;
  }

  @override
  Future<FlowAccount> loadByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<void> remove(String uuid) async {
    await collection.doc(uuid).delete();
    _accounts.removeWhere((e) => e.uuid == uuid);
  }
}

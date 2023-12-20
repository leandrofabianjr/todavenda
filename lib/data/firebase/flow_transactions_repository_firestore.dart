import 'package:collection/collection.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class FlowTransactionsRepositoryFirestore
    extends FirestoreRepository<FlowTransaction>
    implements FlowTransactionsRepository {
  var _accounts = <FlowTransaction>[];

  FlowTransactionsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'flowTransactions');

  @override
  FlowTransaction fromJson(Map<String, dynamic> json) => FlowTransaction(
        uuid: json['uuid'],
        description: json['description'],
        observation: json['observation'],
        amount: (json['amount'] ?? 0).toDouble(),
        createdAt: DateTimeConverter.parse(
            DateTimeConverterType.firestore, json['createdAt']),
      );

  @override
  Map<String, dynamic> toJson(FlowTransaction value) => {
        'uuid': value.uuid,
        'description': value.description,
        if (value.observation != null && value.observation!.isNotEmpty)
          'observation': value.observation,
        'amount': value.amount,
        'createdAt': DateTimeConverter.to(
            DateTimeConverterType.firestore, value.createdAt),
      };

  @override
  Future<FlowTransaction> save({
    String? uuid,
    required String description,
    String? observation,
    required double amount,
    required DateTime createdAt,
  }) async {
    final account = FlowTransaction(
      uuid: uuid ?? _uuid.v4(),
      description: description,
      observation: observation,
      amount: amount,
      createdAt: createdAt,
    );
    await collection.doc(account.uuid).set(account);
    final index = _accounts.indexOf(account);
    if (index == -1) {
      _accounts.add(account);
      _accounts.sortBy((e) => e.createdAt);
    } else {
      _accounts[index] = account;
    }
    return account;
  }

  @override
  Future<List<FlowTransaction>> load() async {
    if (_accounts.isEmpty) {
      final snapshot = await collection.get();
      _accounts = snapshot.docs.map((e) => e.data()).toList();
      _accounts.sortBy((e) => e.createdAt);
    }
    return _accounts;
  }

  @override
  Future<FlowTransaction> loadByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<void> remove(String uuid) async {
    await collection.doc(uuid).delete();
    _accounts.removeWhere((e) => e.uuid == uuid);
  }
}

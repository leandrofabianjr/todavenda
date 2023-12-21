import 'package:collection/collection.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/data/firebase/flow_accounts_repository_firestore.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class FlowTransactionsRepositoryFirestore
    extends FirestoreRepository<FlowTransaction>
    implements FlowTransactionsRepository {
  var _transactions = <FlowTransaction>[];
  var _accounts = <FlowAccount>[];

  FlowTransactionsRepositoryFirestore(
    String companyUuid, {
    required this.accountsRepository,
  }) : super(companyUuid: companyUuid, resourcePath: 'flowTransactions');

  FlowAccountsRepositoryFirestore accountsRepository;

  @override
  FlowTransaction fromJson(Map<String, dynamic> json) {
    final account = _accounts.firstWhere((c) => c.uuid == json['accountUuid']);
    return FlowTransaction(
      uuid: json['uuid'],
      type: FlowTransactionTypeX.parse(json['type']),
      description: json['description'],
      observation: json['observation'],
      amount: (json['amount'] ?? 0).toDouble(),
      createdAt: DateTimeConverter.parse(
          DateTimeConverterType.firestore, json['createdAt']),
      account: account,
    );
  }

  @override
  Map<String, dynamic> toJson(FlowTransaction value) => {
        'uuid': value.uuid,
        'type': value.type.name,
        'description': value.description,
        if (value.observation != null && value.observation!.isNotEmpty)
          'observation': value.observation,
        'amount': value.amount,
        'createdAt': DateTimeConverter.to(
            DateTimeConverterType.firestore, value.createdAt),
        'accountUuid': value.account.uuid,
      };

  @override
  Future<FlowTransaction> save({
    String? uuid,
    required FlowTransactionType type,
    required String description,
    String? observation,
    required double amount,
    required DateTime createdAt,
    required FlowAccount account,
  }) async {
    final transaction = FlowTransaction(
      uuid: uuid ?? _uuid.v4(),
      type: type,
      description: description,
      observation: observation,
      amount: amount,
      createdAt: createdAt,
      account: account,
    );
    await collection.doc(transaction.uuid).set(transaction);
    final index = _transactions.indexOf(transaction);
    if (index == -1) {
      _transactions.add(transaction);
      _transactions.sortBy((e) => e.createdAt);
    } else {
      _transactions[index] = transaction;
    }

    final multiplier = type == FlowTransactionType.incoming ? -1 : 1;

    account = account.copyWith(
      currentAmount: account.currentAmount + (amount * multiplier),
    );

    await accountsRepository.saveInstance(account);

    transaction.copyWith(account: account);

    return transaction;
  }

  @override
  Future<List<FlowTransaction>> load() async {
    _accounts = await accountsRepository.load();
    if (_transactions.isEmpty) {
      final snapshot = await collection.get();
      _transactions = snapshot.docs.map((e) => e.data()).toList();
      _transactions.sortBy((e) => e.createdAt);
    }
    return _transactions;
  }

  @override
  Future<FlowTransaction> loadByUuid(String uuid) async {
    _accounts = await accountsRepository.load();
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<void> remove(String uuid) async {
    await collection.doc(uuid).delete();
    _transactions.removeWhere((e) => e.uuid == uuid);
  }
}

import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';

abstract class FlowTransactionsRepository {
  Future<List<FlowTransaction>> load();

  Future<FlowTransaction> loadByUuid(String uuid);

  Future<FlowTransaction> save({
    String? uuid,
    required FlowTransactionType type,
    required String description,
    String? observation,
    required double amount,
    required DateTime createdAt,
    required FlowAccount account,
  });

  Future<void> remove(String uuid);
}

import 'package:todavenda/flow/models/flow_account.dart';

abstract class FlowAccountsRepository {
  Future<List<FlowAccount>> load();

  Future<FlowAccount> loadByUuid(String uuid);

  Future<FlowAccount> save({
    String? uuid,
    required String name,
    String? description,
    required double currentValue,
  });

  Future<void> remove(String uuid);
}

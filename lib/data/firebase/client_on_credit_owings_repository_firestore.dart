import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/clients/services/client_on_credit_owings_repository.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/services.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ClientOnCreditOwingsRepositoryFirestore
    extends FirestoreRepository<OnCreditOwingPayment>
    implements ClientOnCreditOwingsRepository {
  static const currentSessionUuid = 'current';

  ClientOnCreditOwingsRepositoryFirestore(
    String companyUuid, {
    required this.client,
    required this.sessionsRepository,
  }) : super(
          companyUuid: companyUuid,
          resourcePath: 'clients/${client.uuid}/onCrediOwingPayments',
        );

  final Client client;
  final SessionsRepository sessionsRepository;

  @override
  OnCreditOwingPayment fromJson(Map<String, dynamic> json) =>
      OnCreditOwingPayment.fromJson(json, DateTimeConverterType.firestore);

  @override
  Map<String, dynamic> toJson(OnCreditOwingPayment value) =>
      value.toJson(DateTimeConverterType.firestore);

  @override
  Future<List<OnCreditOwingPayment>> load(
      {String? sessionUuid, Client? client}) async {
    final query = collection.where(
      'type',
      isEqualTo: SessionMovementType.onCreditOwingPayment.name,
    );
    if (sessionUuid != null) {
      query.where('sessionUuid', isEqualTo: sessionUuid);
    }
    if (client != null) {
      query.where('saleUuid', isEqualTo: client.uuid);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<OnCreditOwingPayment> loadByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<OnCreditOwingPayment> save({
    String? uuid,
    required String sessionUuid,
    required Client client,
    required double amount,
    required PaymentType paymentType,
  }) async {
    final movement = OnCreditOwingPayment(
      uuid: _uuid.v4(),
      type: SessionMovementType.payment,
      sessionUuid: sessionUuid,
      createdAt: DateTime.now(),
      client: client,
      amount: amount,
      paymentType: paymentType,
    );
    await collection.doc(movement.uuid).set(movement);
    if (paymentType == PaymentType.cash) {
      final session =
          (await sessionsRepository.current)!.afterCashPayment(amount);
      await sessionsRepository.update(session);
    }
    return movement;
  }
}

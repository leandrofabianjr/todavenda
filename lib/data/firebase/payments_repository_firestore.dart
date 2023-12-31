import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/data/firebase/sessions_repository_firestore.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/services.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class PaymentsRepositoryFirestore extends FirestoreRepository<Payment>
    implements PaymentsRepository {
  static const currentSessionUuid = 'current';

  PaymentsRepositoryFirestore(
    String companyUuid, {
    required this.sessionsRepository,
  }) : super(companyUuid: companyUuid, resourcePath: 'sessionMovements');

  final SessionsRepositoryFirestore sessionsRepository;

  @override
  Payment fromJson(Map<String, dynamic> json) =>
      Payment.fromJson(json, DateTimeConverterType.firestore);

  @override
  Map<String, dynamic> toJson(Payment value) =>
      value.toJson(DateTimeConverterType.firestore);

  @override
  Future<Payment> create({
    required String sessionUuid,
    required Sale sale,
    required PaymentType paymentType,
    required double amount,
  }) async {
    final movement = Payment(
      uuid: _uuid.v4(),
      type: SessionMovementType.payment,
      sessionUuid: sessionUuid,
      createdAt: DateTime.now(),
      saleUuid: sale.uuid!,
      paymentType: paymentType,
      amount: amount,
    );
    await collection.doc(movement.uuid).set(movement);
    if (paymentType == PaymentType.cash) {
      final session =
          (await sessionsRepository.current)!.afterCashPayment(amount);
      await sessionsRepository.update(session);
    }
    return movement;
  }

  @override
  Future<Payment?> getByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data();
  }

  @override
  Future<List<Payment>> list({
    List<String>? uuids,
    String? sessionUuid,
    String? saleUuid,
  }) async {
    final query = collection.where(
      'type',
      isEqualTo: SessionMovementType.payment.name,
    );
    if (uuids != null && uuids.isNotEmpty) {
      query.where('uuid', whereIn: uuids);
    }
    if (sessionUuid != null) {
      query.where('sessionUuid', isEqualTo: sessionUuid);
    }
    if (saleUuid != null) {
      query.where('saleUuid', isEqualTo: saleUuid);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<void> remove(String? uuid) async {
    await collection.doc(uuid).delete();
  }
}

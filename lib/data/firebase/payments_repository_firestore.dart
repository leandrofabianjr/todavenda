import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/services.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class PaymentsRepositoryFirestore extends FirestoreRepository<Payment>
    implements PaymentsRepository {
  static const currentSessionUuid = 'current';

  PaymentsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'sessionMovements');

  @override
  Payment fromJson(Map<String, dynamic> json) => Payment.fromJson(json);

  @override
  Map<String, dynamic> toJson(Payment value) => value.toJson();

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
    return movement;
  }

  @override
  Future<Payment?> getByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data();
  }

  @override
  Future<List<Payment>> list({
    String? sessionUuid,
    String? saleUuid,
  }) async {
    final query = collection.where(
      'type',
      isEqualTo: SessionMovementType.payment.value,
    );
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

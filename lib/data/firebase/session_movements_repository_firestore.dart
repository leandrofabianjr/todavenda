import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/session_movements_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SessionMovementsRepositoryFirestore
    extends FirestoreRepository<SessionMovement>
    implements SessionMovementsRepository {
  static const currentSessionUuid = 'current';

  SessionMovementsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'sessionMovements');

  @override
  SessionMovement fromJson(Map<String, dynamic> json) =>
      SessionMovement.fromJson(json);

  @override
  Map<String, dynamic> toJson(SessionMovement value) => value.toJson();

  @override
  Future<Payment> createPayment({
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
  Future<SessionSupply> createSupply({
    required String sessionUuid,
    required double amount,
  }) async {
    final movement = SessionSupply(
      uuid: _uuid.v4(),
      type: SessionMovementType.payment,
      sessionUuid: sessionUuid,
      createdAt: DateTime.now(),
      amount: amount,
    );
    await collection.doc(movement.uuid).set(movement);
    return movement;
  }

  @override
  Future<SessionPickUp> createPickUp({
    required String sessionUuid,
    required double amount,
  }) async {
    final movement = SessionPickUp(
      uuid: _uuid.v4(),
      type: SessionMovementType.payment,
      sessionUuid: sessionUuid,
      createdAt: DateTime.now(),
      amount: amount,
    );
    await collection.doc(movement.uuid).set(movement);
    return movement;
  }

  @override
  Future<SessionMovement?> getByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data();
  }

  @override
  Future<List<SessionMovement>> list({
    String? sessionUuid,
    SessionMovementType? type,
    String? saleUuid,
  }) async {
    final query = collection;
    if (sessionUuid != null) {
      query.where('sessionUuid', isEqualTo: sessionUuid);
    }
    if (type != null) {
      query.where('type', isEqualTo: type.value);
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

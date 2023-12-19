import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/services.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SessionPickUpsRepositoryFirestore
    extends FirestoreRepository<SessionPickUp>
    implements SessionPickUpsRepository {
  SessionPickUpsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'sessionMovements');

  @override
  SessionPickUp fromJson(Map<String, dynamic> json) =>
      SessionPickUp.fromJson(json, DateTimeConverterType.firestore);

  @override
  Map<String, dynamic> toJson(SessionPickUp value) =>
      value.toJson(DateTimeConverterType.firestore);

  @override
  Future<SessionPickUp> create({
    required String sessionUuid,
    required double amount,
  }) async {
    final movement = SessionPickUp(
      uuid: _uuid.v4(),
      sessionUuid: sessionUuid,
      createdAt: DateTime.now(),
      amount: amount,
    );
    await collection.doc(movement.uuid).set(movement);
    return movement;
  }

  @override
  Future<SessionPickUp?> getByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data();
  }

  @override
  Future<List<SessionPickUp>> list({
    String? sessionUuid,
    String? saleUuid,
  }) async {
    final query = collection.where(
      'type',
      isEqualTo: SessionMovementType.payment.name,
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

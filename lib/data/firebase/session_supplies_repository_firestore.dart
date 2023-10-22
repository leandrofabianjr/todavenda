import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/services.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SessionSuppliesRepositoryFirestore
    extends FirestoreRepository<SessionSupply>
    implements SessionSuppliesRepository {
  SessionSuppliesRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'sessionMovements');

  @override
  SessionSupply fromJson(Map<String, dynamic> json) => SessionSupply(
        uuid: json['uuid'],
        sessionUuid: json['sessionUuid'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        amount: json['amount'],
      );

  @override
  Map<String, dynamic> toJson(SessionSupply value) => {
        ...value.toJson(DateTimeConverterType.firestore),
        'amount': value.amount,
      };

  @override
  Future<SessionSupply> create({
    required String sessionUuid,
    required double amount,
  }) async {
    final movement = SessionSupply(
      uuid: _uuid.v4(),
      sessionUuid: sessionUuid,
      createdAt: DateTime.now(),
      amount: amount,
    );
    await collection.doc(movement.uuid).set(movement);
    return movement;
  }

  @override
  Future<SessionSupply?> getByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data();
  }

  @override
  Future<List<SessionSupply>> list({
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

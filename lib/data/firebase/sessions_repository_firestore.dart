import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/services.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SessionsRepositoryFirestore extends FirestoreRepository<Session>
    implements SessionsRepository {
  static const currentSessionUuid = 'current';

  SessionsRepositoryFirestore(
    String companyUuid, {
    required this.sessionSuppliesRepository,
    required this.sessionPickUpsRepository,
  }) : super(companyUuid: companyUuid, resourcePath: 'sessions');

  final SessionSuppliesRepository sessionSuppliesRepository;
  final SessionPickUpsRepository sessionPickUpsRepository;

  @override
  Session fromJson(Map<String, dynamic> json) => Session(
        uuid: json['uuid'],
        currentAmount: double.tryParse(json['currentAmount'].toString()) ?? 0,
        supplyAmount: double.tryParse(json['supplyAmount'].toString()) ?? 0,
        pickUpAmount: double.tryParse(json['pickUpAmount'].toString()) ?? 0,
        closingAmount: double.tryParse(json['closingAmount'].toString()) ?? 0,
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        closedAt: json['closedAt'] == null
            ? null
            : (json['closedAt'] as Timestamp).toDate(),
      );

  @override
  Map<String, dynamic> toJson(Session value) => {
        'uuid': value.uuid,
        'openingAmount': value.openingAmount,
        'closingAmount': value.closingAmount,
        'currentAmount': value.currentAmount,
        'supplyAmount': value.supplyAmount,
        'pickUpAmount': value.pickUpAmount,
        'createdAt': value.createdAt,
        'closedAt': value.closedAt,
      };

  Session? _current;

  @override
  Future<Session?> get current async {
    if (_current != null) return _current;

    final snapshot = await collection.doc(currentSessionUuid).get();
    return snapshot.data();
  }

  @override
  Future<bool> get hasCurrentSession async => (await current) != null;

  @override
  Future<Session?> getByUuid(String uuid) async {
    final session = await current;
    if (session != null && uuid == session.uuid) {
      return current;
    }
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data();
  }

  @override
  Future<List<Session>> list() async {
    final snapshot = await collection.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<Session> create({double? openingAmount}) async {
    final session = Session(
      uuid: _uuid.v4(),
      createdAt: DateTime.now(),
      openingAmount: openingAmount ?? 0,
      currentAmount: openingAmount ?? 0,
    );
    await collection.doc(currentSessionUuid).set(session);
    _current = session;
    return session;
  }

  @override
  Future<Session> update(Session updatedSession) async {
    await collection.doc(currentSessionUuid).set(updatedSession);
    _current = updatedSession;
    return updatedSession;
  }

  @override
  Future<Session> close({double? closingAmount}) async {
    final session = (await current)!;
    final closedSession = session.copyWith(
      closingAmount: closingAmount,
      closedAt: DateTime.now(),
    );
    final transaction = initTransaction();
    transaction.set(collection.doc(closedSession.uuid), closedSession);
    transaction.delete(collection.doc(currentSessionUuid));
    await transaction.commit();
    _current = null;
    return session;
  }

  @override
  Future<Session> createSupply(double amount) async {
    final session = (await current)!;
    await sessionSuppliesRepository.create(
      sessionUuid: session.uuid,
      amount: amount,
    );
    return update(session.afterSupply(amount));
  }

  @override
  Future<Session> createPickUp(double amount) async {
    final session = (await current)!;
    await sessionPickUpsRepository.create(
      sessionUuid: session.uuid,
      amount: amount,
    );
    return update(session.afterPickUp(amount));
  }
}

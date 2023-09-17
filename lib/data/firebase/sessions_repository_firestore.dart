import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/sessions_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SessionsRepositoryFirestore extends FirestoreRepository<Session>
    implements SessionsRepository {
  static const currentSessionUuid = 'current';

  SessionsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'sessions');

  @override
  Session fromJson(Map<String, dynamic> json) => Session.fromJson(json);

  @override
  Map<String, dynamic> toJson(Session value) => value.toJson();

  @override
  Future<Session?> get current => getByUuid(currentSessionUuid);

  @override
  Future<bool> get hasCurrentSession async => (await current) != null;

  @override
  Future<Session?> getByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data();
  }

  @override
  Future<List<Session>> list() async {
    final snapshot = await collection.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<Session> create() async {
    final session = Session(
      uuid: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    await collection.doc(currentSessionUuid).set(session);
    return session;
  }

  @override
  Future<Session> update(Session updatedSession) async {
    await collection.doc(updatedSession.uuid).set(updatedSession);
    return updatedSession;
  }

  @override
  Future<Session> close() async {
    final session = (await current)!;
    await collection.doc(session.uuid).set(session);
    return session;
  }
}

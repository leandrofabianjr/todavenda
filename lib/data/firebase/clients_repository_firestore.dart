import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ClientsRepositoryFirestore implements ClientsRepository {
  static const clientCollectionPath = 'clients';

  CollectionReference<Client?> get clientCollection =>
      FirebaseFirestore.instance.collection(clientCollectionPath).withConverter(
            fromFirestore: (snapshot, _) => Client.fromJson(snapshot.data()),
            toFirestore: (value, _) => value?.toJson() ?? {},
          );

  @override
  Future<Client> createClient({
    required String companyUuid,
    required String name,
    String? phone,
    String? address,
    String? observation,
  }) async {
    final client = Client(
      companyUuid: companyUuid,
      uuid: _uuid.v4(),
      name: name,
      phone: phone,
      address: address,
      observation: observation,
    );
    await clientCollection.doc(client.uuid).set(client);
    return client;
  }

  @override
  Future<Client> loadClientByUuid(String uuid) async {
    final client = await clientCollection.doc(uuid).get();
    return client.data()!;
  }

  @override
  Future<List<Client>> loadClients({required String companyUuid}) async {
    final snapshot = await clientCollection
        .where('companyUuid', isEqualTo: companyUuid)
        .get();
    return snapshot.docs.map((e) => e.data()!).toList();
  }

  @override
  Future<void> removeClient(String uuid) async {
    await clientCollection.doc().delete();
  }
}

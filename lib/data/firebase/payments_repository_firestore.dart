import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class PaymentsRepositoryFirestore extends FirestoreRepository<Payment>
    implements PaymentsRepository {
  var _payments = <Payment>[];

  PaymentsRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'payments');

  @override
  fromJson(Map<String, dynamic> json) => Payment.fromJson(json);

  @override
  Map<String, dynamic> toJson(Payment value) => value.toJson();

  @override
  Future<List<Payment>> load() async {
    if (_payments.isEmpty) {
      final snapshot = await collection.get();
      _payments = snapshot.docs.map((e) => e.data()).toList();
    }
    return _payments;
  }

  @override
  Future<Payment> create({
    required Sale sale,
    required PaymentType type,
    required double value,
  }) async {
    final payment = Payment(
      uuid: _uuid.v4(),
      type: type,
      value: value,
      createdAt: DateTime.now(),
    );
    await collection.doc(payment.uuid).set(payment);
    _payments.add(payment);
    return payment;
  }
}

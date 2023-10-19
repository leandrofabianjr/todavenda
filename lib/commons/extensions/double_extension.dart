import 'package:todavenda/commons/commons.dart';

extension DoubleExtension on double {
  String toCurrency() => CurrencyFormatter().formatPtBr(this);
}

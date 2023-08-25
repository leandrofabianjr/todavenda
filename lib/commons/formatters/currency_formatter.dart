import 'package:intl/intl.dart';

class CurrencyFormatter {
  double strToDouble(String? value) {
    if (value == null) return 0.0;

    final digits = value.replaceAll(RegExp(r"\D"), "");
    final doubleValue =
        '${digits.substring(0, digits.length - 2)}.${digits.substring(digits.length - 2, digits.length)}';

    return double.tryParse(doubleValue) ?? 0;
  }

  String formatPtBr(double? value) {
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    return "R\$ ${formatter.format((value ?? 0) / 100)}";
  }
}

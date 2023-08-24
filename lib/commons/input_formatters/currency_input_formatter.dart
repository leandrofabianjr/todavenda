import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ ${formatter.format(value / 100)}";

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

extension CurrencyTextEditingControllerExtension on TextEditingController {
  double get doubleFromCurrency {
    final value = text;
    final digits = value.replaceAll(RegExp(r"\D"), "");
    final doubleValue =
        '${digits.substring(0, digits.length - 2)}.${digits.substring(digits.length - 2, digits.length)}';
    return double.tryParse(doubleValue) ?? 0;
  }
}

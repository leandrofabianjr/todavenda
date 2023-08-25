import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../formatters/currency_formatter.dart';

class CurrencyField extends StatelessWidget {
  const CurrencyField({
    super.key,
    this.initialValue,
    this.decoration,
    this.onChanged,
  });

  final double? initialValue;
  final InputDecoration? decoration;
  final void Function(double)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(
        text: CurrencyFormatter().formatPtBr(initialValue),
      ),
      decoration: decoration,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(CurrencyFormatter().strToDouble(value));
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyPtBrInputFormatter()
      ],
      keyboardType: TextInputType.number,
    );
  }
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    String newText = CurrencyFormatter().formatPtBr(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

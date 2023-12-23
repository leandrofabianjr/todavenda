import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';

enum DateTimeFieldType {
  date,
  time,
  dateTime,
}

class DateTimeField extends StatefulWidget {
  const DateTimeField({
    super.key,
    required this.fieldType,
    required this.onChanged,
    this.initialValue,
    this.decoration,
  });

  final DateTimeFieldType fieldType;
  final DateTime? initialValue;
  final InputDecoration? decoration;
  final void Function(DateTime) onChanged;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  late DateTime initialValue;
  late final TextEditingController textController;

  @override
  void initState() {
    initialValue = widget.initialValue ?? DateTime.now();
    textController = TextEditingController(
      text: _getValueLabel(initialValue),
    );
    super.initState();
  }

  _getValueLabel(DateTime value) {
    switch (widget.fieldType) {
      case DateTimeFieldType.date:
        return DateTimeFormatter.shortDate(value) +
            (value.isToday ? ' (hoje)' : '');
      case DateTimeFieldType.time:
        return DateTimeFormatter.hourMinute(value);
      case DateTimeFieldType.dateTime:
        return DateTimeFormatter.shortDateTime(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: widget.decoration,
      controller: textController,
      readOnly: true,
      onTap: () => showDatePicker(
        context: context,
        initialDate: initialValue,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      ).then((value) {
        if (value != null) {
          textController.text = _getValueLabel(value);
          widget.onChanged(value);
        }
      }),
    );
  }
}

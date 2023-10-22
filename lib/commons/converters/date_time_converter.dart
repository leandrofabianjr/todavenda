import 'package:cloud_firestore/cloud_firestore.dart';

enum DateTimeConverterType {
  firestore,
  string,
}

class DateTimeConverter {
  static dynamic to(DateTimeConverterType type, DateTime? value) {
    if (value == null) {
      return null;
    }

    return switch (type) {
      DateTimeConverterType.firestore => Timestamp.fromDate(value),
      DateTimeConverterType.string => value.toString(),
    };
  }

  static DateTime parse(DateTimeConverterType type, dynamic value) =>
      switch (type) {
        DateTimeConverterType.firestore => (value as Timestamp).toDate(),
        DateTimeConverterType.string => DateTime.parse(value),
      };

  static DateTime? tryParse(DateTimeConverterType type, dynamic value) {
    if (value != null) {
      return parse(type, value);
    }
    return null;
  }
}

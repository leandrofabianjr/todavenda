extension DurationExtension on Duration {
  double operator /(Duration other) => inMicroseconds / other.inMicroseconds;

  Duration dividedBy(double value) {
    final milliseconds = (inMilliseconds / value).ceil();
    return Duration(milliseconds: milliseconds);
  }

  bool isGreaterThan(Duration duration) {
    return compareTo(duration) > 0;
  }

  bool isLessThan(Duration duration) {
    return compareTo(duration) < 0;
  }

  bool get isFullDays {
    final daysOfDuration = this / const Duration(days: 1);
    return daysOfDuration == daysOfDuration.roundToDouble();
  }

  Duration get floorHours {
    final hours = (this / const Duration(hours: 1)).floor();
    return Duration(hours: hours);
  }

  Duration get floorDays {
    final days = (this / const Duration(days: 1)).floor();
    return Duration(days: days);
  }
}

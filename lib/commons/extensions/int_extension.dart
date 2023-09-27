extension IntExtension on int {
  String padLeft(int width, [String padding = ' ']) {
    return toString().padLeft(width, padding);
  }

  String withLeftZero([int width = 2]) {
    return padLeft(width, '0');
  }
}

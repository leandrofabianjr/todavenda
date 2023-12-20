class Validators {
  static String? stringNotEmpty(String? value) {
    if (value == null || value.isEmpty) return 'Preencha este campo';

    return null;
  }

  static String? greaterThanZero(value) {
    if (value == null || value <= 0) return 'Deve ser maior que zero';

    return null;
  }
}

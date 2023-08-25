class Validators {
  static String? stringNotEmpty(String? value) {
    if (value == null || value.isEmpty) return 'Preencha este campo';

    return null;
  }
}

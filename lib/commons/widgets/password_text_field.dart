import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.initialValue = '',
    required this.onChanged,
  });

  final String initialValue;
  final void Function(String) onChanged;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late final TextEditingController controller;
  bool obscureText = true;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: const Text('Senha'),
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            obscureText = !obscureText;
          }),
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: obscureText,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
    );
  }
}

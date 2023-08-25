import 'package:flutter/material.dart';

class ExceptionWidget extends StatelessWidget {
  final Widget? child;
  final Object? exception;
  const ExceptionWidget({super.key, this.child, this.exception});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Erro'),
          child ?? const SizedBox(),
          exception != null ? ErrorWidget(exception!) : const SizedBox(),
        ],
      ),
    );
  }
}

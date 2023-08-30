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
          exception != null
              ? ExceptionDataWidget(exception!)
              : const SizedBox(),
        ],
      ),
    );
  }
}

class ExceptionDataWidget extends StatelessWidget {
  const ExceptionDataWidget(this.ex, {super.key});

  final Object ex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [Text(ex.toString()), Text(StackTrace.current.toString())],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExceptionWidget extends StatelessWidget {
  final Widget? child;
  final Object? exception;
  final StackTrace? stackTrace;

  const ExceptionWidget({
    super.key,
    this.child,
    this.exception,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Erro'),
            child ?? const SizedBox(),
            exception != null
                ? ExceptionDataWidget(
                    exception: exception!,
                    stackTrace: stackTrace ?? StackTrace.current,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ExceptionDataWidget extends StatelessWidget {
  const ExceptionDataWidget({
    super.key,
    required this.exception,
    required this.stackTrace,
  });

  final Object exception;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(exception.toString()),
        ...StackFrame.fromStackTrace(stackTrace)
            .map((e) => Text(e.toString()))
            .toList(),
      ],
    );
  }
}

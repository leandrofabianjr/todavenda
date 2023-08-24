import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Widget? child;
  const LoadingWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          child ?? const Text('Aguarde'),
        ],
      ),
    );
  }
}

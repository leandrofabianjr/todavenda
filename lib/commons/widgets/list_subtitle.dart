import 'package:flutter/material.dart';

class ListSubtitle extends StatelessWidget {
  const ListSubtitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: textTheme.titleSmall!.copyWith(color: colorScheme.primary),
      ),
    );
  }
}

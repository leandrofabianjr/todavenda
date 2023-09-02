import 'package:flutter/material.dart';

class DescriptionDetail extends StatelessWidget {
  const DescriptionDetail({
    super.key,
    required this.description,
    required this.detail,
  });

  final Widget description;
  final Widget detail;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        description,
        Flexible(
          flex: 1,
          child: detail,
        ),
      ],
    );
  }
}

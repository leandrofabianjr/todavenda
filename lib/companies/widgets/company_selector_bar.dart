import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/companies/companies.dart';

class CompanySelectorBar extends StatelessWidget {
  const CompanySelectorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanySelectorBloc, CompanySelectorState>(
      builder: (context, state) {
        if (state is CompanySelectorSuccess) {
          final company = state.company;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.storefront),
                label: Text(company.name, style: const TextStyle(fontSize: 16)),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

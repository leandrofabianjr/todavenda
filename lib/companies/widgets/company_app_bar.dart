import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/companies/companies.dart';

class CompanyAppBar extends StatelessWidget {
  const CompanyAppBar({super.key});

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
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const CompanyPage(),
                ),
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

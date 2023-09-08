/// Baseado em https://medium.com/@antonio.tioypedro1234/flutter-go-router-the-essential-guide-349ef39ec5b3
///

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/companies/widgets/company_selector_bar.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: navigationShell.currentIndex,
      length: 4,
      child: Scaffold(
        body: navigationShell,
        appBar: AppBar(
          toolbarHeight: 24,
          title: const CompanySelectorBar(),
          bottom: TabBar(
            tabs: [
              Tab(
                height: 48,
                iconMargin: EdgeInsets.zero,
                icon: const Icon(Icons.point_of_sale),
                text: navigationShell.currentIndex == 0 ? 'Vender' : null,
              ),
              Tab(
                height: 48,
                iconMargin: EdgeInsets.zero,
                icon: const Icon(Icons.history),
                text: navigationShell.currentIndex == 1 ? 'Relatórios' : null,
              ),
              Tab(
                height: 48,
                iconMargin: EdgeInsets.zero,
                icon: const Icon(Icons.app_registration),
                text: navigationShell.currentIndex == 2 ? 'Cadastros' : null,
              ),
              Tab(
                height: 48,
                iconMargin: EdgeInsets.zero,
                icon: const Icon(Icons.account_circle),
                text: navigationShell.currentIndex == 3 ? 'Meus dados' : null,
              )
            ],
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}

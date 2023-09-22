/// Baseado em https://medium.com/@antonio.tioypedro1234/flutter-go-router-the-essential-guide-349ef39ec5b3
///

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/companies/widgets/company_app_bar.dart';

class AppTabBarTabData {
  const AppTabBarTabData({
    required this.iconData,
    required this.label,
  });

  final IconData iconData;
  final String label;
}

class AppTabBar extends StatelessWidget {
  AppTabBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  final List<AppTabBarTabData> tabsData = [
    const AppTabBarTabData(
      iconData: Icons.shopping_cart_outlined,
      label: 'Vender',
    ),
    const AppTabBarTabData(
      iconData: Icons.app_registration,
      label: 'Cadastros',
    ),
    const AppTabBarTabData(
      iconData: Icons.query_stats,
      label: 'Relatórios',
    ),
  ];

  List<Tab> get tabs => tabsData
      .map(
        (e) => Tab(
          height: 48,
          iconMargin: EdgeInsets.zero,
          icon: Icon(e.iconData),
          text: navigationShell.currentIndex == tabsData.indexOf(e)
              ? e.label
              : null,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: navigationShell.currentIndex,
      length: tabsData.length,
      child: Scaffold(
        body: navigationShell,
        appBar: AppBar(
          title: const CompanyAppBar(),
          bottom: TabBar(
            tabs: tabs,
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

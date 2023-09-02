import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppMenuTab {
  cart,
  registers,
}

extension AppMenuTabX on AppMenuTab {
  Tab buildTab(AppMenuTab currentTab) {
    switch (this) {
      case AppMenuTab.cart:
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.point_of_sale),
              if (this == currentTab) const Text('Vender')
            ],
          ),
        );
      case AppMenuTab.registers:
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.app_registration),
              if (this == currentTab) const Text('Cadastros')
            ],
          ),
        );
    }
  }

  String get route => switch (this) {
        AppMenuTab.cart => '/carrinho',
        AppMenuTab.registers => '/produtos',
      };

  int get tabIndex => AppMenuTab.values.indexOf(this);

  static AppMenuTab fromIndex(int tabIndex) => AppMenuTab.values[tabIndex];

  static String routeFromIndex(int tabIndex) => fromIndex(tabIndex).route;

  static AppMenuTab? fromRoute(String route) =>
      AppMenuTab.values.firstWhereOrNull((t) => t.route == "/$route");
}

class AppMenu extends StatefulWidget {
  const AppMenu({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  final AppMenuChild child;
  final String currentRoute;

  @override
  State<AppMenu> createState() => _AppMenuViewState();
}

class _AppMenuViewState extends State<AppMenu> with TickerProviderStateMixin {
  late final TabController _controller;

  AppMenuTab get currentTab =>
      AppMenuTabX.fromRoute(widget.currentRoute) ?? AppMenuTab.cart;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: currentTab.tabIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AppMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.index = currentTab.tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _controller,
          tabs: AppMenuTab.values.map((e) => e.buildTab(currentTab)).toList(),
          onTap: (index) => context.go(AppMenuTabX.routeFromIndex(index)),
        ),
      ),
    );
  }
}

class AppMenuChild extends StatefulWidget {
  const AppMenuChild({super.key, required this.child});

  final Widget child;

  @override
  State<AppMenuChild> createState() => _AppMenuChildState();
}

class _AppMenuChildState extends State<AppMenuChild>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

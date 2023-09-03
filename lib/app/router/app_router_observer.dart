import 'dart:developer';

import 'package:flutter/material.dart';

class AppRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('ROUTER: (push) ${route.toString()}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('ROUTER: (pop) ${route.toString()}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    log('ROUTER: (replace) ${oldRoute.toString()} -> ${newRoute.toString()}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    log('ROUTER: (remove) ${route.toString()}');
  }
}

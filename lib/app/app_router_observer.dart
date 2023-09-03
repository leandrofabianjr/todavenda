import 'dart:developer';

import 'package:flutter/material.dart';

class AppRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('push ${route.toString()}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('pop ${route.toString()}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    log('replace: ${oldRoute.toString()} -> ${newRoute.toString()}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    log('remove ${route.toString()}');
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/services/auth_service.dart';

FutureOr<String?> authGuard(BuildContext context) async {
  final authService = context.read<AuthService>();
  final isAuthenticated = await authService.isAuthenticated;
  if (!isAuthenticated) {
    return '/login';
  }
  return null;
}

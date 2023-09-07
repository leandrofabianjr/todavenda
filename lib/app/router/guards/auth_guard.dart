import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';
import 'package:todavenda/companies/companies.dart';

FutureOr<String?> authGuard(BuildContext context) async {
  final authBloc = BlocProvider.of<AuthBloc>(context);
  final companySelectorBloc = BlocProvider.of<CompanySelectorBloc>(context);

  var authState = authBloc.state;

  if (authState is AuthInitial) {
    authState = await authBloc.stream.first;
  }

  if (authState is! AuthSuccess) {
    return '/login';
  }

  var companySelectorState = companySelectorBloc.state;

  if (companySelectorState is CompanySelectorInitial) {
    companySelectorBloc.add(CompanySelectorStarted(user: authState.user));
    companySelectorState = await companySelectorBloc.stream.first;
  }

  if (companySelectorState is! CompanySelectorSuccess) {
    return '/login';
  }

  return null;
}

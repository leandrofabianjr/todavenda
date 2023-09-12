import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';

Future<String?> authGuard(BuildContext context) async {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  var authState = authBloc.state;

  if (authState is AuthInitial) {
    authState = await authBloc.stream.first;
  }

  if (authState is! AuthSuccess) {
    return '/login';
  }
  return null;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';
import 'package:todavenda/cart/bloc/cart_bloc.dart';

Future<String?> authGuard(BuildContext context) {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  final authState = authBloc.state;

  if (authState is AuthInitial) {
    return authBloc.stream.first
        .then((value) => checkAuthState(value, context));
  }

  final route = checkAuthState(authState, context);

  return Future.value(route);
}

String? checkAuthState(AuthState authState, BuildContext context) {
  if (authState is! AuthSuccess) {
    BlocProvider.of<CartBloc>(context).add(const CartCleaned());
    return '/login';
  }
  return null;
}

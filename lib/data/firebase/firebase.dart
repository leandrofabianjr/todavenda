// ignore_for_file: unnecessary_cast

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/auth/services/services.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/companies/companies.dart';
import 'package:todavenda/data/firebase/auth_service_firebase.dart';
import 'package:todavenda/data/firebase/clients_repository_firestore.dart';
import 'package:todavenda/data/firebase/companies_repository_firestore.dart';
import 'package:todavenda/data/firebase/products_repository_firestore.dart';
import 'package:todavenda/data/firebase/sales_repository_firestore.dart';
import 'package:todavenda/data/firebase/users_repository_firestore.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

get firebaseRepositoryProviders {
  final authService = AuthServiceFirebase();
  final usersRepository = UsersRepositoryFirestore(authService);
  final companiesRepository = CompaniesRepositoryFirestore();
  final productsRepository = ProductsRepositoryFirestore();
  final clientsRepository = ClientsRepositoryFirestore();
  final salesRepository = SalesRepositoryFirestore(
    productsRepository: productsRepository,
    clientsRepository: clientsRepository,
  );

  return [
    RepositoryProvider.value(value: authService as AuthService),
    RepositoryProvider.value(value: usersRepository as UsersRepository),
    RepositoryProvider.value(value: companiesRepository as CompaniesRepository),
    RepositoryProvider.value(value: productsRepository as ProductsRepository),
    RepositoryProvider.value(value: salesRepository as SalesRepository),
    RepositoryProvider.value(value: clientsRepository as ClientsRepository),
  ];
}

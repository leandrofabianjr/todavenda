// ignore_for_file: unnecessary_cast

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/companies/companies.dart';
import 'package:todavenda/data/firebase/clients_repository_firestore.dart';
import 'package:todavenda/data/firebase/companies_repository_firestore.dart';
import 'package:todavenda/data/firebase/payments_repository_firestore.dart';
import 'package:todavenda/data/firebase/product_categories_repository_firestore.dart';
import 'package:todavenda/data/firebase/products_repository_firestore.dart';
import 'package:todavenda/data/firebase/sales_repository_firestore.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

firebaseRepositoryProviders(String companyUuid) {
  final companiesRepository = CompaniesRepositoryFirestore(companyUuid);
  final productCategoriesRepository = ProductCategoriesRepositoryFirestore(
    companyUuid,
  );
  final productsRepository = ProductsRepositoryFirestore(
    companyUuid,
    productCategoriesRepository: productCategoriesRepository,
  );
  final clientsRepository = ClientsRepositoryFirestore(companyUuid);
  final paymentsRepository = PaymentsRepositoryFirestore(companyUuid);
  final salesRepository = SalesRepositoryFirestore(
    companyUuid,
    productsRepository: productsRepository,
    clientsRepository: clientsRepository,
    paymentsRepository: paymentsRepository,
  );

  return [
    RepositoryProvider.value(value: companiesRepository as CompaniesRepository),
    RepositoryProvider.value(
      value: productCategoriesRepository as ProductCategoriesRepository,
    ),
    RepositoryProvider.value(value: productsRepository as ProductsRepository),
    RepositoryProvider.value(value: salesRepository as SalesRepository),
    RepositoryProvider.value(value: clientsRepository as ClientsRepository),
  ];
}

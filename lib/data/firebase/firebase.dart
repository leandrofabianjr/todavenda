// ignore_for_file: unnecessary_cast

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/companies/companies.dart';
import 'package:todavenda/data/firebase/clients_repository_firestore.dart';
import 'package:todavenda/data/firebase/companies_repository_firestore.dart';
import 'package:todavenda/data/firebase/flow_accounts_repository_firestore.dart';
import 'package:todavenda/data/firebase/payments_repository_firestore.dart';
import 'package:todavenda/data/firebase/product_categories_repository_firestore.dart';
import 'package:todavenda/data/firebase/products_repository_firestore.dart';
import 'package:todavenda/data/firebase/sales_repository_firestore.dart';
import 'package:todavenda/data/firebase/session_pick_ups_repository_firestore.dart';
import 'package:todavenda/data/firebase/session_supplies_repository_firestore.dart';
import 'package:todavenda/data/firebase/sessions_repository_firestore.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/services/services.dart';

firebaseRepositoryProviders(String companyUuid) {
  final companiesRepository = CompaniesRepositoryFirestore(companyUuid);
  final productCategoriesRepository = ProductCategoriesRepositoryFirestore(
    companyUuid,
  );
  final productsRepository = ProductsRepositoryFirestore(
    companyUuid,
    productCategoriesRepository: productCategoriesRepository,
  );
  final sessionSuppliesRepository = SessionSuppliesRepositoryFirestore(
    companyUuid,
  );
  final sessionPickUpsRepository = SessionPickUpsRepositoryFirestore(
    companyUuid,
  );
  final sessionsRepository = SessionsRepositoryFirestore(
    companyUuid,
    sessionSuppliesRepository: sessionSuppliesRepository,
    sessionPickUpsRepository: sessionPickUpsRepository,
  );
  final paymentsRepository = PaymentsRepositoryFirestore(
    companyUuid,
    sessionsRepository: sessionsRepository,
  );
  final clientsRepository = ClientsRepositoryFirestore(
    companyUuid,
    sessionsRepository: sessionsRepository,
    paymentsRepository: paymentsRepository,
  );
  final salesRepository = SalesRepositoryFirestore(
    companyUuid,
    productsRepository: productsRepository,
    clientsRepository: clientsRepository,
    paymentsRepository: paymentsRepository,
    sessionsRepository: sessionsRepository,
  );
  final flowAccountsRepository = FlowAccountsRepositoryFirestore(
    companyUuid,
  );

  return [
    RepositoryProvider.value(
      value: sessionSuppliesRepository as SessionSuppliesRepository,
    ),
    RepositoryProvider.value(
      value: paymentsRepository as PaymentsRepository,
    ),
    RepositoryProvider.value(
      value: sessionPickUpsRepository as SessionPickUpsRepository,
    ),
    RepositoryProvider.value(value: sessionsRepository as SessionsRepository),
    RepositoryProvider.value(value: companiesRepository as CompaniesRepository),
    RepositoryProvider.value(
      value: productCategoriesRepository as ProductCategoriesRepository,
    ),
    RepositoryProvider.value(value: productsRepository as ProductsRepository),
    RepositoryProvider.value(value: salesRepository as SalesRepository),
    RepositoryProvider.value(value: clientsRepository as ClientsRepository),
    RepositoryProvider.value(
      value: flowAccountsRepository as FlowAccountsRepository,
    ),
  ];
}

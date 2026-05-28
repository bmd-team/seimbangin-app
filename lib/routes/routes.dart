import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seimbangin_app/models/user/user_model.dart';
import 'package:seimbangin_app/models/transaction/transaction_model.dart'
    as model;
import 'package:seimbangin_app/ui/pages/analytics_page.dart';
import 'package:seimbangin_app/ui/pages/category_management_page.dart';
import 'package:seimbangin_app/ui/pages/financial_profile_page.dart';
import 'package:seimbangin_app/ui/pages/history_transact_page.dart';
import 'package:seimbangin_app/ui/pages/home_page.dart';
import 'package:seimbangin_app/ui/pages/profile_edit_page.dart';
import 'package:seimbangin_app/ui/pages/profile_page.dart';
import 'package:seimbangin_app/ui/pages/transaction_detail_page.dart';
import 'package:seimbangin_app/ui/pages/transaction_struct_page.dart';
import 'package:seimbangin_app/ui/pages/transaction_success.dart';
import 'package:seimbangin_app/ui/pages/transaction_page.dart';
import 'package:seimbangin_app/ui/pages/main_page.dart';

part 'name_route.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.main,
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      path: '/analytics',
      name: RouteNames.analytics,
      builder: (context, state) => AnalyticsPage(),
    ),
    GoRoute(
      path: '/profile',
      name: RouteNames.profile,
      builder: (context, state) => ProfilePage(),
      routes: [
        GoRoute(
          path: 'profileEdit',
          name: RouteNames.profileEdit,
          builder: (context, state) {
            final userData = state.extra as UserResponse?;

            if (userData == null) {
              print("Error: UserData tidak ditemukan untuk ProfileEditPage.");
              return const Scaffold(
                body: Center(child: Text("Error: User data not provided.")),
              );
            }
            return ProfileEditPage(userData: userData);
          },
        ),
        GoRoute(
          path: 'categoryManagement',
          name: RouteNames.categoryManagement,
          builder: (context, state) => const CategoryManagementPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      name: RouteNames.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'transaction',
          name: RouteNames.transaction,
          builder: (context, state) => const TransactionsPage(),
          routes: [
            GoRoute(
              path: 'transactionDetail',
              name: RouteNames.transactionDetail,
              builder: (context, state) {
                final transactionData = state.extra as model.TransactionData;
                return TransactionDetailPage(transactionData: transactionData);
              },
            ),
            GoRoute(
              path: 'transactionStruct',
              name: RouteNames.transactionStruct,
              builder: (context, state) => TransactionStructPage(),
            ),
            GoRoute(
              path: 'transactionSuccess',
              name: RouteNames.transactionSuccess,
              builder: (context, state) => TransactionSuccessPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/financialProfile',
      name: RouteNames.financialProfile,
      builder: (context, state) => const FinancialProfilePage(),
    ),
    GoRoute(
      path: '/historyTransact',
      name: RouteNames.historyTransact,
      builder: (context, state) => const HistoryTransactPage(),
    ),
  ],
);

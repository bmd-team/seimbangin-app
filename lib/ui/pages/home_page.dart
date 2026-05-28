import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:seimbangin_app/blocs/homepage/homepage_bloc.dart';
import 'package:seimbangin_app/blocs/transaction/transaction_bloc.dart';
import 'package:seimbangin_app/routes/routes.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';
import 'package:seimbangin_app/ui/sections/homepage/home_page_skeleton.dart';
import 'package:seimbangin_app/ui/sections/homepage/home_recent_transact_section.dart';
import 'package:seimbangin_app/ui/sections/income_outcome_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var logger = Logger();

  @override
  void initState() {
    super.initState();

    // Memuat data homepage jika belum pernah dimuat sebelumnya
    if (context.read<HomepageBloc>().state is! HomePageSuccess) {
      context.read<HomepageBloc>().add(HomepageStarted());
    }

    // Memuat transaksi terkini jika state-nya BUKAN TransactionLoadSuccess
    if (context.read<TransactionBloc>().state is! TransactionLoadSuccess) {
      context.read<TransactionBloc>().add(
            GetRecentTransactionsEvent(limit: 3),
          );
    }
  }

  // Fungsi untuk pull-to-refresh
  Future<void> _onRefresh() async {
    context.read<HomepageBloc>().add(HomepageStarted());
    context.read<TransactionBloc>().add(GetRecentTransactionsEvent(limit: 3));

    try {
      await Future.wait([
        context.read<HomepageBloc>().stream.firstWhere(
            (state) => state is HomePageSuccess || state is HomePageFailure),
        context.read<TransactionBloc>().stream.firstWhere((state) =>
            state is TransactionLoadSuccess || state is TransactionFailure),
      ]);
    } catch (e) {
      logger.e("Error waiting for BLoC refresh: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: context.color.backgroundGreyColor,
        body: BlocListener<TransactionBloc, TransactionState>(
          listenWhen: (previousState, currentState) {
            return currentState is TransactionSuccess &&
                previousState is! TransactionSuccess;
          },
          listener: (context, state) {
            logger.i(
                '[BlocListener HomePage] TransactionSuccess terdeteksi! Me-refresh homepage...');
            context.read<HomepageBloc>().add(HomepageStarted());
            context
                .read<TransactionBloc>()
                .add(GetRecentTransactionsEvent(limit: 3));
          },
          child: BlocBuilder<HomepageBloc, HomepageState>(
            builder: (context, homepageState) {
              if (homepageState is HomePageLoading) {
                return const HomePageSkeleton();
              }

              if (homepageState is HomePageSuccess) {
                final user = homepageState.user;

                return SafeArea(
                  child: ListView(
                    children: [
                      IncomeOutcomeSection(
                          balance: user.data.balance.toString(),
                          incomeAmount: user.data.financeProfile?.totalIncome
                                  .toString() ??
                              '0',
                          outcomeAmount: user.data.financeProfile?.totalOutcome
                                  .toString() ??
                              '0',
                          onAddTransaction: () =>
                              routes.pushNamed(RouteNames.transaction)),
                      LastTransactionsSection(),
                    ],
                  ),
                );
              }

              if (homepageState is HomePageFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0).r,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Gagal memuat data: ${homepageState.error}',
                          textAlign: TextAlign.center,
                          style: context.text.blackTextStyle
                              .copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: _onRefresh,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Fallback State
              return const Center(
                child: Text("Terjadi kesalahan tidak dikenal."),
              );
            },
          ),
        ),
      ),
    );
  }
}

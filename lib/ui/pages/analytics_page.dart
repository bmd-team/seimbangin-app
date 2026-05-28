import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seimbangin_app/blocs/analytics/analytics_bloc.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';
import 'package:seimbangin_app/ui/sections/analytics/month_picker_section.dart';
import 'package:seimbangin_app/ui/sections/analytics/period_selector_section.dart';
import 'package:seimbangin_app/ui/sections/analytics/cashflow_summary_section.dart';
import 'package:seimbangin_app/ui/sections/analytics/income_expense_summary_section.dart';
import 'package:seimbangin_app/ui/sections/analytics/daily_cashflow_chart_section.dart';
import 'package:seimbangin_app/ui/sections/analytics/spending_category_section.dart';
import 'package:seimbangin_app/ui/sections/analytics/category_breakdown_section.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context
        .read<AnalyticsBloc>()
        .add(LoadAnalytics(year: now.year, month: now.month));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.color.statusBarPrimaryColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: context.color.backgroundGreySecondaryColor,
        body: SafeArea(
          child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
            builder: (context, state) {
              if (state is AnalyticsFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gagal memuat data',
                        style: context.text.greyTextStyle.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () {
                          final now = DateTime.now();
                          context.read<AnalyticsBloc>().add(
                                LoadAnalytics(
                                    year: now.year, month: now.month),
                              );
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              if (state is! AnalyticsLoaded) {
                return Center(
                  child: CircularProgressIndicator(
                    color: context.color.primaryColor,
                  ),
                );
              }

              final loaded = state;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AnalyticsBloc>().add(
                        LoadAnalytics(
                            year: loaded.year, month: loaded.month),
                      );
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  children: [
                    MonthPickerSection(
                      year: loaded.year,
                      month: loaded.month,
                      onPrevious: () =>
                          context.read<AnalyticsBloc>().add(ChangeMonth(-1)),
                      onNext: () =>
                          context.read<AnalyticsBloc>().add(ChangeMonth(1)),
                    ),
                    SizedBox(height: 4.h),
                    PeriodSelectorSection(
                      currentPeriod: loaded.period,
                      onChanged: (period) =>
                          context.read<AnalyticsBloc>().add(ChangePeriod(period)),
                    ),
                    SizedBox(height: 8.h),
                    CashflowSummarySection(
                      cashflow: loaded.cashflow,
                      netBalance: loaded.netBalance,
                    ),
                    SizedBox(height: 8.h),
                    IncomeExpenseSummarySection(
                      income: loaded.income,
                      expense: loaded.expense,
                    ),
                    SizedBox(height: 8.h),
                    DailyCashflowChartSection(
                      dailyCashflow: loaded.dailyCashflow,
                      period: loaded.period,
                    ),
                    SizedBox(height: 8.h),
                    SpendingCategorySection(
                      categoryData: loaded.categoryData,
                      categoryFilterType: loaded.categoryFilterType,
                      onFilterChanged: (type) => context
                          .read<AnalyticsBloc>()
                          .add(ChangeCategoryFilter(type)),
                    ),
                    SizedBox(height: 8.h),
                    CategoryBreakdownSection(
                      breakdown: loaded.categoryBreakdown,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

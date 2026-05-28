part of 'analytics_bloc.dart';

enum AnalyticsPeriod { weekly, monthly, yearly }

sealed class AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final int year;
  final int month;
  final AnalyticsPeriod period;
  final int categoryFilterType;

  final double cashflow;
  final double netBalance;
  final double income;
  final double expense;

  final Map<int, Map<String, double>> dailyCashflow;
  final List<CategoryData> categoryData;
  final List<CategoryBreakdown> categoryBreakdown;

  AnalyticsLoaded({
    required this.year,
    required this.month,
    this.period = AnalyticsPeriod.monthly,
    this.categoryFilterType = 0,
    this.cashflow = 0,
    this.netBalance = 0,
    this.income = 0,
    this.expense = 0,
    this.dailyCashflow = const {},
    this.categoryData = const [],
    this.categoryBreakdown = const [],
  });

  AnalyticsLoaded copyWith({
    int? year,
    int? month,
    AnalyticsPeriod? period,
    int? categoryFilterType,
    double? cashflow,
    double? netBalance,
    double? income,
    double? expense,
    Map<int, Map<String, double>>? dailyCashflow,
    List<CategoryData>? categoryData,
    List<CategoryBreakdown>? categoryBreakdown,
  }) {
    return AnalyticsLoaded(
      year: year ?? this.year,
      month: month ?? this.month,
      period: period ?? this.period,
      categoryFilterType: categoryFilterType ?? this.categoryFilterType,
      cashflow: cashflow ?? this.cashflow,
      netBalance: netBalance ?? this.netBalance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      dailyCashflow: dailyCashflow ?? this.dailyCashflow,
      categoryData: categoryData ?? this.categoryData,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
    );
  }
}

class AnalyticsFailure extends AnalyticsState {
  final String message;
  AnalyticsFailure(this.message);
}

class CategoryData {
  final String category;
  final double total;
  final String type;

  CategoryData({
    required this.category,
    required this.total,
    required this.type,
  });
}

class CategoryBreakdown {
  final String category;
  final double amount;
  final double percentage;
  final String type;

  CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.type,
  });
}

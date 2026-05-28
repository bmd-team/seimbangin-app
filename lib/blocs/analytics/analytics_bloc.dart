import 'package:bloc/bloc.dart';
import 'package:seimbangin_app/services/local_database_service.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final LocalDatabaseService _dbService = LocalDatabaseService();

  AnalyticsBloc() : super(AnalyticsLoading()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<ChangeMonth>(_onChangeMonth);
    on<ChangePeriod>(_onChangePeriod);
    on<ChangeCategoryFilter>(_onChangeCategoryFilter);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    await _loadData(emit, year: event.year, month: event.month);
  }

  Future<void> _onChangeMonth(
    ChangeMonth event,
    Emitter<AnalyticsState> emit,
  ) async {
    final current = state;
    if (current is! AnalyticsLoaded) return;

    final newDate = DateTime(current.year, current.month + event.delta);
    await _loadData(emit,
        year: newDate.year,
        month: newDate.month,
        period: current.period,
        categoryFilterType: current.categoryFilterType);
  }

  Future<void> _onChangePeriod(
    ChangePeriod event,
    Emitter<AnalyticsState> emit,
  ) async {
    final current = state;
    if (current is! AnalyticsLoaded) return;

    await _loadData(emit,
        year: current.year,
        month: current.month,
        period: event.period,
        categoryFilterType: current.categoryFilterType);
  }

  Future<void> _onChangeCategoryFilter(
    ChangeCategoryFilter event,
    Emitter<AnalyticsState> emit,
  ) async {
    final current = state;
    if (current is! AnalyticsLoaded) return;

    await _loadData(emit,
        year: current.year,
        month: current.month,
        period: current.period,
        categoryFilterType: event.filterType);
  }

  Future<void> _loadData(
    Emitter<AnalyticsState> emit, {
    required int year,
    required int month,
    AnalyticsPeriod period = AnalyticsPeriod.monthly,
    int categoryFilterType = 0,
  }) async {
    emit(AnalyticsLoading());
    try {
      final overallTotals = await _dbService.getOverallTotals();

      double income;
      double expense;
      Map<int, Map<String, double>> dailyCashflow;
      List<CategoryData> categoryData;
      List<CategoryBreakdown> categoryBreakdown;

      if (period == AnalyticsPeriod.yearly) {
        final yearlyData = await _dbService.getYearlyCashflow(year);
        income = 0;
        expense = 0;
        dailyCashflow = yearlyData;

        for (final entry in yearlyData.entries) {
          income += entry.value['income'] ?? 0;
          expense += entry.value['outcome'] ?? 0;
        }
      } else {
        income = await _dbService.getMonthlyIncome(year, month);
        expense = await _dbService.getMonthlyExpense(year, month);
        dailyCashflow = await _dbService.getDailyCashflow(year, month);
      }

      final categoryFilter = switch (categoryFilterType) {
        1 => 'income',
        2 => 'outcome',
        _ => 'all',
      };

      final rawCategoryData =
          await _dbService.getCategorySummary(year, month, categoryFilter);

      categoryData = rawCategoryData.map((row) {
        return CategoryData(
          category: row['category'] as String,
          total: (row['total'] as num).toDouble(),
          type: row['type'] as String,
        );
      }).toList();

      final totalCategoryAmount =
          categoryData.fold<double>(0, (sum, c) => sum + c.total);

      categoryBreakdown = categoryData.map((c) {
        final pct = totalCategoryAmount > 0 ? (c.total / totalCategoryAmount * 100) : 0.0;
        return CategoryBreakdown(
          category: c.category,
          amount: c.total,
          percentage: pct,
          type: c.type,
        );
      }).toList();

      final cashflow = income - expense;

      emit(AnalyticsLoaded(
        year: year,
        month: month,
        period: period,
        categoryFilterType: categoryFilterType,
        cashflow: cashflow,
        netBalance: overallTotals['netBalance'] ?? 0,
        income: income,
        expense: expense,
        dailyCashflow: dailyCashflow,
        categoryData: categoryData,
        categoryBreakdown: categoryBreakdown,
      ));
    } catch (e) {
      emit(AnalyticsFailure('Gagal memuat data: $e'));
    }
  }
}

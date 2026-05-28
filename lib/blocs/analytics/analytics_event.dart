part of 'analytics_bloc.dart';

sealed class AnalyticsEvent {}

class LoadAnalytics extends AnalyticsEvent {
  final int year;
  final int month;
  LoadAnalytics({required this.year, required this.month});
}

class ChangeMonth extends AnalyticsEvent {
  final int delta;
  ChangeMonth(this.delta);
}

class ChangePeriod extends AnalyticsEvent {
  final AnalyticsPeriod period;
  ChangePeriod(this.period);
}

class ChangeCategoryFilter extends AnalyticsEvent {
  final int filterType;
  ChangeCategoryFilter(this.filterType);
}

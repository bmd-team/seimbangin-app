import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seimbangin_app/blocs/analytics/analytics_bloc.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class DailyCashflowChartSection extends StatelessWidget {
  final Map<int, Map<String, double>> dailyCashflow;
  final AnalyticsPeriod period;

  const DailyCashflowChartSection({
    super.key,
    required this.dailyCashflow,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.color.backgroundWhiteColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title(),
              style: context.text.blackTextStyle.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            _legend(context),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: dailyCashflow.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada data',
                        style: context.text.greyTextStyle.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        maxY: _maxY,
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                          horizontalInterval: _maxY > 0 ? _maxY / 4 : 1,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withValues(alpha: 0.2),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                final key =
                                    _sortedKeys.length > value.toInt()
                                        ? _sortedKeys[value.toInt()]
                                        : 0;
                                final label = _labelFor(key);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    label,
                                    style: context.text.greyTextStyle
                                        .copyWith(fontSize: 10.sp),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) {
                                if (value == 0) {
                                  return const SizedBox.shrink();
                                }
                                String text;
                                if (value >= 1000000) {
                                  text = '${(value / 1000000).toStringAsFixed(0)}jt';
                                } else if (value >= 1000) {
                                  text = '${(value / 1000).toStringAsFixed(0)}k';
                                } else {
                                  text = value.toStringAsFixed(0);
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    text,
                                    style: context.text.greyTextStyle
                                        .copyWith(fontSize: 9.sp),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _buildBarGroups(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _title() {
    switch (period) {
      case AnalyticsPeriod.weekly:
        return 'Cashflow per Minggu';
      case AnalyticsPeriod.monthly:
        return 'Cashflow per Hari';
      case AnalyticsPeriod.yearly:
        return 'Cashflow per Bulan';
    }
  }

  String _labelFor(int key) {
    switch (period) {
      case AnalyticsPeriod.weekly:
        return 'Minggu\n$key';
      case AnalyticsPeriod.monthly:
        return '$key';
      case AnalyticsPeriod.yearly:
        final months = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
          'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
        ];
        return key >= 1 && key <= 12 ? months[key] : '';
    }
  }

  List<int> get _sortedKeys =>
      dailyCashflow.keys.toList()..sort();

  double get _maxY {
    double max = 0;
    for (final entry in dailyCashflow.entries) {
      final income = entry.value['income'] ?? 0;
      final outcome = entry.value['outcome'] ?? 0;
      final maxVal = income > outcome ? income : outcome;
      if (maxVal > max) max = maxVal;
    }
    return max > 0 ? max * 1.25 : 1000;
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _sortedKeys.map((key) {
      final data = dailyCashflow[key]!;
      return BarChartGroupData(
        x: key,
        barRods: [
          BarChartRodData(
            toY: data['income'] ?? 0,
            color: const Color(0xFF4CAF50),
            width: _sortedKeys.length > 20 ? 6 : 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: data['outcome'] ?? 0,
            color: const Color(0xFFEF5350),
            width: _sortedKeys.length > 20 ? 6 : 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _legend(BuildContext context) {
    return Row(
      children: [
        _legendItem(context, 'Pemasukan', const Color(0xFF4CAF50)),
        SizedBox(width: 16.w),
        _legendItem(context, 'Pengeluaran', const Color(0xFFEF5350)),
      ],
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: context.text.greyTextStyle.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

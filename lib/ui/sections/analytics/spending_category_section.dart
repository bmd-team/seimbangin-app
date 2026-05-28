import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/blocs/analytics/analytics_bloc.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class SpendingCategorySection extends StatefulWidget {
  final List<CategoryData> categoryData;
  final int categoryFilterType;
  final ValueChanged<int> onFilterChanged;

  const SpendingCategorySection({
    super.key,
    required this.categoryData,
    required this.categoryFilterType,
    required this.onFilterChanged,
  });

  @override
  State<SpendingCategorySection> createState() =>
      _SpendingCategorySectionState();
}

class _SpendingCategorySectionState extends State<SpendingCategorySection> {
  int touchedIndex = -1;

  static const List<Color> _chartColors = [
    Color(0xFF1976D2),
    Color(0xFF4CAF50),
    Color(0xFFFF7043),
    Color(0xFF9C27B0),
    Color(0xFFFFC107),
    Color(0xFF00BCD4),
    Color(0xFFE91E63),
    Color(0xFF607D8B),
    Color(0xFFCDDC39),
    Color(0xFF795548),
  ];

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final filterTabs = ['Semua', 'Pemasukan', 'Pengeluaran'];

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
              'Spending by Category',
              style: context.text.blackTextStyle.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: filterTabs.asMap().entries.map((entry) {
                final idx = entry.key;
                final label = entry.value;
                final isSelected = widget.categoryFilterType == idx;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onFilterChanged(idx),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.color.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: (isSelected
                                ? context.text.whiteTextStyle
                                : context.text.blackTextStyle)
                            .copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            if (widget.categoryData.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    'Belum ada data',
                    style: context.text.greyTextStyle.copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              )
            else ...[
              SizedBox(
                height: 180.h,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          touchedIndex = response?.touchedSection
                                  ?.touchedSectionIndex ??
                              -1;
                        });
                      },
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40.r,
                    sections: _buildSections(context),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ...widget.categoryData.asMap().entries.map((entry) {
                final idx = entry.key;
                final data = entry.value;
                final color = _chartColors[idx % _chartColors.length];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          data.category[0].toUpperCase() +
                              data.category.substring(1),
                          style: context.text.blackTextStyle.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        formatter.format(data.total),
                        style: context.text.blackTextStyle.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    final total =
        widget.categoryData.fold<double>(0, (sum, d) => sum + d.total);

    return widget.categoryData.asMap().entries.map((entry) {
      final i = entry.key;
      final data = entry.value;
      final isTouched = i == touchedIndex;
      final pct = total > 0 ? (data.total / total * 100) : 0.0;

      return PieChartSectionData(
        color: _chartColors[i % _chartColors.length],
        value: data.total,
        radius: isTouched ? 65 : 55,
        title: pct >= 5 ? '${pct.toStringAsFixed(0)}%' : '',
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

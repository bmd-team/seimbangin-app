import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seimbangin_app/blocs/analytics/analytics_bloc.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class PeriodSelectorSection extends StatelessWidget {
  final AnalyticsPeriod currentPeriod;
  final ValueChanged<AnalyticsPeriod> onChanged;

  const PeriodSelectorSection({
    super.key,
    required this.currentPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final periods = [
      (AnalyticsPeriod.weekly, 'Mingguan'),
      (AnalyticsPeriod.monthly, 'Bulanan'),
      (AnalyticsPeriod.yearly, 'Tahunan'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: context.color.backgroundWhiteColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: periods.map((item) {
            final isSelected = currentPeriod == item.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(item.$1),
                child: Container(
                  margin: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.color.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.$2,
                    style: isSelected
                        ? context.text.whiteTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          )
                        : context.text.blackTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

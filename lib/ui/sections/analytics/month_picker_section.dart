import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class MonthPickerSection extends StatelessWidget {
  final int year;
  final int month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MonthPickerSection({
    super.key,
    required this.year,
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime(year, month);
    final formatted = DateFormat('MMMM yyyy', 'id_ID').format(date);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onPrevious,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: context.color.backgroundWhiteColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                size: 24.r,
                color: context.color.textPrimaryColor,
              ),
            ),
          ),
          Text(
            formatted[0].toUpperCase() + formatted.substring(1),
            style: context.text.blackTextStyle.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: onNext,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: context.color.backgroundWhiteColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 24.r,
                color: context.color.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

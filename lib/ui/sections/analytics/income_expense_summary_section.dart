import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class IncomeExpenseSummarySection extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpenseSummarySection({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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
              'Ringkasan Keuangan',
              style: context.text.blackTextStyle.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            _buildRow(
              context,
              label: 'Pemasukan',
              amount: income,
              color: context.color.textGreenColor,
              icon: Icons.arrow_downward_rounded,
              formatter: formatter,
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
            SizedBox(height: 12.h),
            _buildRow(
              context,
              label: 'Pengeluaran',
              amount: expense,
              color: context.color.textWarningColor,
              icon: Icons.arrow_upward_rounded,
              formatter: formatter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
    required NumberFormat formatter,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.r, color: color),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.text.greyTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              formatter.format(amount),
              style: context.text.blackTextStyle.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

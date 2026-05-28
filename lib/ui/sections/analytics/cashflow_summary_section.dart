import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class CashflowSummarySection extends StatelessWidget {
  final double cashflow;
  final double netBalance;

  const CashflowSummarySection({
    super.key,
    required this.cashflow,
    required this.netBalance,
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
      child: Row(
        children: [
          Expanded(
            child: _buildCard(
              context,
              title: 'Cashflow',
              amount: cashflow,
              amountColor: cashflow >= 0
                  ? context.color.textGreenColor
                  : context.color.textWarningColor,
              icon: Icons.trending_up_rounded,
              iconColor: context.color.textGreenColor,
              formatter: formatter,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildCard(
              context,
              title: 'Net Balance',
              amount: netBalance,
              amountColor: netBalance >= 0
                  ? context.color.textGreenColor
                  : context.color.textWarningColor,
              icon: Icons.account_balance_wallet_rounded,
              iconColor: context.color.primaryColor,
              formatter: formatter,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required double amount,
    required Color amountColor,
    required IconData icon,
    required Color iconColor,
    required NumberFormat formatter,
  }) {
    return Container(
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, size: 20.r, color: iconColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: context.text.greyTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            formatter.format(amount),
            style: context.text.blackTextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

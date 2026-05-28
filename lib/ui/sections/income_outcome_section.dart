import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class IncomeOutcomeSection extends StatefulWidget {
  final String balance;
  final String incomeAmount;
  final String outcomeAmount;

  const IncomeOutcomeSection({
    super.key,
    required this.balance,
    required this.incomeAmount,
    required this.outcomeAmount,
  });

  @override
  State<IncomeOutcomeSection> createState() => _IncomeOutcomeSectionState();
}

class _IncomeOutcomeSectionState extends State<IncomeOutcomeSection> {
  bool _isObscured = false;

  String _formatCurrency(String value) {
    if (value.isEmpty || value == 'null') return 'Rp 0';
    final doubleVal = double.tryParse(value) ?? 0;
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(doubleVal);
  }

  String _getDisplayText(String value) {
    if (_isObscured) {
      return 'Rp ••••••••';
    }
    return _formatCurrency(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 32.h,
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seimbangin',
                style: context.text.blackTextStyle.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: context.color.backgroundWhiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isObscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: context.color.textSecondaryColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              color: context.color.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: context.color.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Saldo',
                    style: context.text.whiteTextStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _getDisplayText(widget.balance),
                    style: context.text.whiteTextStyle.copyWith(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: context.color.backgroundWhiteColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildTrackingItem(
                          context: context,
                          title: 'Pemasukan',
                          amount: widget.incomeAmount,
                          icon: Icons.arrow_downward_rounded,
                          iconColor: context.color.textGreenColor,
                        )),
                        Container(
                          width: 1,
                          height: 40.h,
                          color: context.color.backgroundWhiteColor.withValues(alpha: 0.3),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(child: _buildTrackingItem(
                          context: context,
                          title: 'Pengeluaran',
                          amount: widget.outcomeAmount,
                          icon: Icons.arrow_upward_rounded,
                          iconColor: context.color.textWarningColor,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingItem({
    required BuildContext context,
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: context.color.backgroundWhiteColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 12.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: context.text.whiteTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          _getDisplayText(amount),
          style: context.text.whiteTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

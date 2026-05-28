import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class TransactionFooterSection extends StatelessWidget {
  final double totalPrice;
  final bool isIncome;
  final VoidCallback onAddTransaction;

  const TransactionFooterSection({
    super.key,
    required this.totalPrice,
    required this.isIncome,
    required this.onAddTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.backgroundWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.r, 24.r, 24.r, 16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: context.text.greyTextStyle.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 14.sp),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(totalPrice),
                    style: context.text.blackTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: isIncome ? context.color.primaryColor : const Color(0xffE91E63)),
                  ),
                ],
              ),
              SizedBox(height: 20.r),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: onAddTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isIncome ? context.color.primaryColor : const Color(0xffE91E63),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    isIncome ? 'Simpan Pemasukan' : 'Simpan Pengeluaran',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

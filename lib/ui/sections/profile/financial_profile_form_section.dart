import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class FinancialProfileFormSection extends StatelessWidget {
  final TextEditingController financialGoalsController;
  final TextEditingController currentSavingController;
  final TextEditingController totalDebtController;
  final String? selectedInterval;
  final List<String> intervals;
  final ValueChanged<String?> onIntervalChanged;
  final void Function(String, TextEditingController) onCurrencyChanged;

  const FinancialProfileFormSection({
    super.key,
    required this.financialGoalsController,
    required this.currentSavingController,
    required this.totalDebtController,
    required this.selectedInterval,
    required this.intervals,
    required this.onIntervalChanged,
    required this.onCurrencyChanged,
  });

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: context.text.blackTextStyle.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: context.color.backgroundGreySecondaryColor,
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintStyle: context.text.greyTextStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: context.color.primaryColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, "Profil Risiko (Risk Management)"),
        DropdownButtonFormField<String>(
          initialValue: selectedInterval,
          decoration: _buildInputDecoration(context, 'Pilih profil risiko...'),
          items: intervals.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.toUpperCase(),
                style: context.text.blackTextStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onIntervalChanged,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: context.color.textPrimaryColor, size: 28.r),
          dropdownColor: context.color.backgroundWhiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        SizedBox(height: 20.h),
        _buildLabel(context, "Tujuan Keuangan (Financial Goals)"),
        TextField(
          controller: financialGoalsController,
          decoration: _buildInputDecoration(context, 'Contoh: Beli rumah, Liburan'),
          style: context.text.blackTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 20.h),
        _buildLabel(context, "Tabungan Saat Ini (Current Saving)"),
        TextField(
          controller: currentSavingController,
          decoration: _buildInputDecoration(context, 'Contoh: Rp 5.000.000'),
          onChanged: (value) => onCurrencyChanged(value, currentSavingController),
          keyboardType: TextInputType.number,
          style: context.text.blackTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 20.h),
        _buildLabel(context, "Total Hutang (Total Debt)"),
        TextField(
          controller: totalDebtController,
          decoration: _buildInputDecoration(context, 'Contoh: Rp 1.000.000'),
          onChanged: (value) => onCurrencyChanged(value, totalDebtController),
          keyboardType: TextInputType.number,
          style: context.text.blackTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

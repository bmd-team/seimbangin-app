import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/models/transaction/transaction_model.dart'
    as model;
import 'package:seimbangin_app/routes/routes.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';
import 'package:seimbangin_app/ui/widgets/buttons_widget.dart';
import 'package:seimbangin_app/ui/widgets/card_widget.dart';

// Helper Widget untuk Dotted Divider
class DottedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;

  const DottedDivider({
    super.key,
    this.height = 1,
    this.color = Colors.grey,
    this.dashWidth = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class TransactionDetailPage extends StatefulWidget {
  final model.TransactionData transactionData;
  const TransactionDetailPage({super.key, required this.transactionData});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  bool _isDetailsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isOutcome = widget.transactionData.type == 1;
    final double totalAmount =
        double.tryParse(widget.transactionData.amount) ?? 0.0;
    final DateTime transactionDate = DateTime.parse(
        widget.transactionData.createdAt ?? DateTime.now().toIso8601String());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.color.textButtonColor,
                context.color.textWhiteColor,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24).r,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomRoundedButton(
                        onPressed: () => routes.pop(),
                        widget: Icon(
                          Icons.chevron_left,
                          size: 32.r,
                          color: context.color.textSecondaryColor,
                        ),
                        backgroundColor: context.color.backgroundWhiteColor,
                      ),
                      Text(
                        'Detail Transaksi',
                        style: context.text.whiteTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      Image.asset('assets/ic_seimbangin-logo-logreg.png'),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 32)
                            .r,
                    decoration: BoxDecoration(
                      color: context.color.backgroundWhiteColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            spreadRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Konfirmasi Transaksi',
                            style: context.text.greyTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Center(
                          child: Text(
                            widget.transactionData.name,
                            textAlign: TextAlign.center,
                            style: context.text.blackTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd MMMM yyyy')
                                  .format(transactionDate),
                              style: context.text.greyTextStyle.copyWith(fontSize: 12.sp),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.circle,
                                  size: 4, color: context.color.textSecondaryColor),
                            ),
                            Text(
                              DateFormat('hh:mm a').format(transactionDate),
                              style: context.text.greyTextStyle.copyWith(fontSize: 12.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        const DottedDivider(),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              height: 14.h,
                              width: 14.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isOutcome
                                    ? context.color.backgroundWarningColor
                                    : context.color.textGreenColor,
                              ),
                              child: Icon(
                                isOutcome
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                color: context.color.textWhiteColor,
                                size: 8.sp,
                              ),
                            ),
                            SizedBox(width: 4.h),
                            Text(
                              isOutcome ? 'Pengeluaran' : 'Pemasukan',
                              style: (isOutcome
                                      ? context.text.warningTextStyle
                                      : context.text.greenTextStyle)
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.r, vertical: 12.r),
                          decoration: BoxDecoration(
                              color: isOutcome
                                  ? const Color(0xffE91E63).withValues(alpha: 0.1)
                                  : context.color.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16).r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isOutcome
                                    ? 'Total Pengeluaran'
                                    : 'Total Pemasukan',
                                style: context.text.blackTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(totalAmount),
                                style: (isOutcome
                                        ? context.text.warningTextStyle
                                        : context.text.blueTextStyle)
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        const Divider(),
                        SizedBox(height: 18.h),

                        InkWell(
                          onTap: () => setState(
                              () => _isDetailsExpanded = !_isDetailsExpanded),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rincian Barang',
                                    style: context.text.blackTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp)),
                                AnimatedRotation(
                                  turns: _isDetailsExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(Icons.expand_more,
                                      color: context.color.textSecondaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Daftar Item
                        Column(
                          children: widget.transactionData.items
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            final item = entry.value;

                            // Tampilkan item jika expanded, atau hanya jika item pertama
                            final bool isVisible =
                                _isDetailsExpanded || index == 0;

                            return AnimatedCrossFade(
                              firstChild: _buildItemTile(item),
                              secondChild: Container(),
                              crossFadeState: isVisible
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 300),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 64.h),
                  PrimaryFilledButton(
                    onPressed: () {},
                    title: 'Bagikan',
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk mendapatkan warna dan ikon berdasarkan kategori transaksi.
  (Color, String) _getCategoryUIData(String category) {
    switch (category.toLowerCase()) {
      case 'salary':
      case 'gaji':
        return (context.color.buttonSalaryColor, 'assets/ic_salary.png');
      case 'freelance':
        return (context.color.buttonFreelanceColor, 'assets/ic_freelance.png');
      case 'bonus':
      case 'hadiah':
        return (context.color.buttonBonusColor, 'assets/ic_bonus.png');
      case 'gift':
        return (context.color.buttonBonusColor, 'assets/ic_gift.png');
      case 'parent':
        return (context.color.buttonParentColor, 'assets/ic_parents.png');
      case 'food':
      case 'makan':
        return (context.color.buttonFoodColor, 'assets/ic_food.png');
      case 'transportation':
      case 'transport':
      case 'transportasi':
        return (context.color.buttonTransportationColor, 'assets/ic_transportation.png');
      case 'shopping':
      case 'belanja':
        return (context.color.buttonShoppingColor, 'assets/ic_shopping.png');
      case 'health':
        return (context.color.buttonHealthColor, 'assets/ic_health.png');
      case 'education':
        return (context.color.buttonEducationColor, 'assets/ic_education.png');
      case 'housing':
        return (context.color.buttonHousingColor, 'assets/ic_housing.png');
      case 'internet':
        return (context.color.buttonInternetColor, 'assets/ic_internet.png');
      case 'lainnya':
      case 'others':
        return (context.color.backgroundGreyColor, 'assets/ic_bonus.png');
      default:
        // Fallback untuk kategori 'others' atau yang tidak dikenal
        return (context.color.buttonInternetColor, 'assets/ic_bonus.png');
    }
  }

  // Widget helper untuk membangun setiap baris item
  Widget _buildItemTile(model.TransactionItem item) {
    final String categoryForIcon =
        item.category.isNotEmpty ? item.category : 'others';
    final categoryUI = _getCategoryUIData(categoryForIcon);
    final Color bgColor = categoryUI.$1;
    final String iconPath = categoryUI.$2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RecentTransactionCard(
        backgroundColor: bgColor,
        icon: Image.asset(iconPath, width: 30.r, height: 30.r),
        title: item.itemName,
        subtitle: 'Qty: ${item.quantity}',
        amount:
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(double.tryParse(item.price) ?? 0),
        amountColor: context.color.buttonColor,
      ),
    );
  }
}

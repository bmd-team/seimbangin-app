import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class AddTransactionIncomeSection extends StatelessWidget {
  final TextEditingController transactNameController;
  final TextEditingController transactPriceController;
  final ValueChanged onChangePressed;

  final String amountTitle;

  const AddTransactionIncomeSection({
    super.key,
    required this.transactNameController,
    required this.transactPriceController,
    required this.onChangePressed,
    this.amountTitle = "Jumlah Transaksi",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.r),
        Text(
          amountTitle,
          style: context.text.greyTextStyle
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.r),
        TextField(
          controller: transactPriceController,
          onChanged: onChangePressed,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '0',
            hintStyle: context.text.greyTextStyle.copyWith(
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
            ),
            prefixText: 'Rp ',
            prefixStyle: context.text.blackTextStyle.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: context.color.primaryColor,
            ),
          ),
          keyboardType: TextInputType.number,
          style: context.text.blackTextStyle.copyWith(
            fontSize: 48.sp,
            fontWeight: FontWeight.bold,
            color: context.color.primaryColor,
          ),
        ),
        SizedBox(height: 24.r),
        TextField(
          controller: transactNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.color.backgroundGreyColor,
            hintText: 'Nama Transaksi / Catatan',
            hintStyle: context.text.greyTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24).r,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24).r,
              borderSide: BorderSide(
                color: context.color.primaryColor,
              ),
            ),
            prefixIcon: Icon(Icons.edit_note_rounded,
                color: context.color.textSecondaryColor),
          ),
          style: context.text.blackTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.r),
      ],
    );
  }
}

// Menerima data dinamis dari map SQLite
class CategorySelector extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String)? onCategorySelected;
  final Color activeColor;

  const CategorySelector({
    super.key,
    required this.categories,
    this.onCategorySelected,
    this.activeColor = const Color(0xffE91E63),
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? _selectedCategoryTitle;

  void _handleCategoryTap(String categoryTitle) {
    setState(() {
      _selectedCategoryTitle = categoryTitle;
    });
    widget.onCategorySelected?.call(categoryTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: context.text.blackTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 16.r),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: widget.categories.map((category) {
              final String catName = category['name'] as String;
              final int catIconCode = category['icon_code'] as int;
              final isSelected = _selectedCategoryTitle == catName;

              return GestureDetector(
                onTap: () => _handleCategoryTap(catName),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 12.r),
                  width: 155.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.color.primaryColor
                        : context.color.backgroundWhiteColor,
                    borderRadius: BorderRadius.circular(16).r,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : context.color.backgroundGreyColor,
                      width: 1.5.r,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: context.color.primaryColor
                                  .withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.r),
                        child: Row(
                          children: [
                            // Icon container mapping using Material Icons
                            Container(
                              width: 44.w,
                              height: 44.h,
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.black.withValues(alpha: 0.15)
                                    : context.color.backgroundGreyColor,
                                borderRadius: BorderRadius.circular(12).r,
                              ),
                              child: Icon(
                                IconData(catIconCode,
                                    fontFamily: 'MaterialIcons'),
                                color: isSelected
                                    ? Colors.white
                                    : context.color.textSecondaryColor,
                                size: 24.r,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Title Text layout
                            Expanded(
                              child: Text(
                                catName,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : context.color.textPrimaryColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Top Right Dashed-Like Circle for active state
                      if (isSelected)
                        Positioned(
                          top: 10.r,
                          right: 10.r,
                          child: Container(
                            width: 16.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.2,
                                style: BorderStyle.none,
                              ),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: CustomPaint(
                                  painter:
                                      DashedCirclePainter(color: Colors.white),
                                  child: const SizedBox.expand(),
                                )),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;

  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    const double dashLength = 3;
    const double gapLength = 3;
    final double perimeter = 2 * 3.141592653589793 * radius;

    double startAngle = 0;
    while (startAngle < 2 * 3.141592653589793) {
      final double sweepAngle =
          (dashLength / perimeter) * 2 * 3.141592653589793;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle +=
          sweepAngle + ((gapLength / perimeter) * 2 * 3.141592653589793);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

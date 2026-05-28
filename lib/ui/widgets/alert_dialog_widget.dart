import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class AlertDialogWidget {
  static void showLoading(BuildContext context,
      {String message = 'Saving Transaction...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // Pastikan menggunakan root navigator
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false, // Mencegah back button
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(24).r,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24).r,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: context.color.primaryColor,
                  strokeWidth: 4,
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  style: context.text.blackTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void dismiss(BuildContext context) {
    try {
      // Coba dismiss dengan root navigator
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }

      // Fallback: coba dengan navigator biasa
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Jika ada error, coba popUntil untuk memastikan dialog tertutup
      try {
        Navigator.of(context, rootNavigator: true).popUntil((route) {
          return route.settings.name != null || route.isFirst;
        });
      } catch (e2) {
        // Last resort
        debugPrint('Error dismissing dialog: $e2');
      }
    }
  }

  // Method tambahan untuk dismiss dengan delay
  static Future<void> dismissWithDelay(BuildContext context,
      {Duration delay = const Duration(milliseconds: 100)}) async {
    await Future.delayed(delay);
    if (context.mounted) {
      dismiss(context);
    }
  }
}

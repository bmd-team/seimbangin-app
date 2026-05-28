import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/blocs/transaction/transaction_bloc.dart';
import 'package:seimbangin_app/routes/routes.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';
import 'package:seimbangin_app/ui/widgets/card_widget.dart';

class LastTransactionsSection extends StatelessWidget {
  const LastTransactionsSection({super.key});

  /// Helper untuk mendapatkan warna dan ikon berdasarkan kategori transaksi.
  (Color, String) _getCategoryUIData(BuildContext context, String category) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 32.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaksi Terakhir",
                style: context.text.blackTextStyle.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => routes.pushNamed(RouteNames.historyTransact),
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: context.color.textBlueColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.r),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, transactionState) {
              // Kondisi 1: State sukses dan data berhasil dimuat.
              if (transactionState is TransactionLoadSuccess) {
                // Jika daftar transaksi terkini kosong, tampilkan kartu informasi.
                if (transactionState.recentTransactions.isEmpty) {
                  return RecentTransactionCard(
                    onTap: null, // Tidak ada aksi saat diklik
                    backgroundColor: context.color.backgroundGreyColor,
                    icon: Icon(Icons.wallet_outlined,
                        size: 30.r, color: context.color.textSecondaryColor),
                    title: "Belum ada transaksi",
                    subtitle: "Transaksi terakhir Anda akan muncul di sini",
                    amount: "",
                    amountColor: context.color.textSecondaryColor,
                  );
                }

                // Jika ada data, tampilkan dalam bentuk list.
                return Column(
                  children:
                      transactionState.recentTransactions.map((transaction) {
                    final createdAt =
                        DateTime.parse(transaction.createdAt!).toLocal();
                    final timeString = DateFormat('d MMM yyyy • HH:mm', 'id_ID').format(createdAt);
                    final total = double.tryParse(transaction.amount)?.toInt() ?? 0;
                    final prefix = transaction.type == 0 ? '+' : '-';
                    final Color amountColor = transaction.type == 0
                        ? context.color.textGreenColor
                        : context.color.textWarningColor;

                    // Logika yang sudah diperbaiki untuk menentukan kategori
                    String categoryForIcon = 'others'; // Nilai default

                    if (transaction.items.isNotEmpty &&
                        transaction.items.first.category.isNotEmpty) {
                      categoryForIcon = transaction.items.first.category;
                    } else if (transaction.category.isNotEmpty) {
                      categoryForIcon = transaction.category;
                    }

                    final categoryUI = _getCategoryUIData(context, categoryForIcon);
                    final Color bgColor = categoryUI.$1;
                    final String iconPath = categoryUI.$2;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.r),
                      child: RecentTransactionCard(
                        onTap: () {
                          routes.pushNamed(RouteNames.transactionDetail,
                              extra: transaction);
                        },
                        backgroundColor: bgColor,
                        icon: Image.asset(iconPath, width: 30.r, height: 30.r),
                        title: transaction.name,
                        subtitle: timeString,
                        amount: "$prefix${NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(total)}",
                        amountColor: amountColor,
                      ),
                    );
                  }).toList(),
                );
              }
              // Kondisi 2: Gagal memuat data.
              else if (transactionState is TransactionFailure) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.r),
                    child: Text(
                      "Tidak dapat memuat transaksi.",
                      style: context.text.greyTextStyle.copyWith(fontSize: 14.sp),
                    ),
                  ),
                );
              }
              // Kondisi 3: Sedang memuat atau state awal.
              else {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.r),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

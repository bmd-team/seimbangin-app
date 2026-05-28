import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seimbangin_app/blocs/transaction/transaction_bloc.dart';
import 'package:seimbangin_app/models/transaction/transaction_model.dart';
import 'package:seimbangin_app/routes/routes.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';
import 'package:seimbangin_app/ui/widgets/buttons_widget.dart';
import 'package:seimbangin_app/ui/widgets/card_widget.dart';
import 'package:collection/collection.dart';

class HistoryTransactPage extends StatefulWidget {
  const HistoryTransactPage({super.key});

  @override
  State<HistoryTransactPage> createState() => _HistoryTransactPageState();
}

class _HistoryTransactPageState extends State<HistoryTransactPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(FetchHistoryTransactions(isRefresh: true));
  }

  Future<void> _onRefresh() async {
    context
        .read<TransactionBloc>()
        .add(FetchHistoryTransactions(isRefresh: true));
    await context.read<TransactionBloc>().stream.firstWhere(
        (state) => state is TransactionLoadSuccess || state is TransactionFailure);
  }

  Map<String, List<TransactionData>> _groupTransactionsByMonth(
      List<TransactionData> transactions) {
    final now = DateTime.now();
    // Gunakan locale bahasa Indonesia agar bulan seperti 'Oktober', 'Agustus' tampil dengan benar.
    final monthYearFormat = DateFormat('MMMM yyyy', 'id_ID');

    return groupBy(transactions, (TransactionData transaction) {
      final date = DateTime.parse(transaction.createdAt!).toLocal();
      if (date.year == now.year && date.month == now.month) {
        return 'Bulan Ini';
      }
      return monthYearFormat.format(date);
    });
  }

  /// Helper untuk mendapatkan warna dan ikon berdasarkan kategori transaksi.
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
        return (context.color.buttonInternetColor, 'assets/ic_bonus.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundGreyColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: context.color.backgroundGreyColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 8.h, bottom: 8.h),
          child: CustomRoundedButton(
            onPressed: () => Navigator.of(context).pop(),
            widget:
                Icon(Icons.chevron_left, size: 28.r, color: context.color.textSecondaryColor),
            backgroundColor: context.color.backgroundWhiteColor,
          ),
        ),
        title: Text(
          'Histori Transaksi',
          style: context.text.blackTextStyle.copyWith(
              fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _buildTransactionList(),
    );
  }

  Widget _buildTransactionList() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoadSuccess) {
          if (state.historicalTransactions.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
                children: [
                  RecentTransactionCard(
                    backgroundColor: context.color.backgroundGreyColor,
                    icon: Icon(Icons.receipt_long_rounded,
                        size: 30.r, color: context.color.textSecondaryColor),
                    title: "Belum ada transaksi",
                    subtitle: "Transaksi yang Anda buat akan muncul di sini.",
                    amount: "",
                    amountColor: context.color.textSecondaryColor,
                  ),
                ],
              ),
            );
          }

          final groupedTransactions =
              _groupTransactionsByMonth(state.historicalTransactions);
          final groupKeys = groupedTransactions.keys.toList();

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
              itemCount: groupKeys.length,
              itemBuilder: (context, index) {

                final monthKey = groupKeys[index];
                final transactionsInMonth = groupedTransactions[monthKey] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 16.h, top: index == 0 ? 0 : 24.h),
                      child: Text(
                        monthKey,
                        style: context.text.blackTextStyle.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                      ...transactionsInMonth.map((transaction) {
                      final total = double.tryParse(transaction.amount)?.toInt() ?? 0;
                      final prefix = transaction.type == 0 ? '+' : '-';
                      final amountColor = transaction.type == 0
                          ? context.color.textGreenColor
                          : context.color.textWarningColor;
                      final date = DateFormat('d MMM yyyy • HH:mm', 'id_ID')
                          .format(
                              DateTime.parse(transaction.createdAt!).toLocal());

                      String categoryForIcon = 'others';

                      if (transaction.items.isNotEmpty &&
                          transaction.items.first.category.isNotEmpty) {
                        categoryForIcon = transaction.items.first.category;
                      } else if (transaction.category.isNotEmpty) {
                        categoryForIcon = transaction.category;
                      }

                      final categoryUI = _getCategoryUIData(categoryForIcon);
                      final Color bgColor = categoryUI.$1;
                      final String iconPath = categoryUI.$2;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: RecentTransactionCard(
                          onTap: () => routes.pushNamed(
                              RouteNames.transactionDetail,
                              extra: transaction),
                          backgroundColor: bgColor,
                          icon:
                              Image.asset(iconPath, width: 30.r, height: 30.r),
                          title: transaction.name,
                          subtitle: date,
                          amount:
                              "$prefix${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(total)}",
                          amountColor: amountColor,
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          );
        }

        if (state is TransactionFailure) {
          return Center(child: Text(state.message));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

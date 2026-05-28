import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:seimbangin_app/models/transaction/transaction_model.dart';

import 'package:seimbangin_app/services/transaction/transaction_service.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService transactionService;

  TransactionBloc({required this.transactionService})
      : super(TransactionInitial()) {
    on<TransactionButtonPressed>(_addTransaction);
    on<GetRecentTransactionsEvent>(_getRecentTransaction);
    on<FetchHistoryTransactions>(_onFetchHistory);
  }

  /// Handler untuk menambahkan transaksi baru.
  Future<void> _addTransaction(
      TransactionButtonPressed event, Emitter<TransactionState> emit) async {
    try {
      emit(TransactionLoading("Loading..."));
      await transactionService
          .addTransaction(
              event.items, event.type, event.description, event.name)
          .timeout(
            const Duration(seconds: 15),
          );
      emit(TransactionSuccess("Transaction successful"));
    } catch (e) {
      emit(TransactionFailure("Failed to add transaction: $e"));
    }
  }

  /// Handler untuk mengambil data transaksi terkini (untuk homepage).
  Future<void> _getRecentTransaction(
      GetRecentTransactionsEvent event, Emitter<TransactionState> emit) async {
    // Hanya emit loading jika belum ada data sama sekali.
    if (state is! TransactionLoadSuccess) {
      emit(TransactionLoading("Loading recent transactions..."));
    }

    try {
      final response =
          await transactionService.getTransaction(limit: event.limit, page: 1);

      final currentState = state is TransactionLoadSuccess
          ? (state as TransactionLoadSuccess)
          : TransactionLoadSuccess();

      emit(currentState.copyWith(
        recentTransactions: response.data,
      ));
    } catch (e) {
      emit(TransactionFailure("Failed to get recent transaction: $e"));
    }
  }

  /// Handler untuk mengambil seluruh riwayat transaksi (tanpa pagination).
  Future<void> _onFetchHistory(
      FetchHistoryTransactions event, Emitter<TransactionState> emit) async {
    try {
      final prevRecentTx = state is TransactionLoadSuccess
          ? (state as TransactionLoadSuccess).recentTransactions
          : <TransactionData>[];
      emit(TransactionLoading("Loading history..."));
      final response = await transactionService.getHistoryTransactions();
      emit(TransactionLoadSuccess(
        recentTransactions: prevRecentTx,
        historicalTransactions: response.data,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(TransactionFailure("Failed to load history: $e"));
    }
  }
}

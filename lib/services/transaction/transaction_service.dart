import 'dart:convert';

import 'package:seimbangin_app/models/transaction/transaction_model.dart';
import 'package:seimbangin_app/services/local_database_service.dart';

class TransactionService {
  final LocalDatabaseService _dbService = LocalDatabaseService();

  Future<void> addTransaction(List<TransactionItem> items, int type,
      String description, String name) async {
    try {
      final double totalAmount = items.fold(0.0, (sum, item) {
        final price = double.tryParse(item.price) ?? 0.0;
        final qty = item.quantity > 0 ? item.quantity : 1;
        return sum + (price * qty);
      });
      
      // Save primary transaction summary
      await _dbService.insertTransaction({
        'name': name,
        'amount': totalAmount,
        'type': type == 1 ? 'outcome' : 'income',
        'category': items.isNotEmpty ? items.first.category : 'others',
        'date': DateTime.now().toIso8601String(),
        'notes': description,
      }, items: items.map((item) => item.toJson()).toList());

      print('[TransactionService] OFFLINE ADD TRANSACTION - Success');
    } catch (e) {
      print('[TransactionService] OFFLINE ADD TRANSACTION - Error: $e');
      throw Exception('Error during offline addTransaction: $e');
    }
  }

  Future<TransactionResponse> getHistoryTransactions() async {
    try {
      final List<Map<String, dynamic>> localData = await _dbService.getTransactions();
      List<TransactionData> allData = localData.map((row) {
        List<TransactionItem> items = [];
        final itemsJson = row['items_json'] as String?;
        if (itemsJson != null && itemsJson.isNotEmpty) {
          final List<dynamic> parsed = jsonDecode(itemsJson);
          items = parsed
              .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return TransactionData(
          id: row['id'] as int,
          name: row['name'] ?? 'Transaction',
          type: row['type'] == 'income' ? 0 : 1,
          category: row['category'] ?? 'others',
          description: row['notes'] ?? '',
          amount: (row['amount'] as num?)?.toString() ?? '0',
          createdAt: row['date'] ?? DateTime.now().toIso8601String(),
          updatedAt: row['date'] ?? DateTime.now().toIso8601String(),
          items: items,
        );
      }).toList();
      return TransactionResponse(
        success: true,
        message: 'Success retrieving all history',
        data: allData,
        meta: Meta(hasNextPage: false),
      );
    } catch (e) {
      throw Exception('Failed to load offline history: $e');
    }
  }

  Future<TransactionResponse> getTransaction(
      {required int limit, required int page}) async {
    try {
      final List<Map<String, dynamic>> localData = await _dbService.getTransactions();
      
      // Map basic sqlite response to TransactionData models dynamically
      List<TransactionData> dummyList = localData.map((row) {
        List<TransactionItem> items = [];
        final itemsJson = row['items_json'] as String?;
        if (itemsJson != null && itemsJson.isNotEmpty) {
          final List<dynamic> parsed = jsonDecode(itemsJson);
          items = parsed
              .map((e) =>
                  TransactionItem.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return TransactionData(
          id: row['id'] as int,
          name: row['name'] ?? 'Transaction',
          type: row['type'] == 'income' ? 0 : 1, // 0 For Income, 1 For Outcome
          category: row['category'] ?? 'others',
          description: row['notes'] ?? '',
          amount: (row['amount'] as num?)?.toString() ?? '0',
          createdAt: row['date'] ?? DateTime.now().toIso8601String(),
          updatedAt: row['date'] ?? DateTime.now().toIso8601String(),
          items: items,
        );
      }).toList();

      final int startIndex = (page - 1) * limit;
      int endIndex = startIndex + limit;
      
      List<TransactionData> pagedData = [];
      if (startIndex < dummyList.length) {
        if (endIndex > dummyList.length) endIndex = dummyList.length;
        pagedData = dummyList.sublist(startIndex, endIndex);
      }

      bool hasNextPage = endIndex < dummyList.length;

      return TransactionResponse(
        success: true,
        message: 'Success retrieving local data',
        data: pagedData,
        meta: Meta(
          currentPage: page,
          limit: limit,
          hasNextPage: hasNextPage,
        ),
      );
    } catch (e) {
      throw Exception('Failed to load offline transaction (GET): $e');
    }
  }
}

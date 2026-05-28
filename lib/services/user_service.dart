import 'package:shared_preferences/shared_preferences.dart';
import 'package:seimbangin_app/models/advice_model.dart';
import 'package:seimbangin_app/models/user/user_model.dart';
import 'package:seimbangin_app/services/local_database_service.dart';

class UserService {
  Future<UserResponse> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dbService = LocalDatabaseService();
      
      final savings = prefs.getInt('current_savings') ?? 0;
      final debt = prefs.getInt('debt') ?? 0;
      final goals = prefs.getString('financial_goals') ?? 'Berinvestasi untuk masa depan dan menyiapkan rumah impian';
      final risk = prefs.getString('risk_management') ?? 'Rendah';

      // Hitung total transaksi riil dari SQLite
      final transactions = await dbService.getTransactions();
      double totalIncome = 0;
      double totalOutcome = 0;
      
      for (var t in transactions) {
        final amount = t['amount'] as double? ?? 0.0;
        if (t['type'] == 'income') {
          totalIncome += amount;
        } else if (t['type'] == 'outcome') {
          totalOutcome += amount;
        }
      }
      
      final balance = savings + totalIncome - totalOutcome;

      final user = UserData(
        id: 1,
        fullName: 'User Offline',
        email: 'offline@seimbangin.com',
        username: 'user_offline',
        balance: balance.toStringAsFixed(0),
        financeProfile: FinanceProfile(
          currentSavings: savings.toString(),
          debt: debt.toString(),
          financialGoals: goals,
          riskManagement: risk,
          monthlyIncome: 10000000,
          totalIncome: totalIncome.toStringAsFixed(0),
          totalOutcome: totalOutcome.toStringAsFixed(0),
        ),
      );

      return UserResponse(
        status: 'success',
        data: user,
      );
    } catch (e) {
      print('Error offline user: $e');
      throw Exception('Failed to load local user data: $e');
    }
  }

  Future<Advice> getUserAdvice() async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate AI thinking delay
      return Advice(
        status: 'success',
        code: 200,
        message: 'OK',
        data: 'Halo! Saya adalah Penasihat Keuangan Offline Anda. Saat ini aplikasi berjalan tanpa jaringan internet, jadi saya belum bisa memberikan saran yang diperbarui secara real-time. Namun, tetap pertahankan tabungan di atas pengeluaran bulanan Anda, dan selalu perhatikan rasio hutang Anda!',
      );
    } catch (e) {
      throw Exception('Failed to mock offline advice: $e');
    }
  }

  Future<void> updateUserProfile(int currentSavings, int debt,
      String financialGoals, String riskManagement) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_savings', currentSavings);
      await prefs.setInt('debt', debt);
      await prefs.setString('financial_goals', financialGoals);
      await prefs.setString('risk_management', riskManagement);
      print('[UserService] OFFLINE Profile Updated Successfully');
    } catch (e) {
      throw Exception('Failed to update offline user profile settings: $e');
    }
  }
}


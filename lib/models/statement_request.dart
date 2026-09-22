import 'user_model.dart';
import 'transaction_item.dart';

/// Model parameter permintaan cetak rekening koran
class StatementRequest {
  final UserModel user;
  final DateTime startDate;
  final DateTime endDate;
  final String targetEmail;
  final List<TransactionItem> transactions;

  const StatementRequest({
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.targetEmail,
    required this.transactions,
  });

  double get totalCredit => transactions
      .where((t) => t.isCredit)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalDebit => transactions
      .where((t) => !t.isCredit)
      .fold(0.0, (sum, item) => sum + item.amount);
}


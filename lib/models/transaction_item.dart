/// Model item mutasi transaksi rekening koran BJB
class TransactionItem {
  final DateTime date;
  final String description;
  final String referenceNumber;
  final double amount;
  final bool isCredit; // true = masuk (CR), false = keluar (DB)
  final double balanceAfter;

  const TransactionItem({
    required this.date,
    required this.description,
    required this.referenceNumber,
    required this.amount,
    required this.isCredit,
    required this.balanceAfter,
  });

  /// Daftar 5 transaksi persis 1:1 sesuai referensi visual 11mutasi_rekening_hasil__page.jpeg
  static List<TransactionItem> get defaultReferenceTransactions => [
    TransactionItem(
      date: DateTime(2026, 8, 29),
      description: '0013D20260829PDJBIDJA01000208915170 TRF KE BRINIDJA/MUHAMAD SAEPURAHMAN NOREK 053301022300506',
      referenceNumber: '0013D20260829PDJBIDJA01000208915170',
      amount: 1800000.0,
      isCredit: false,
      balanceAfter: 107120.0,
    ),
    TransactionItem(
      date: DateTime(2026, 8, 29),
      description: '0013D20260829PDJBIDJA01000208915170 BY TRF KE BRINIDJA/MUHAMAD SAEPURAH NOREK 053301022300506',
      referenceNumber: '0013D20260829PDJBIDJA01000208915171',
      amount: 2500.0,
      isCredit: false,
      balanceAfter: 1907120.0,
    ),
    TransactionItem(
      date: DateTime(2026, 8, 28),
      description: 'TPG-5991-11549-MUHAMAD SAEPURA',
      referenceNumber: 'TPG-5991-11549',
      amount: 1880000.0,
      isCredit: true,
      balanceAfter: 1909620.0,
    ),
    TransactionItem(
      date: DateTime(2026, 8, 27),
      description: '157 DB -Biaya Adm ATM',
      referenceNumber: '157DBADM01',
      amount: 19000.0,
      isCredit: false,
      balanceAfter: 29620.0,
    ),
    TransactionItem(
      date: DateTime(2026, 8, 22),
      description: '150 DB -Biaya Administrasi',
      referenceNumber: '150DBADM02',
      amount: 3500.0,
      isCredit: false,
      balanceAfter: 48620.0,
    ),
  ];

  /// Sample mutasi transaksi untuk pengisian rekening koran realistis
  static List<TransactionItem> generateSampleTransactions(
    DateTime startDate,
    DateTime endDate,
    double initialBalance,
  ) {
    // Jika range mencakup Agustus 2026, kembalikan transaksi referensi asli
    if (startDate.month == 8 && startDate.year == 2026) {
      return defaultReferenceTransactions;
    }

    final List<TransactionItem> items = [];
    double runningBalance = initialBalance;

    final sampleTemplates = [
      {
        'desc': '0013D20260829PDJBIDJA01000208915170 TRF KE BRINIDJA/MUHAMAD SAEPURAHMAN NOREK 053301022300506',
        'cr': false,
        'amt': 1800000.0,
      },
      {
        'desc': '0013D20260829PDJBIDJA01000208915170 BY TRF KE BRINIDJA/MUHAMAD SAEPURAH NOREK 053301022300506',
        'cr': false,
        'amt': 2500.0,
      },
      {'desc': 'TPG-5991-11549-MUHAMAD SAEPURA', 'cr': true, 'amt': 1880000.0},
      {'desc': '157 DB -Biaya Adm ATM', 'cr': false, 'amt': 19000.0},
      {'desc': '150 DB -Biaya Administrasi', 'cr': false, 'amt': 3500.0},
    ];

    final totalDays = endDate.difference(startDate).inDays;
    final int step = totalDays > 10 ? (totalDays ~/ 8).clamp(1, 5) : 1;

    DateTime current = startDate;
    int index = 0;
    while (!current.isAfter(endDate) && index < sampleTemplates.length) {
      final template = sampleTemplates[index % sampleTemplates.length];
      final isCr = template['cr'] as bool;
      final amt = template['amt'] as double;

      if (isCr) {
        runningBalance += amt;
      } else {
        runningBalance -= amt;
      }

      final ref =
          'BJB${current.millisecondsSinceEpoch.toString().substring(5)}$index';

      items.add(
        TransactionItem(
          date: current,
          description: template['desc'] as String,
          referenceNumber: ref,
          amount: amt,
          isCredit: isCr,
          balanceAfter: runningBalance,
        ),
      );

      current = current.add(Duration(days: step));
      index++;
    }

    return items.isNotEmpty ? items : defaultReferenceTransactions;
  }
}

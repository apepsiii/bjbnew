/// Model data profil nasabah Bank BJB
class UserModel {
  final String fullName;
  final String accountNumber;
  final String accountType;
  final double balance;
  final String phoneNumber;
  final String cif;
  final String email;
  final String branchName;
  final String branchAddress;

  const UserModel({
    required this.fullName,
    required this.accountNumber,
    this.accountType = 'Tabungan Simpeda',
    required this.balance,
    required this.phoneNumber,
    this.cif = '0070482584100',
    this.email = 'aldi.firnando@gmail.com',
    this.branchName = 'KC CIBINONG',
    this.branchAddress =
        'Kp. Siliwangi RT 001 RW 003 Cigombong, Kab. Bogor, Jawa Barat',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['full_name'] as String? ?? 'ALDI FIRNANDO',
      accountNumber: json['account_number'] as String? ?? '0070482584100',
      accountType: json['product_name'] as String? ?? 'Tabungan Simpeda',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: '081298765432',
      cif: json['account_number'] as String? ?? '0070482584100',
      email: '${json['username'] ?? "user"}@bjb.co.id',
      branchName: json['branch'] as String? ?? 'KC CIBINONG',
      branchAddress: json['address'] as String? ?? 'Kp. Siliwangi RT 001 RW 003 Cigombong, Kab. Bogor, Jawa Barat',
    );
  }

  UserModel copyWith({
    String? fullName,
    String? accountNumber,
    String? accountType,
    double? balance,
    String? phoneNumber,
    String? cif,
    String? email,
    String? branchName,
    String? branchAddress,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      balance: balance ?? this.balance,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cif: cif ?? this.cif,
      email: email ?? this.email,
      branchName: branchName ?? this.branchName,
      branchAddress: branchAddress ?? this.branchAddress,
    );
  }

  /// Default profil nasabah demo
  static const UserModel defaultUser = UserModel(
    fullName: 'ALDI FIRNANDO',
    accountNumber: '0070482584100',
    accountType: 'Tabungan Simpeda',
    balance: 36821139.0,
    phoneNumber: '081298765432',
    cif: '0070482584100',
    email: 'aldi.firnando@gmail.com',
    branchName: 'KC CIBINONG',
    branchAddress: 'Kp. Siliwangi RT 001 RW 003 Cigombong, Kab. Bogor, Jawa Barat',
  );
}

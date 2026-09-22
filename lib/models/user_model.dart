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
    this.accountType = 'Tandamata Sertifikasi Guru',
    required this.balance,
    required this.phoneNumber,
    this.cif = '0157902441',
    this.email = 'saepurahman.bjb@gmail.com',
    this.branchName = 'KC BOGOR',
    this.branchAddress =
        'Jl. Kapten Muslihat No. 11-13, Kota Bogor, Jawa Barat',
  });

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

  /// Default profil nasabah demo sesuai referensi visual 1:1
  static const UserModel defaultUser = UserModel(
    fullName: 'MUHAMAD SAEPURAHMAN',
    accountNumber: '0157902441103',
    accountType: 'Tandamata Sertifikasi Guru',
    balance: 107120.0,
    phoneNumber: '081298765432',
    cif: '0157902441',
    email: 'saepurahman.bjb@gmail.com',
    branchName: 'KC BOGOR',
    branchAddress: 'Jl. Kapten Muslihat No. 11-13, Kota Bogor, Jawa Barat',
  );
}

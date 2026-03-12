class User {
  final int? id;
  final String email;
  final String? fullName;

  // Business address
  final String? pincode;
  final String? address;
  final String? city;
  final String? state;
  final String? country;

  // Bank account details
  final String? bankAccountNumber;
  final String? accountHolderName;
  final String? ifscCode;

  User({
    this.id,
    required this.email,
    this.fullName,
    this.pincode,
    this.address,
    this.city,
    this.state,
    this.country,
    this.bankAccountNumber,
    this.accountHolderName,
    this.ifscCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['name'],
      pincode: json['pincode']?.toString(),
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      bankAccountNumber: json['bankAccountNumber']?.toString() ?? json['bank_account_number']?.toString(),
      accountHolderName: json['accountHolderName'] ?? json['account_holder_name'],
      ifscCode: json['ifscCode'] ?? json['ifsc_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      if (fullName != null) 'fullName': fullName,
      if (pincode != null) 'pincode': pincode,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (bankAccountNumber != null) 'bankAccountNumber': bankAccountNumber,
      if (accountHolderName != null) 'accountHolderName': accountHolderName,
      if (ifscCode != null) 'ifscCode': ifscCode,
    };
  }
}
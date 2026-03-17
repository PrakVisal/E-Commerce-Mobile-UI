class User {
  final int? id;
  final String email;
  final String? username;
  final String? fullName;

  // Address
  final String? pincode;
  final String? address;
  final String? city;
  final String? state;
  final String? country;

  User({
    this.id,
    required this.email,
    this.username,
    this.fullName,
    this.pincode,
    this.address,
    this.city,
    this.state,
    this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'],
      fullName: json['fullName'] ?? json['name'],
      pincode: json['pincode']?.toString(),
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      if (username != null) 'username': username,
      if (fullName != null) 'fullName': fullName,
      if (pincode != null) 'pincode': pincode,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
    };
  }
}

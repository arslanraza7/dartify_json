

import 'package:example/generated/user_country.dart';

class User {
  final String street;
  final String city;
  final Country country;

  User({
    required this.street,
    required this.city,
    required this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      street: json['street'],
      city: json['city'],
      country: Country.fromJson(json['country']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'country': country.toJson(),
    };
  }
}

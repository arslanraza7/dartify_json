import 'package:example/generated/address_country.dart';
import 'package:example/generated/user.dart';
import 'package:example/generated/user_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';


void main() {
  group('Generated Class Tests', () {
    test('User fromJson Test', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
        'address': {
          'street': '123 Main St',
          'city': 'Metropolis',
          'country': {
            'name': 'Wonderland',
            'code': 'WL'
          }
        }
      };

      // Deserialize JSON to User object
      final user = User.fromJson(json);

      // Assertions
      expect(user.id, 1);
      expect(user.name, 'John Doe');
      expect(user.address.street, '123 Main St');
      expect(user.address.city, 'Metropolis');
      expect(user.address.country.name, 'Wonderland');
      expect(user.address.country.code, 'WL');
    });

    test('User toJson Test', () {
      // Create a User object
      final address = Address(
        street: '123 Main St',
        city: 'Metropolis',
        country: Country(name: 'Wonderland', code: 'WL'),
      );
      final user = User(id: 1, name: 'John Doe', address: address);

      // Serialize User object to JSON
      final json = user.toJson();

      // Expected JSON map
      final expectedJson = {
        'id': 1,
        'name': 'John Doe',
        'address': {
          'street': '123 Main St',
          'city': 'Metropolis',
          'country': {
            'name': 'Wonderland',
            'code': 'WL'
          }
        }
      };

      // Assertions
      expect(json, expectedJson);
    });

    test('Address fromJson Test', () {
      // Sample JSON data
      final json = {
        'street': '123 Main St',
        'city': 'Metropolis',
        'country': {
          'name': 'Wonderland',
          'code': 'WL'
        }
      };

      // Deserialize JSON to Address object
      final address = Address.fromJson(json);

      // Assertions
      expect(address.street, '123 Main St');
      expect(address.city, 'Metropolis');
      expect(address.country.name, 'Wonderland');
      expect(address.country.code, 'WL');
    });

    test('Address toJson Test', () {
      // Create an Address object
      final address = Address(
        street: '123 Main St',
        city: 'Metropolis',
        country: Country(name: 'Wonderland', code: 'WL'),
      );

      // Serialize Address object to JSON
      final json = address.toJson();

      // Expected JSON map
      final expectedJson = {
        'street': '123 Main St',
        'city': 'Metropolis',
        'country': {
          'name': 'Wonderland',
          'code': 'WL'
        }
      };

      // Assertions
      expect(json, expectedJson);
    });
  });
}


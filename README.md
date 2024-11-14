# Dart Class Generator from JSON

This tool allows you to generate Dart classes from JSON files. It helps in converting a given JSON structure into a Dart class with fields, constructors, and `toJson` and `fromJson` methods. The generated classes are written to the `lib/generated` directory.

## Features

- Automatically generates Dart classes from a JSON file.
- Supports nested JSON structures by creating appropriate imports and nested classes.
- Creates `fromJson` and `toJson` methods for easy serialization and deserialization.

## Requirements

- Dart SDK installed.

## Usage

After adding this package as a dependency in your project, you can run the command like this:

```sh
dart run dartify_json -i <path_to_your_json_file> -c User
```

- `-i` or `--input`: Path to the JSON file.
- `-c` or `--className`: Class name for the generated Dart class.

### Example

Suppose you have the following JSON file `address.json`:

```json
{
  "street": "123 Main St",
  "city": "Metropolis",
  "country": {
    "name": "Wonderland",
    "code": "WL"
  }
}
```

To generate a Dart class from this JSON file, run:

```sh
dart run dartify_json -i address.json -c Address
```

The generated file will be saved in `lib/generated/address.dart` and will look like this:

```dart
import 'country.dart';

class Address {
  final String street;
  final String city;
  final Country country;

  Address({
    required this.street,
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
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
```

Additionally, if the JSON contains nested objects (e.g., `country`), the script will generate corresponding classes for those nested objects as well.

## Directory Structure

The generated files are placed in the `lib/generated` directory. If the directory does not exist, it will be created automatically.

### Example Directory Structure

```
project_root/
  ├── lib/
  │   ├── generated/
  │   │   ├── address.dart
  │   │   └── country.dart
  └── main.dart
```

## How It Works

1. **Parsing JSON**: The script takes a JSON file as input and parses it using `dart:convert`.
2. **Generating Fields**: The keys in the JSON object are used to create fields in the Dart class, and their types are inferred.
3. **Generating Methods**: The `fromJson` and `toJson` methods are generated for easy serialization and deserialization.
4. **Handling Nested Objects**: For nested JSON objects, additional Dart classes are generated and appropriate imports are added to the main class file.

## Using Generated Classes in an API

To use the generated Dart files in your API, follow these steps:

### 1. Import the Generated Classes
First, import the generated classes into the files where you'll be using them to handle API data.

For example, if you've generated a `User` class, you would import it like this:
```dart
import 'generated/user.dart';
```

### 2. Use the `fromJson` and `toJson` Methods
The generated classes come with `fromJson` and `toJson` methods that make it easy to work with JSON data from your API.

- **Receiving API Data**: When you receive data from an API (e.g., via an HTTP GET request), you can parse the JSON and use the `fromJson` method to convert it into a Dart object.

  Example:
  ```dart
  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'generated/user.dart';

  Future<User> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('https://api.example.com/users/$userId'));

    if (response.statusCode == 200) {
      // Convert JSON response to a User object
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
  ```

- **Sending API Data**: When you need to send data to an API (e.g., via an HTTP POST request), you can use the `toJson` method to convert your Dart object to a JSON map.

  Example:
  ```dart
  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'generated/user.dart';

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse('https://api.example.com/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }
  ```

### 3. Handling Nested JSON Structures
If your API returns nested JSON structures, you can use the generated classes for nested objects as well.

For example, if your `User` object contains an `Address` field, you can use the `Address` class that was also generated:
```dart
import 'generated/user.dart';
import 'generated/address.dart';

void main() {
  final address = Address(street: '123 Main St', city: 'Metropolis', country: Country(name: 'Wonderland', code: 'WL'));
  final user = User(id: 1, name: 'John Doe', address: address);

  // Convert to JSON for API usage
  print(user.toJson());
}
```

## Notes

- The script supports primitive types (`int`, `double`, `bool`, `String`) as well as nested objects and lists.
- If the JSON structure changes, you need to regenerate the Dart classes to reflect the changes.

## Troubleshooting

- If you see an error like `Input file not found`, make sure the JSON file path is correct.
- For nested JSON objects, make sure that the generated files are correctly imported in the respective classes.

## Contributions

Feel free to contribute by opening issues or pull requests if you have suggestions or find bugs.




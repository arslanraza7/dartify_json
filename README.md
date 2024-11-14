# Dart Class Generator from JSON

This tool allows you to generate Dart classes from JSON files. It helps in converting a given JSON structure into a Dart class with fields, constructors, and `toJson` and `fromJson` methods. The generated classes are written to the `lib/generated` directory.

## Features

- Automatically generates Dart classes from a JSON file.
- Supports nested JSON structures by creating appropriate imports and nested classes.
- Creates `fromJson` and `toJson` methods for easy serialization and deserialization.

## Requirements

- Dart SDK installed.
- The `args` package is required for command-line argument parsing. You can add it to your `pubspec.yaml`:

  ```yaml
  dependencies:
    args: ^2.6.0
  ```

## Usage

Run the script with the following command:

```sh
dart run dartify_json.dart -i <input> -c <className>
```

- `-i` or `--input`: Path to the JSON file or a JSON string.
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
dart run path/to/script.dart -i address.json -c Address
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

1. **Parsing JSON**: The script takes a JSON file or string as input and parses it using `dart:convert`.
2. **Generating Fields**: The keys in the JSON object are used to create fields in the Dart class, and their types are inferred.
3. **Generating Methods**: The `fromJson` and `toJson` methods are generated for easy serialization and deserialization.
4. **Handling Nested Objects**: For nested JSON objects, additional Dart classes are generated and appropriate imports are added to the main class file.

## Notes

- The script supports primitive types (`int`, `double`, `bool`, `String`) as well as nested objects and lists.
- If the JSON structure changes, you need to regenerate the Dart classes to reflect the changes.

## Troubleshooting

- If you see an error like `Input file not found`, make sure the JSON file path is correct.
- For nested JSON objects, make sure that the generated files are correctly imported in the respective classes.

## Contributions

Feel free to contribute by opening issues or pull requests if you have suggestions or find bugs.

## License

This project is open source and available under the MIT License.


// import 'dart:io';
// import 'dart:convert';
// import 'package:args/args.dart';
//
// void main(List<String> arguments) {
//   final parser = ArgParser()
//     ..addOption('input', abbr: 'i', help: 'Path to the JSON file or JSON string.')
//     ..addOption('className', abbr: 'c', help: 'Class name for the generated Dart class.');
//
//   final args = parser.parse(arguments);
//
//   final input = args['input'];
//   final className = args['className'];
//
//   if (input == null || className == null) {
//     print('Usage: dartify_json -i <input> -c <className>');
//     return;
//   }
//
//   final file = File(input);
//   if (file.existsSync()) {
//     final jsonContent = file.readAsStringSync();
//     final parsedJson = jsonDecode(jsonContent);
//     generateClassFromJson(parsedJson, className);
//   } else {
//     print('Error: Input file not found');
//   }
// }
//
// void generateClassFromJson(dynamic json, String className, [String parentClass = '']) {
//   final buffer = StringBuffer();
//
//   buffer.writeln("class $className {");
//
//   // Generate fields
//   json.keys.forEach((key) {
//     final type = inferType(json[key], capitalize(key));
//     buffer.writeln("  final $type $key;");
//   });
//
//   // Generate constructor
//   buffer.writeln("\n  $className({");
//   json.keys.forEach((key) {
//     buffer.writeln("    required this.$key,");
//   });
//   buffer.writeln("  });\n");
//
//   // Generate fromJson method
//   buffer.writeln("  factory $className.fromJson(Map<String, dynamic> json) {");
//   buffer.writeln("    return $className(");
//   json.keys.forEach((key) {
//     if (json[key] is Map) {
//       buffer.writeln("      $key: ${capitalize(key)}.fromJson(json['$key']),");
//     } else if (json[key] is List && json[key].isNotEmpty && json[key][0] is Map) {
//       buffer.writeln("      $key: (json['$key'] as List).map((e) => ${capitalize(key)}.fromJson(e)).toList(),");
//     } else {
//       buffer.writeln("      $key: json['$key'],");
//     }
//   });
//   buffer.writeln("    );");
//   buffer.writeln("  }\n");
//
//   // Generate toJson method
//   buffer.writeln("  Map<String, dynamic> toJson() {");
//   buffer.writeln("    return {");
//   json.keys.forEach((key) {
//     if (json[key] is Map) {
//       buffer.writeln("      '$key': $key.toJson(),");
//     } else if (json[key] is List && json[key].isNotEmpty && json[key][0] is Map) {
//       buffer.writeln("      '$key': $key.map((e) => e.toJson()).toList(),");
//     } else {
//       buffer.writeln("      '$key': $key,");
//     }
//   });
//   buffer.writeln("    };\n  }");
//
//   buffer.writeln("}");
//
//   final outputPath = parentClass.isEmpty ? '${className.toLowerCase()}.dart' : '${parentClass.toLowerCase()}_${className.toLowerCase()}.dart';
//   final outputFile = File(outputPath);
//   outputFile.writeAsStringSync(buffer.toString(), mode: FileMode.writeOnly);
//
//   print('Generated Dart class written to $outputPath');
//
//   // Generate nested classes if needed
//   json.keys.forEach((key) {
//     if (json[key] is Map) {
//       generateClassFromJson(json[key], capitalize(key), className);
//     } else if (json[key] is List && json[key].isNotEmpty && json[key][0] is Map) {
//       generateClassFromJson(json[key][0], capitalize(key), className);
//     }
//   });
// }
//
// String inferType(dynamic value, String key) {
//   if (value is int) {
//     return 'int';
//   } else if (value is double) {
//     return 'double';
//   } else if (value is bool) {
//     return 'bool';
//   } else if (value is String) {
//     return 'String';
//   } else if (value is List) {
//     if (value.isNotEmpty && value.first is Map) {
//       return 'List<${capitalize(key)}>';
//     } else {
//       return 'List<${inferType(value.first, key)}>';
//     }
//   } else if (value is Map) {
//     return capitalize(key);
//   } else {
//     return 'dynamic';
//   }
// }
//
// String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Path to the JSON file or JSON string.')
    ..addOption('className', abbr: 'c', help: 'Class name for the generated Dart class.');

  final args = parser.parse(arguments);

  final input = args['input'];
  final className = args['className'];

  if (input == null || className == null) {
    print('Usage: dartify_json -i <input> -c <className>');
    return;
  }

  final file = File(input);
  if (file.existsSync()) {
    final jsonContent = file.readAsStringSync();
    final parsedJson = jsonDecode(jsonContent);
    generateClassFromJson(parsedJson, className);
  } else {
    print('Error: Input file not found');
  }
}

void generateClassFromJson(dynamic json, String className, [String parentClass = '']) {
  final buffer = StringBuffer();
  final imports = <String>{};

  buffer.writeln("class $className {");

  // Generate fields
  json.keys.forEach((key) {
    final type = inferType(json[key], capitalize(key));
    buffer.writeln("  final $type $key;");

    // Add import for custom types
    if (type != 'int' && type != 'double' && type != 'bool' && type != 'String' && type != 'dynamic' && !type.startsWith('List<')) {
      final importPath = "lib/generated/${type.toLowerCase()}.dart";
      imports.add("import '$importPath';");
    }
  });

  // Generate constructor
  buffer.writeln("\n  $className({");
  json.keys.forEach((key) {
    buffer.writeln("    required this.$key,");
  });
  buffer.writeln("  });\n");

  // Generate fromJson method
  buffer.writeln("  factory $className.fromJson(Map<String, dynamic> json) {");
  buffer.writeln("    return $className(");
  json.keys.forEach((key) {
    if (json[key] is Map) {
      buffer.writeln("      $key: ${capitalize(key)}.fromJson(json['$key']),");
    } else if (json[key] is List && json[key].isNotEmpty && json[key][0] is Map) {
      buffer.writeln("      $key: (json['$key'] as List).map((e) => ${capitalize(key)}.fromJson(e)).toList(),");
    } else {
      buffer.writeln("      $key: json['$key'],");
    }
  });
  buffer.writeln("    );");
  buffer.writeln("  }");

  // Generate toJson method
  buffer.writeln("  Map<String, dynamic> toJson() {");
  buffer.writeln("    return {");
  json.keys.forEach((key) {
    if (json[key] is Map) {
      buffer.writeln("      '$key': $key.toJson(),");
    } else if (json[key] is List && json[key].isNotEmpty && json[key][0] is Map) {
      buffer.writeln("      '$key': $key.map((e) => e.toJson()).toList(),");
    } else {
      buffer.writeln("      '$key': $key,");
    }
  });
  buffer.writeln("    };\n  }");

  buffer.writeln("}");

  final directory = Directory('lib/generated');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  final outputPath = parentClass.isEmpty ? 'lib/generated/${className.toLowerCase()}.dart' : 'lib/generated/${parentClass.toLowerCase()}_${className.toLowerCase()}.dart';
  final outputFile = File(outputPath);

  // Write imports and class definition to file
  outputFile.writeAsStringSync("${imports.join('\n')}\n\n${buffer.toString()}", mode: FileMode.writeOnly);

  print('Generated Dart class written to $outputPath');

  // Generate nested classes if needed
  json.keys.forEach((key) {
    if (json[key] is Map) {
      generateClassFromJson(json[key], capitalize(key), className);
    } else if (json[key] is List && json[key].isNotEmpty && json[key][0] is Map) {
      generateClassFromJson(json[key][0], capitalize(key), className);
    }
  });
}

String inferType(dynamic value, String key) {
  if (value is int) {
    return 'int';
  } else if (value is double) {
    return 'double';
  } else if (value is bool) {
    return 'bool';
  } else if (value is String) {
    return 'String';
  } else if (value is List) {
    if (value.isNotEmpty && value.first is Map) {
      return 'List<${capitalize(key)}>';
    } else {
      return 'List<${inferType(value.first, key)}>';
    }
  } else if (value is Map) {
    return capitalize(key);
  } else {
    return 'dynamic';
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


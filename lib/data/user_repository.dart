import 'dart:convert';
import 'dart:io';
import '../domain/person.dart';
import '../domain/doctor.dart';
import '../domain/patient.dart';
import '../domain/receptionist.dart';

class UserRepository {
  final String filePath = 'lib/data/user_data.json';

  /// Load all users from JSON and return as a typed list of Person
  List<Person> loadUsers() {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final jsonData = jsonDecode(file.readAsStringSync()) as List;
    return jsonData.map<Person>((u) {
      switch (u['role']) {
        case 'Doctor':
          return Doctor.fromJson(u);
        case 'Patient':
          return Patient.fromJson(u);
        case 'Receptionist':
          return Receptionist.fromJson(u);
        default:
          throw Exception('Unknown role: ${u['role']}');
      }
    }).toList();
  }

  /// Add a new user and persist to JSON
  void addUser(Person user) {
    final file = File(filePath);
    List<dynamic> data = [];

    if (file.existsSync()) {
      data = jsonDecode(file.readAsStringSync());
    }

    data.add(user.toJson());
    file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(data));
  }
}

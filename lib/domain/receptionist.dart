import 'person.dart';

class Receptionist extends Person {
  Receptionist(
    String id,
    String name,
    String email,
    String password,
  ) : super(id, name, email, password, 'Receptionist');

  static Receptionist fromJson(Map<String, dynamic> json) {
    return Receptionist(
      json['id'],
      json['name'],
      json['email'],
      json['password'],
    );
  }
}

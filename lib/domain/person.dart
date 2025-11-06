abstract class Person {
  String _id;
  String _name;
  String _email;
  String _password;
  String _role;

  Person(
    String this._id,
    String this._name,
    String this._email,
    String this._password,
    String this._role,
  );

  //getter
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get role => _role;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'password': _password,
      'role': _role,
    };
  }
}

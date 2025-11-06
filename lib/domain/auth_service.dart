import '../domain/hospital_service.dart';
import 'person.dart';

class AuthService {
  final HospitalService _service;

  AuthService(this._service);

  Person? login(String email, String password) {
    final doctorMatch = _service.doctors.where(
      (d) => d.email == email && d.password == password,
    );
    if (doctorMatch.isNotEmpty) return doctorMatch.first;

    final patientMatch = _service.patients.where(
      (p) => p.email == email && p.password == password,
    );
    if (patientMatch.isNotEmpty) return patientMatch.first;

    final receptionistMatch = _service.receptionists.where(
      (r) => r.email == email && r.password == password,
    );
    if (receptionistMatch.isNotEmpty) return receptionistMatch.first;

    return null;
  }

  // void addUser(Person user) {
  //   _service.addUser(user); // delegate to HospitalService
  // }
}

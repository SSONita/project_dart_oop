import 'dart:convert';
import 'dart:io';
import '../domain/appointment.dart';
import '../domain/doctor.dart';
import '../domain/patient.dart';

class AppointmentRepository {
  final String filePath = 'lib/data/appointment_data.json';

  List<Appointment> loadAppointments(List<Doctor> doctors, List<Patient> patients) {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final jsonData = jsonDecode(file.readAsStringSync()) as List;

    return jsonData.map<Appointment>((a) {
      final doctor = doctors.firstWhere((d) => d.id == a['doctorId']);
      final patient = patients.firstWhere((p) => p.id == a['patientId']);
      return Appointment.fromJson(a, doctor, patient);
    }).toList();
  }

  /// Save all appointments back to JSON
  void saveAppointments(List<Appointment> appointments) {
    final file = File(filePath);
    final data = appointments.map((a) => a.toJson()).toList();
    file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(data));
  }
}

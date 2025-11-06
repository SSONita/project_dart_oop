import 'doctor.dart';
import 'patient.dart';

enum AppointmentStatus { SCHEDULED, COMPLETED, CANCELED }

class Appointment {
  String id;
  DateTime dateTime;
  String reason;
  AppointmentStatus status;
  String? note;
  Doctor doctor;
  Patient patient;

  Appointment({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.dateTime,
    required this.reason,
    this.status = AppointmentStatus.SCHEDULED,
    this.note = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': dateTime.toIso8601String(),
      'reason': reason,
      'status': status.toString().split('.').last,
      'note': note,
      'doctorId': doctor.id,
      'patientId': patient.id,
    };
  }

  static Appointment fromJson(
    Map<String, dynamic> json,
    Doctor doctor,
    Patient patient,
  ) {
    return Appointment(
      id: json['id'],
      patient: patient,
      doctor: doctor,
      dateTime: DateTime.parse(json['date']),
      reason: json['reason'],
      status: AppointmentStatus.values.firstWhere(
        (s) => s.toString().split('.').last == json['status'],
        orElse: () => AppointmentStatus.SCHEDULED,
      ),
      note: json['note'],
    );
  }

  //status
  void markComplete(String newNote) {
    status = AppointmentStatus.COMPLETED;
    note = newNote;
  }

  // cancel
  void cancel() {
    status = AppointmentStatus.CANCELED;
  }
}

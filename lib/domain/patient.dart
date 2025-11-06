import 'appointment.dart';
import 'person.dart';

class Patient extends Person {
  int age;
  String phone;
  List<Appointment> history = [];

  Patient(
    String id,
    String name,
    String email,
    String password,
    int this.age,
    String this.phone,
  ) : super(id, name, email, password, 'Patient');

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['age'] = age;
    base['phone'] = phone;
    return base;
  }

  static Patient fromJson(Map<String, dynamic> json) {
    return Patient(
      json['id'],
      json['name'],
      json['email'],
      json['password'],
      json['age'],
      json['phone'],
    );
  }

  //get the next appointment of the patient
  Appointment? getNextAppointment() {
    final next =
        history
            .where(
              (a) =>
                  a.status == AppointmentStatus.SCHEDULED &&
                  a.dateTime.isAfter(DateTime.now()),
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return next.isNotEmpty ? next.first : null;
  }

  // get the appointment history of the patient
  List<Appointment> getAppointmentHistory() {
    final now = DateTime.now();
    return history
        .where(
          (a) =>
              a.status == AppointmentStatus.COMPLETED ||
              a.status == AppointmentStatus.CANCELED ||
              (a.status == AppointmentStatus.SCHEDULED && a.dateTime.isBefore(now))
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}

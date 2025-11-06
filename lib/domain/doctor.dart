import 'appointment.dart';
import 'person.dart';

class Doctor extends Person {
  String specialization;
  List<Appointment> appointments = [];

  Doctor(
    String id,
    String name,
    String email,
    String password,
    String this.specialization,
  ) : super(id, name, email, password, 'Doctor');

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['specialization'] = specialization;
    return base;
  }

  static Doctor fromJson(Map<String, dynamic> json) {
    return Doctor(
      json['id'],
      json['name'],
      json['email'],
      json['password'],
      json['specialization'],
    );
  }

  //check availability
  bool isAvailable(DateTime dateTime) {
    for (var appointment in appointments) {
      if (appointment.dateTime.isAtSameMomentAs(dateTime)) {
        return false;
      }
    }
    return true;
  }

  // get the doctor next appointment
  Appointment? getNextAppointment() {
    final next =
        appointments
            .where(
              (a) =>
                  a.status == AppointmentStatus.SCHEDULED &&
                  a.dateTime.isAfter(DateTime.now()),
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return next.isNotEmpty ? next.first : null;
  }

  List<Appointment> getAppointmentHistory() {
    final now = DateTime.now();
    return appointments
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

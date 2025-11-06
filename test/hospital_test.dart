import 'package:test/test.dart';
import '../lib/domain/hospital_service.dart';
import '../lib/domain/doctor.dart';
import '../lib/domain/patient.dart';
import '../lib/domain/appointment.dart';
import '../lib/domain/auth_service.dart';

void main() {
  group('AuthService', () {
    late HospitalService service;
    late AuthService auth;
    late Doctor doctor;
    late Patient patient;

    setUp(() {
      service = HospitalService();
      auth = AuthService(service);
      doctor = Doctor(
          'D001', 'Dr. Nita', 'nita@gmail.com', 'nita1234', 'Cardiology');
      patient =
          Patient('P001', 'Liza', 'liza@gmail.com', 'liza1234', 30, '123456');
      service.addDoctor(doctor);
      service.addPatient(patient);
    });

    test('valid doctor login returns Doctor instance', () {
      final user = auth.login('nita@gmail.com', 'nita1234');
      expect(user, isA<Doctor>());
      expect((user as Doctor).name, equals('Dr. Nita'));
    });

    test('valid patient login returns Patient instance', () {
      final user = auth.login('liza@gmail.com', 'liza1234');
      expect(user, isA<Patient>());
      expect((user as Patient).name, equals('Liza'));
    });

    test('invalid login returns null', () {
      final user = auth.login('random@gmail.com', 'random1234');
      expect(user, isNull);
    });
  });

  group('HospitalService', () {
    late HospitalService service;
    late Doctor doctor;
    late Patient patient;

    setUp(() {
      service = HospitalService();
      doctor = Doctor(
          'D001', 'Dr. Nita', 'nita@gmail.com', 'nita1234', 'Cardiology');
      patient =
          Patient('P001', 'Liza', 'liza@gmail.com', 'liza1234', 30, '123456');
      service.addDoctor(doctor);
      service.addPatient(patient);
    });

    test('add doctor with unique ID', () {
      final newDoctor = Doctor(
          'D002', 'Dr. Nika', 'nika@gmail.com', 'nika1234', 'Cardiology');
      service.addDoctor(newDoctor);
      expect(service.doctors.any((d) => d.id == 'D002'), isTrue);
    });

    test('add patient with unique ID', () {
      final newPatient =
          Patient('P002', 'Mey', 'mey@gmail.com', 'mey1234', 20, '123456');
      service.addPatient(newPatient);
      expect(service.patients.any((p) => p.id == 'P002'), isTrue);
    });

    test('schedule valid appointment', () {
      final date = DateTime.now().add(Duration(days: 1, hours: 10));
      service.scheduleAppointment(
        id: 'A007',
        patient: patient,
        doctor: doctor,
        date: date,
        reason: 'Checkup',
      );
      expect(service.appointments.length, equals(7));
      // expect(service.appointments.first.id, equals('A001'));
    });

    test('reject past appointment date', () {
      final date = DateTime.now().subtract(Duration(days: 1));
      expect(
        () => service.scheduleAppointment(
          id: 'A002',
          patient: patient,
          doctor: doctor,
          date: date,
          reason: 'Past test',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('reject duplicate appointment ID', () {
      final date = DateTime.now().add(Duration(days: 1));
      service.scheduleAppointment(
        id: 'A006',
        patient: patient,
        doctor: doctor,
        date: date,
        reason: 'First',
      );
      expect(
        () => service.scheduleAppointment(
          id: 'A006',
          patient: patient,
          doctor: doctor,
          date: date.add(Duration(hours: 1)),
          reason: 'Duplicate',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('cancel appointment', () {
      final date = DateTime.now().add(Duration(days: 1));
      service.scheduleAppointment(
        id: 'A008',
        patient: patient,
        doctor: doctor,
        date: date,
        reason: 'Cancel test',
      );
      service.cancelAppointment('A008');
      final appt =
          service.appointments.firstWhere((a) => a.id == 'A008');
      expect(appt.status, equals(AppointmentStatus.CANCELED));
    });

    test('complete appointment', () {
      final date = DateTime.now().add(Duration(days: 1));
      service.scheduleAppointment(
        id: 'A005',
        patient: patient,
        doctor: doctor,
        date: date,
        reason: 'Complete test',
      );
      service.completAppointment('A005', doctor, 'all good');
      final appt =
          service.appointments.firstWhere((a) => a.id == 'A005');
      expect(appt.status, equals(AppointmentStatus.COMPLETED));
      expect(appt.note, equals('all good'));
    });
  });

  group('Doctor entity', () {
    late Doctor doctor;
    late Patient patient;
    late Appointment appointment;

    setUp(() {
      doctor = Doctor(
          'D001', 'Dr. Nita', 'nita@gmail.com', 'nita1234', 'Cardiology');
      patient =
          Patient('P001', 'Liza', 'liza@gmail.com', 'liza1234', 30, '123456');
      appointment = Appointment(
          id: 'A001',
          patient: patient,
          doctor: doctor,
          dateTime: DateTime.now().add(Duration(days: 1)),
          reason: 'Checkup');
      doctor.appointments.add(appointment);
    });

    test('isAvailable returns false for booked slot', () {
      expect(doctor.isAvailable(appointment.dateTime), isFalse);
    });

    test('isAvailable returns true for free slot', () {
      expect(doctor.isAvailable(appointment.dateTime.add(Duration(hours: 1))),
          isTrue);
    });

    test('getNextAppointment returns nearest future appointment', () {
      final next = doctor.getNextAppointment();
      expect(next, isNotNull);
      expect(next!.id, equals('A001'));
    });

    test('getAppointmentHistory returns completed appointments', () {
      appointment.status = AppointmentStatus.COMPLETED;
      final history = doctor.getAppointmentHistory();
      expect(history.length, equals(1));
      expect(history.first.status, equals(AppointmentStatus.COMPLETED));
    });
  });

  group('Patient entity', () {
    late Doctor doctor;
    late Patient patient;
    late Appointment appointment;

    setUp(() {
      doctor = Doctor(
          'D001', 'Dr. Nita', 'nita@gmail.com', 'nita1234', 'Cardiology');
      patient =
          Patient('P001', 'Liza', 'liza@gmail.com', 'liza1234', 30, '123456');
      appointment = Appointment(
          id: 'A001',
          patient: patient,
          doctor: doctor,
          dateTime: DateTime.now().add(Duration(days: 1)),
          reason: 'Checkup');
      patient.history.add(appointment);
    });

    test('getNextAppointment returns nearest future appointment', () {
      final next = patient.getNextAppointment();
      expect(next, isNotNull);
      expect(next!.id, equals('A001'));
    });

    test('getAppointmentHistory returns completed/cancelled appointments', () {
      appointment.status = AppointmentStatus.CANCELED;
      final history = patient.getAppointmentHistory();
      expect(history.length, equals(1));
      expect(history.first.status, equals(AppointmentStatus.CANCELED));
    });
  });
}

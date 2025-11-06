import 'dart:io';
import '../domain/hospital_service.dart';
import '../domain/doctor.dart';
import '../domain/patient.dart';

class HospitalConsole {
  final HospitalService _service;

  HospitalConsole(this._service);

  void openReceptionistMenu() {
    _clearConsole();
    while (true) {
      _clearConsole();
      print('\n======== Receptionist Menu ========');
      print('1. Add Doctor');
      print('2. Add Patient');
      print('3. Book Appointment');
      print('4. Cancel Appointment');
      print("5. View Doctor's Availability");
      print('0. Logout');

      print('\nEnter your choice:');
      final choice = stdin.readLineSync()!;
      switch (choice) {
        case '1':
          _addDoctor();
          break;
        case '2':
          _addPatient();
          break;
        case '3':
          _bookAppointment();
          break;
        case '4':
          _cancelAppointment();
          break;
        case '5':
          _viewDoctorAvailability();
          break;
        case '0':
          return;
        default:
          print('Invalid choice!');
          break;
      }
    }
  }

  void openDoctorMenu(Doctor doctor) {
    _clearConsole();
    while (true) {
      print('\n======== Doctor Menu ========');
      print('1. View Next Appointment');
      print('2. View Past Appointment');
      print('3. Complete Appointment');
      print('0. Logout');

      print('\nEnter your choice:');
      final choice = stdin.readLineSync()!;
      switch (choice) {
        case '1':
          _viewDoctorNextAppointment(doctor);
          break;
        case '2':
          _viewDoctorPastAppointment(doctor);
          break;
        case '3':
          _completAppointment(doctor);
          break;
        case '0':
          return;
        default:
          print('Invalid choice!');
          break;
      }
    }
  }

  void openPatientMenu(Patient patient) {
    _clearConsole();
    while (true) {
      print('\n======== Patient Menu ========');
      print('1. View Next Appointment');
      print('2. View Appointment History');
      print('0. Logout');

      print('\nEnter your choice:');
      final choice = stdin.readLineSync()!;
      switch (choice) {
        case '1':
          _viewPatientNextAppointment(patient);
          break;
        case '2':
          _viewPatientPastAppointment(patient);
          break;
        case '0':
          return;
        default:
          print('Invalid choice!');
          break;
      }
    }
  }

  void _addDoctor() {
    _clearConsole();
    print('\n-------- Add New Doctor --------');
    print('Enter Doctor Id:');
    String id = stdin.readLineSync()!;
    bool exist = _service.doctors.any((d) => d.id == id);
    if (exist) {
      print('Doctor with ID $id already exists. Please choose a different ID.');
    }

    print('Enter Doctor name:');
    String name = stdin.readLineSync()!;

    print('Enter Doctor email:');
    String email = stdin.readLineSync()!;

    print('Enter Doctor password:');
    String password = stdin.readLineSync()!;

    print('Enter Doctor specialization:');
    String specialization = stdin.readLineSync()!;

    Doctor doctor = Doctor(id, name, email, password, specialization);

    _service.addDoctor(doctor);
  }

  void _addPatient() {
    _clearConsole();
    print('\n-------- Add New Patient --------');
    print('Enter Patient Id:');
    String id = stdin.readLineSync()!;
    bool exist = _service.patients.any((p) => p.id == id);
    if (exist) {
      print(
        'Patient with ID $id already exists. Please choose a different ID.',
      );
    }

    print('Enter Patient name:');
    String name = stdin.readLineSync()!;

    print('Enter Patient email:');
    String email = stdin.readLineSync()!;

    print('Enter Patient password:');
    String password = stdin.readLineSync()!;

    print('Enter Patient age:');
    int age = int.parse(stdin.readLineSync()!);

    print('Enter Patient phone number:');
    String phone = stdin.readLineSync()!;

    Patient patient = Patient(id, name, email, password, age, phone);

    _service.addPatient(patient);
  }

  void _bookAppointment() {
    _clearConsole();
    print('\n-------- Book Appointment --------');

    if (_service.doctors.isEmpty) {
      print('No doctor available.\nPlease add doctor first.');
    }
    if (_service.patients.isEmpty) {
      print('No patient available.\nPlease add patient first.');
    }

    print('\nAvailable Patients: ');
    for (int i = 0; i < _service.patients.length; i++) {
      print('${i + 1}. ${_service.patients[i].name}');
    }

    print('\nSelect Patient(enter number):');
    int p = int.parse(stdin.readLineSync()!) - 1;

    if (p < 0 || p >= _service.patients.length) {
      print('Invalid selection!');
      return;
    }

    Patient selectedPatient = _service.patients[p];

    print('\nAvailable Doctors:');
    for (int i = 0; i < _service.doctors.length; i++) {
      print(
        '${i + 1}. ${_service.doctors[i].name} - ${_service.doctors[i].specialization}',
      );
    }

    print('\nSelect Doctor(enter number):');
    int d = int.parse(stdin.readLineSync()!) - 1;

    if (d < 0 || d >= _service.doctors.length) {
      print('Invalid selection!');
      return;
    }

    Doctor selectedDoctor = _service.doctors[d];

    print('Enter Appointment Date and Time (yyyy-mm-dd hh:mm):');
    String dateInput = stdin.readLineSync()!;
    DateTime appointmentDate;
    try {
      appointmentDate = DateTime.parse(dateInput.replaceAll(' ', 'T'));
      if (appointmentDate.isBefore(DateTime.now())) {
        print(
          'The date $appointmentDate has already passed. Please enter a future date.',
        );
        return;
      }
      ;
    } catch (e) {
      print('Invalid date format. Please use yyyy-mm-dd hh:mm');
      return;
    }

    print('Enter reason for appointment:');
    String reason = stdin.readLineSync()!;

    print('Enter appointment Id:');
    String id = stdin.readLineSync()!;
    bool exist = _service.appointments.any((a) => a.id == id);
    if (exist) {
      print(
        'Appointment with ID $id already exists. Please choose a different ID.',
      );
    }

    _service.scheduleAppointment(
      id: id,
      patient: selectedPatient,
      doctor: selectedDoctor,
      date: appointmentDate,
      reason: reason,
    );
  }

  void _cancelAppointment() {
    _clearConsole();
    print('\n-------- Cancel Appointment --------');
    print('Enter Appointment Id:');
    String id = stdin.readLineSync()!;

    _service.cancelAppointment(id);
  }

  void _viewDoctorAvailability() {
    _clearConsole();
    print('\n-------- Doctor Availability --------');
    if (_service.doctors.isEmpty) {
      print('No doctor available.\nPlease add doctor first.');
    }

    print('\nAvailable Doctors:');
    for (int i = 0; i < _service.doctors.length; i++) {
      print(
        '- ${i + 1}. ${_service.doctors[i].name} - ${_service.doctors[i].specialization}',
      );
    }

    print('\nSelect Doctor(enter number):');
    int d = int.parse(stdin.readLineSync()!) - 1;

    if (d < 0 || d >= _service.doctors.length) {
      print('Invalid selection!');
      return;
    }

    Doctor selectedDoctor = _service.doctors[d];

    print('Enter date to check availability (yyyy-mm-dd):');
    String dateInput = stdin.readLineSync()!;
    DateTime checkDate = DateTime.parse(dateInput);
    print('Availability for Dr. ${selectedDoctor.name} on ${dateInput}:');
    for (int hour = 9; hour <= 17; hour++) {
      DateTime timeslote = DateTime(
        checkDate.year,
        checkDate.month,
        checkDate.day,
        hour,
      );
      bool isAvailable = selectedDoctor.isAvailable(timeslote);
      print('${hour}:00 - ${isAvailable ? 'Available' : 'Busy'}');
    }
  }

  void _viewDoctorNextAppointment(Doctor doctor) {
    final nextAppointment = doctor.getNextAppointment();
    if (nextAppointment != null) {
      print('\n-------- Next Appointment --------');
      print('Appointment Id: ${nextAppointment.id}');
      print('Patient: ${nextAppointment.patient.name}');
      print('Date: ${nextAppointment.dateTime}');
      print('Reason: ${nextAppointment.reason}');
    } else {
      print('\n*------* No upcoming appointment *------*');
    }
  }

  void _viewDoctorPastAppointment(Doctor doctor) {
    final pastAppointments = doctor.getAppointmentHistory();
    if (pastAppointments.isNotEmpty) {
      print('\n-------- Past Appointments --------');
      for (var appointment in pastAppointments) {
        print(
          '- Patient: ${appointment.patient.name} | Date: ${appointment.dateTime} | Reason: ${appointment.reason} | Note: ${appointment.note}',
        );
      }
    } else {
      print('\n*------* No past appointment *------*');
    }
  }

  void _completAppointment(Doctor doctor) {
    print('\n-------- Complete Appointment --------');
    print('Enter Appointment Id:');
    String id = stdin.readLineSync()!;
    print('Enter the additional note:');
    String notes = stdin.readLineSync()!;

    _service.completAppointment(id, doctor, notes);
  }

  void _viewPatientNextAppointment(Patient patient) {
    final nextAppointment = patient.getNextAppointment();
    if (nextAppointment != null) {
      print('\n-------- Next Appointments --------');
      print('Appointment Id: ${nextAppointment.id}');
      print('Doctor: Dr. ${nextAppointment.doctor.name}');
      print('Date: ${nextAppointment.dateTime}');
      print('Reason: ${nextAppointment.reason}');
    } else {
      print('\n*------* No upcoming appointment *------*');
    }
  }

  void _viewPatientPastAppointment(Patient patient) {
    final pastAppointments = patient.getAppointmentHistory();
    if (pastAppointments.isNotEmpty) {
      print('\n-------- Past Appointments --------');
      for (var appointment in pastAppointments) {
        print(
          '- Doctor: Dr. ${appointment.doctor.name} | Date: ${appointment.dateTime} | Reason: ${appointment.reason} | Note: ${appointment.note}',
        );
      }
    } else {
      print('\n*------* No past appointment *------*');
    }
  }

  void _clearConsole() {
    // ANSI escape code to clear screen and move cursor to top-left
    //AI generate
    print('\x1B[2J\x1B[0;0H');
  }
}

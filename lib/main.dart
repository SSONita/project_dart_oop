import 'dart:io';
import 'domain/auth_service.dart';
import 'domain/doctor.dart';
import 'domain/patient.dart';
import 'domain/receptionist.dart';
import 'ui/hospital_console.dart';
import 'domain/hospital_service.dart';

void main() {
  final hospitalService = HospitalService(); 
  final console = HospitalConsole(hospitalService);
  final auth = AuthService(hospitalService);

  print('\x1B[2J\x1B[0;0H'); //AI generate
  print('=== Hospital Management System ===');
  print('Please log in to continue.\n');
  stdout.write('Email: ');
  final email = stdin.readLineSync()!;
  stdout.write('Password: ');
  final password = stdin.readLineSync()!;

  final user = auth.login(email, password);

  if (user == null) {
    print('\nInvalid email or password.');
    exit(0);
  }

  print('\nLogin successful!\nWelcome, ${user.name}.\n');

  if (user is Receptionist) {
    console.openReceptionistMenu();
  } else if (user is Doctor) {
    console.openDoctorMenu(user);
  } else if (user is Patient) {
    console.openPatientMenu(user);
  } else {
    print('Unknown user role.');
  }

  print('\nThank you for using the system.');
}

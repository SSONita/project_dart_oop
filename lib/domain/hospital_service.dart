import 'doctor.dart';
import 'patient.dart';
import 'receptionist.dart';
import 'appointment.dart';
import '../data/user_repository.dart';
import '../data/appointment_repository.dart';

class HospitalService {
  final UserRepository _userRepo = UserRepository();
  final AppointmentRepository _apptRepo = AppointmentRepository();

  late List<Doctor> doctors;
  late List<Patient> patients;
  late List<Receptionist> receptionists;
  late List<Appointment> appointments;

  HospitalService() {
    final users = _userRepo.loadUsers();
    doctors = users.whereType<Doctor>().toList();
    patients = users.whereType<Patient>().toList();
    receptionists = users.whereType<Receptionist>().toList();
    appointments = _apptRepo.loadAppointments(doctors, patients);

    for (var doctor in doctors) {
      doctor.appointments.clear();
    }
    for (var patient in patients) {
      patient.history.clear();
    }
    for (var appt in appointments) {
      appt.doctor.appointments.add(appt);
      appt.patient.history.add(appt);
    }
  }

  //add doctor
  void addDoctor(Doctor doctor) {
    if (doctors.any((d) => d.id == doctor.id)) {
      print('Doctor with ID ${doctor.id} already exists!');
      return;
    }
    doctors.add(doctor);
    _userRepo.addUser(doctor);
  }

  //add patient
  void addPatient(Patient patient) {
    if (patients.any((d) => d.id == patient.id)) {
      print('Patient with ID ${patient.id} already exists!');
      return;
    }

    patients.add(patient);
    _userRepo.addUser(patient);
  }

  // void addUser(Person user) {
  //   if (user is Doctor) {
  //     addDoctor(user);
  //   } else if (user is Patient) {
  //     addPatient(user);
  //   }
  // }

  //schedule an appointment
  void scheduleAppointment({
    required String id,
    required Patient patient,
    required Doctor doctor,
    required DateTime date,
    required String reason,
  }) {
    if (!doctor.isAvailable(date)) {
      throw Exception('Doctor is not available.');
    }

    if (date.isBefore(DateTime.now())) {
      throw Exception('Cannot schedule appointment in the past.');
    }

    final appointment = Appointment(
      id: id,
      patient: patient,
      doctor: doctor,
      dateTime: date,
      reason: reason,
    );

    if (appointments.any((a) => a.id == appointment.id)) {
      throw Exception('Appointment with ID $id already exists!');
    }

    appointments.add(appointment);
    doctor.appointments.add(appointment);
    patient.history.add(appointment);

    _apptRepo.saveAppointments(appointments);
    print('Appointment scheduled sucessfully!');
  }

  // cancel an appointment
  void cancelAppointment(String appointmentId) {
    final appt = appointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw Exception("Appointment not found!"),
    );

    appt.cancel();
    _apptRepo.saveAppointments(appointments);
    print('Appointment canceled.');
  }

  //complete an appointment
  void completAppointment(String appointmentId, Doctor doctor, String notes) {
    final appt = appointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw Exception("Appointment not found!"),
    );

    if (appt.doctor.id != doctor.id) {
      print("You can only complete appointments assigned to you.");
      return;
    }

    if (appt.status != AppointmentStatus.SCHEDULED) {
      print("Only scheduled appointments can be completed.");
      return;
    }

    appt.markComplete(notes);

    _apptRepo.saveAppointments(appointments);
    print('Appointment marked as completed.');
  }

  //get doctor next appointment
  Appointment? getDoctorNextAppointment(Doctor doctor) =>
      doctor.getNextAppointment();

  // get doctor past appointment
  List<Appointment> getDoctorAppointmentHistory(Doctor doctor) =>
      doctor.getAppointmentHistory();

  // get patient next appointment
  Appointment? getPatientNextAppointment(Patient patient) =>
      patient.getNextAppointment();

  // get patient history
  List<Appointment> getPatientAppointmentHistory(Patient patient) =>
      patient.getAppointmentHistory();
}

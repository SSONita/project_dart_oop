# 🏥 Hospital Management System (Dart Console App)

A console-based hospital management system built in **Dart**, designed to demonstrate clean backend architecture, type safety, and maintainable code practices.  
It supports multiple actors (**Receptionist, Doctor, Patient**) and provides flows for appointment scheduling, cancellation, and history management.

---

## ✨ Features

### 👩 Receptionist
- Add new doctors and patients (with duplicate ID checks).
- Book appointments with validation:
  - Rejects past dates.
  - Rejects duplicate appointment IDs.
  - Ensures doctor availability.
- Cancel existing appointments.
- View doctor availability by date.

### 👨 Doctor
- View next upcoming appointment.
- View past appointment history.
- Complete appointments with notes.

### 🧑 Patient
- View next upcoming appointment.
- View appointment history (completed/cancelled/overdue scheduled).

---

## 🛠️ Architecture

- **Domain Layer**  
  - `Doctor`, `Patient`, `Appointment` entities.  
  - Business logic for availability, history, and validation.

- **Service Layer**  
  - `HospitalService`: orchestrates scheduling, cancellation, and persistence.  
  - `AuthService`: handles login and identity resolution.

- **Console Layer**  
  - `HospitalConsole`: interactive menus for Receptionist, Doctor, and Patient.

- **Persistence**  
  - JSON repositories for saving doctors, patients, and appointments.

---

## ✅ Validation Rules

- Appointment date must be in the future.  
- Appointment ID must be unique.  
- Doctor must be available at the requested time.  
- Input format for dates: `yyyy-mm-dd hh:mm`.  

---

## 🧪 Testing

Unit tests are written using the [Dart test package](https://pub.dev/packages/test).



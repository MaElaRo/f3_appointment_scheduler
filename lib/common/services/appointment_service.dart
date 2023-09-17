import 'package:f3_appointment_scheduler/common/model/appointment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class AppointmentService {
  final Uuid uuid;
  final DatabaseReference _appointmentsRef =
  FirebaseDatabase.instance.ref('myAppointments');

  AppointmentService({required this.uuid});

  Future<String> bookAppointment(Appointment appointment) async {
    final code = uuid.v4();

    _appointmentsRef.child(code).set({
      'date': appointment.timeSlot.toIso8601String(),
      'userId': code,
    });

    return code;
  }

  Future<void> removeAppointment(String code) async {
    await _appointmentsRef.child(code).remove();
  }

  Future<bool> checkIfAvailable(Appointment appointment) async {
    final snapshot = await _appointmentsRef.orderByChild('date').once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

    var available = true;

    data.forEach((key, dataval) {
      if (dataval is Map) {
        dataval.forEach((datapointKey, datapoint) {
          if (appointment.timeSlot.toIso8601String() == datapoint) {
            available = false;
          }
        });
      }
    });

    return available;
  }
}

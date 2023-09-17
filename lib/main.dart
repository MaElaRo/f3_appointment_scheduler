import 'package:f3_appointment_scheduler/features/appointement_scheduler/pages/appointment_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppointmentPage(),
    ),
  );
}

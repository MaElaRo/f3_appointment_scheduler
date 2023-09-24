import 'package:f3_appointment_scheduler/features/appointement_scheduler/pages/appointment_page.dart';
import 'package:f3_appointment_scheduler/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppointmentPage(),
    ),
  );
}

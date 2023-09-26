import 'package:f3_appointment_scheduler/common/services/appointment_service.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/cubit/appointement_cubit.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/cubit/appointement_state.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/widgets/date_and_time_picker.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/widgets/remove_appointment_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  AppointmentPageState createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Scheduler'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocProvider(
            create: (context) => AppointmentCubit(
                appointmentService: AppointmentService(uuid: const Uuid())),
            child: BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (context, state) {
                return Column(
                  children: const [
                    DateAndTimePicker(),
                    SizedBox(height: 20),
                    RemoveAppointmentForm(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

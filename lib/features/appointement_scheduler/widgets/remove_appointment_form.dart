import 'package:f3_appointment_scheduler/features/appointement_scheduler/cubit/appointement_cubit.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/cubit/appointement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoveAppointmentForm extends StatefulWidget {
  const RemoveAppointmentForm({Key? key}) : super(key: key);

  @override
  State<RemoveAppointmentForm> createState() => _RemoveAppointmentFormState();
}

class _RemoveAppointmentFormState extends State<RemoveAppointmentForm> {
  final codeController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the text field and update the button state
    codeController.addListener(() {
      setState(() {
        isButtonEnabled = codeController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: codeController,
            decoration: const InputDecoration(
              labelText: 'Code:',
              hintText: 'Enter code',
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
              final code = codeController.text;
              context.read<AppointmentCubit>().removeAppointment(code);
            }
                : null, // Set onPressed to null when the button should be disabled
            child: const Text('Remove slot!'),
          ),
          BlocListener<AppointmentCubit, AppointmentState>(
            listener: (blocContext, state) {
              if (state is AppointmentRemovingSuccess) {
                SchedulerBinding.instance.addPostFrameCallback(
                      (_) {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Appointment was removed'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                codeController.clear();
                                blocContext
                                    .read<AppointmentCubit>()
                                    .resetState();
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }
            },
            child: BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (blocContext, state) {
                if (state is AppointmentRemovingFailure) {
                  return const Text('Appointment removal failed');
                } else if (state is AppointmentRemovingInProgress) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

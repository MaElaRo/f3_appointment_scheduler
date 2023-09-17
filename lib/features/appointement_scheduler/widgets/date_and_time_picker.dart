import 'package:f3_appointment_scheduler/common/model/appointment.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/cubit/appointement_cubit.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/cubit/appointement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateAndTimePicker extends StatefulWidget {
  const DateAndTimePicker({Key? key}) : super(key: key);

  @override
  State<DateAndTimePicker> createState() => _DateAndTimePickerState();
}

class _DateAndTimePickerState extends State<DateAndTimePicker> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String phoneNumber = '';

  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneNumberFilled = phoneNumber.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Choose your slot:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          controller: _dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Select Date',
            suffixIcon: InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: const Icon(Icons.calendar_today),
            ),
          ),
        ),
        TextField(
          controller: _timeController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Select Time',
            suffixIcon: InkWell(
              onTap: () {
                _selectTime(context);
              },
              child: const Icon(Icons.access_time),
            ),
          ),
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Your phone number:',
          ),
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          textInputAction: TextInputAction.done,
          controller: _phoneController,
          onChanged: (value) {
            setState(() {
              phoneNumber = value; // Store the entered phone number
            });
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: isPhoneNumberFilled
              ? () {
            context.read<AppointmentCubit>().bookAppointment(
              Appointment(
                timeSlot: _mergeDateTimeAndTimeOfDay(
                  selectedDate,
                  selectedTime,
                ),
              ),
            );
          }
              : null,
          child: const Text('Book slot!'),
        ),
        BlocListener<AppointmentCubit, AppointmentState>(
          listener: (blocContext, state) {
            if (state is AppointmentBookingSuccess) {
              SchedulerBinding.instance.addPostFrameCallback(
                    (_) {
                  showDialog<AlertDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: Text('Appointment booked: ${state.code}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _timeController.clear();
                              _dateController.clear();
                              _phoneController.clear();
                              blocContext.read<AppointmentCubit>().resetState();
                              Navigator.of(context).pop();
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
              if (state is AppointmentBookingInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AppointmentBookingFailure) {
                return Text(state.error);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      final minute = picked.minute;
      final roundedMinute = (minute / 5).round() * 5;
      setState(() {
        selectedTime = TimeOfDay(hour: picked.hour, minute: roundedMinute);
        _timeController.text = selectedTime.format(context);
      });
    }
  }

  DateTime _mergeDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

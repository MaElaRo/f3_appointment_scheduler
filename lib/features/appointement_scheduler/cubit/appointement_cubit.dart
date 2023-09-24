import 'package:f3_appointment_scheduler/common/model/appointment.dart';
import 'package:f3_appointment_scheduler/common/services/appointment_service.dart';
import 'package:f3_appointment_scheduler/features/appointement_scheduler/cubit/appointement_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit({
    required AppointmentService appointmentService,
  })  : _appointmentService = appointmentService,
        super(AppointmentInitialLoading());

  final AppointmentService _appointmentService;

  ///
  Future<void> bookAppointment(Appointment appointment) async {
    emit(AppointmentBookingInProgress());

    try {
      if(await _appointmentService.isAvailable(appointment)){
        final code = await _appointmentService.bookAppointment(appointment);
        emit(AppointmentBookingSuccess(code));
      } else {
        emit(
          AppointmentBookingFailure(
            'Slot was already taken. Please choose another slot',
          ),
        );
      }
    } catch (error) {
      emit(AppointmentBookingFailure('Booking appointment failed.'));
    }
  }

  ///
  Future<void> removeAppointment(String code) async {
    emit(AppointmentRemovingInProgress());

    try {
      await _appointmentService.removeAppointment(code);
      emit(AppointmentRemovingSuccess());
    } catch (error) {
      emit(AppointmentRemovingFailure('Removing appointment failed.'));
    }
  }

  void resetState() {
    emit(AppointmentInitialLoading());
  }
}

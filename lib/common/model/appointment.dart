import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final DateTime timeSlot;

  const Appointment({
    required this.timeSlot,
  });

  @override
  List<Object?> get props => [timeSlot];
}

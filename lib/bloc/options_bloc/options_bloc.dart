import 'package:flutter_bloc/flutter_bloc.dart';
import 'options_event.dart';
import 'options_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  DeliveryBloc() : super(DeliveryState(selectedOption: 'Entrée')) {
    on<SelectDeliveryOption>((event, emit) {
      emit(state.copyWith(selectedOption: event.option));
    });
  }
}

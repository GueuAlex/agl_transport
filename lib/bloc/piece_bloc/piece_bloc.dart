import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner/bloc/piece_bloc/piece_event.dart';
import 'package:scanner/bloc/piece_bloc/piece_state.dart';

class PieceBloc extends Bloc<PieceEvent, PieceState> {
  PieceBloc() : super(PieceState(selectedOption: 'Entrée')) {
    on<SelectPieceOption>((event, emit) {
      emit(state.copyWith(selectedOption: event.option));
    });
  }
}

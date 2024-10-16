// states.dart
class PieceState {
  final String selectedOption;

  PieceState({required this.selectedOption});

  PieceState copyWith({String? selectedOption}) {
    return PieceState(
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }
}

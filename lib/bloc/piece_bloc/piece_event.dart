// events.dart
abstract class PieceEvent {}

class SelectPieceOption extends PieceEvent {
  final String option;

  SelectPieceOption(this.option);
}

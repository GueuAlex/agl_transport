// states.dart
class DeliveryState {
  final String selectedOption;

  DeliveryState({required this.selectedOption});

  DeliveryState copyWith({String? selectedOption}) {
    return DeliveryState(
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }
}

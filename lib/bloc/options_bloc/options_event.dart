// events.dart
abstract class DeliveryEvent {}

class SelectDeliveryOption extends DeliveryEvent {
  final String option;

  SelectDeliveryOption(this.option);
}

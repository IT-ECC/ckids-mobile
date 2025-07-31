part of 'payment_cubit.dart';

class PaymentState extends Equatable {
  late final List<FamilySelected> listFamilySelected;
  late final String eventId;
  late final double amount;
  late final bool isLoading;

  PaymentState({
    this.listFamilySelected = const [],
    this.eventId = '',
    this.amount = 0,
    this.isLoading = false
  });

  PaymentState copyWith({
    List<FamilySelected>? listFamilySelected,
    String? eventId,
    double? amount,
    bool? isLoading
  }) {
    return PaymentState(
      listFamilySelected: listFamilySelected ?? this.listFamilySelected,
      eventId: eventId ?? this.eventId,
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading
    );
  }

  List<FamilySelected> get familyUnselected => listFamilySelected.where((element) => element.selected == false).toList();
  List<FamilySelected> get familySelected => listFamilySelected.where((element) => element.selected == true).toList();
  double get calculateAmount => familySelected.length * amount;
  String get priceEvent => (amount != 0.0) ? Format.money(calculateAmount) : "FREE";
  String get calculateAmountEvent => (amount != 0.0) ? "${familySelected.length.toString()} x ${Format.money(amount)}" : "${familySelected.length.toString()} x FREE";

  @override
  List<Object?> get props => [
    listFamilySelected,
    eventId,
    amount,
    isLoading
  ];
}

class PaymentStateError extends PaymentState {
  final String message;

  PaymentStateError(this.message);
}

class PaymentStateJoinEvent extends PaymentState {
  final String message;
  final String? snapToken;
  final String? url;
  final String familyParticipant;
  final double calculateAmount;

  PaymentStateJoinEvent({
    required this.message,
    this.snapToken,
    this.url,
    required this.familyParticipant,
    required this.calculateAmount,
  });
}
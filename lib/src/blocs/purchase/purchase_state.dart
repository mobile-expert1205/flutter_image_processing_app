part of 'purchase_bloc.dart';

enum PurchaseUserMessage { none, purchaseError, purchaseSuccess }

enum PurchaseStage { none, inProgress }

abstract class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class PurchaseInitial extends PurchaseState {}

class PurchaseInitFailure extends PurchaseState {
  final Object error;

  const PurchaseInitFailure(this.error);
}

class PurchaseGetOfferingsFailure extends PurchaseState {
  final Object error;

  const PurchaseGetOfferingsFailure(this.error);
}

class PurchaseGetOfferingsSuccess extends PurchaseState
    implements InProgressState {
  final Offering offering;
  final PurchaseUserMessage userMessage;
  final bool isSubscriptionActive;
  final Map<String, ProductRelativePrice> productsRelativePrice;
  final PurchaseStage stage;

  const PurchaseGetOfferingsSuccess({
    required this.offering,
    PurchaseUserMessage? userMessage,
    bool? isSubscriptionActive,
    Map<String, ProductRelativePrice>? productsRelativePrice,
    PurchaseStage? stage,
  })  : userMessage = userMessage ?? PurchaseUserMessage.none,
        isSubscriptionActive = isSubscriptionActive ?? false,
        productsRelativePrice = productsRelativePrice ?? const {},
        stage = stage ?? PurchaseStage.none;

  PurchaseGetOfferingsSuccess copyWith({
    Offering? offering,
    PurchaseUserMessage? userMessage,
    bool? isSubscriptionActive,
    Map<String, ProductRelativePrice>? productsRelativePrice,
    PurchaseStage? stage,
  }) =>
      PurchaseGetOfferingsSuccess(
        offering: offering ?? this.offering,
        userMessage: userMessage ?? this.userMessage,
        isSubscriptionActive: isSubscriptionActive ?? this.isSubscriptionActive,
        productsRelativePrice:
            productsRelativePrice ?? this.productsRelativePrice,
        stage: stage ?? this.stage,
      );

  @override
  List<Object?> get props => [
        offering,
        userMessage,
        isSubscriptionActive,
        productsRelativePrice,
        stage,
      ];

  @override
  bool get inProgress => stage == PurchaseStage.inProgress;
}

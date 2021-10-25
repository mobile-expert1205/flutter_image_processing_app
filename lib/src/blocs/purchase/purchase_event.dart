part of 'purchase_bloc.dart';

abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class PurchaseInitEvent extends PurchaseEvent {
  const PurchaseInitEvent();
}

class PurchaseGetOfferingsEvent extends PurchaseEvent {
  const PurchaseGetOfferingsEvent();
}

class PurchaseGetPurchaseInfoEvent extends PurchaseEvent {
  const PurchaseGetPurchaseInfoEvent();
}

class PurchasePurchasePackageEvent extends PurchaseEvent {
  final Package packageToPurchase;

  const PurchasePurchasePackageEvent(this.packageToPurchase);
}

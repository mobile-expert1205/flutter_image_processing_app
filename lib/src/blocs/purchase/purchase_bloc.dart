import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_secrets.dart';
import 'package:wordfinderx/src/models/product_relative_price.dart';
import 'package:wordfinderx/src/widgets/overlay_progress_indicator.dart';

part 'purchase_event.dart';

part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  static const String _entitlementIdentifier = 'premium';
  final PurchaseSecrets _purchaseSecrets;

  PurchaseBloc(PurchaseSecrets purchaseSecrets)
      : _purchaseSecrets = purchaseSecrets,
        super(PurchaseInitial());

  @override
  Stream<PurchaseState> mapEventToState(
    PurchaseEvent event,
  ) async* {
    if (event is PurchaseInitEvent) {
      yield* _mapPurchaseInitEvent(event);
    } else if (event is PurchaseGetOfferingsEvent) {
      yield* _mapPurchaseGetOfferingsEvent(event);
    } else if (event is PurchasePurchasePackageEvent) {
      yield* _mapPurchasePurchasePackageEvent(event);
    } else if (event is PurchaseGetPurchaseInfoEvent) {
      yield* _mapPurchaseGetPurchaseInfoEvent(event);
    }
  }

  Stream<PurchaseState> _mapPurchaseInitEvent(PurchaseInitEvent event) async* {
    try {
      if (kDebugMode) {
        await Purchases.setDebugLogsEnabled(true);
      }
      await Purchases.setup(_purchaseSecrets.purchaseApiKey);
      add(PurchaseGetOfferingsEvent());
    } catch (error, stackTrace) {
      yield PurchaseInitFailure(error);
      addError(error, stackTrace);
    }
  }

  Stream<PurchaseState> _mapPurchaseGetOfferingsEvent(
      PurchaseGetOfferingsEvent event) async* {
    try {
      Offerings offerings = await Purchases.getOfferings();
      assert(offerings.current != null);
      yield PurchaseGetOfferingsSuccess(
        offering: offerings.current!,
        productsRelativePrice: getProductsRelativePrice(offerings.current!),
      );
      add(PurchaseGetPurchaseInfoEvent());
      // Offering offering = Offering.fromJson(jsonDecode(_json));
      // yield PurchaseGetOfferingsSuccess(
      //   offering: offering,
      //   productsRelativePrice: getProductsRelativePrice(offering),
      // );
    } catch (error, stackTrace) {
      yield PurchaseGetOfferingsFailure(error);
      addError(error, stackTrace);
    }
  }

  static Map<String, ProductRelativePrice> getProductsRelativePrice(
    Offering offering,
  ) {
    final Map<String, ProductRelativePrice> relativePriceMap = {};
    final List<Package> packages = offering.availablePackages;
    if (packages.isNotEmpty) {
      final Map<double, Product> productsMap = {};
      packages.forEach((Package package) {
        productsMap[package.lengthInMonths] = package.product;
      });
      final List<double> sortedKeys = productsMap.keys.toList()
        ..sort((a, b) => a > b ? 1 : -1);
      final double baseLength = sortedKeys.first;
      final double basePrice = productsMap[baseLength]!.price;
      final double basePricePerMonth = basePrice / baseLength;
      sortedKeys.forEach((double length) {
        final Product product = productsMap[length]!;

        final double pricePerMonth = product.price / length;
        final int discountPercent =
            ((1 - (pricePerMonth / basePricePerMonth)) * 100).toInt();

        relativePriceMap[product.identifier] = ProductRelativePrice(
          pricePerMonth: pricePerMonth,
          discountPercent: discountPercent > 0 ? discountPercent : 0,
        );
      });
    }
    return relativePriceMap;
  }

  Stream<PurchaseState> _mapPurchasePurchasePackageEvent(
      PurchasePurchasePackageEvent event) async* {
    final PurchaseState curState = state;
    if (curState is PurchaseGetOfferingsSuccess) {
      // yield curState.copyWith(
      //   stage: PurchaseStage.inProgress,
      //   userMessage: PurchaseUserMessage.none,
      // );
      // await Future.delayed(Duration(seconds: 5));
      // yield curState.copyWith(
      //   userMessage: PurchaseUserMessage.purchaseSuccess,
      //   isSubscriptionActive: true,
      //   stage: PurchaseStage.none,
      // );

      yield curState.copyWith(stage: PurchaseStage.inProgress);
      try {
        final PurchaserInfo purchaserInfo =
            await Purchases.purchasePackage(event.packageToPurchase);
        if (purchaserInfo.entitlements.all[_entitlementIdentifier]?.isActive ??
            false) {
          yield curState.copyWith(
            userMessage: PurchaseUserMessage.purchaseSuccess,
            isSubscriptionActive: true,
            stage: PurchaseStage.none,
          );
        } else {
          yield curState.copyWith(
            userMessage: PurchaseUserMessage.purchaseError,
            isSubscriptionActive: false,
            stage: PurchaseStage.none,
          );
        }
      } on PlatformException catch (error, stackTrace) {
        final PurchasesErrorCode errorCode =
            PurchasesErrorHelper.getErrorCode(error);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError &&
            errorCode != PurchasesErrorCode.productAlreadyPurchasedError) {
          yield curState.copyWith(
            userMessage: PurchaseUserMessage.purchaseError,
            stage: PurchaseStage.none,
          );
          addError(error, stackTrace);
        } else {
          yield curState.copyWith(
            userMessage: PurchaseUserMessage.none,
            stage: PurchaseStage.none,
          );
        }
      }
    }
  }

  Stream<PurchaseState> _mapPurchaseGetPurchaseInfoEvent(
      PurchaseGetPurchaseInfoEvent event) async* {
    final PurchaseState curState = state;
    if (curState is PurchaseGetOfferingsSuccess) {
      try {
        final PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
        yield curState.copyWith(
          isSubscriptionActive: purchaserInfo
                  .entitlements.all[_entitlementIdentifier]?.isActive ??
              false,
        );
      } on PlatformException catch (error, stackTrace) {
        addError(error, stackTrace);
      }
    }
  }
}

extension PackageTypeLength on Package {
  double get lengthInMonths {
    switch (packageType) {
      case PackageType.monthly:
        return 1;
      case PackageType.twoMonth:
        return 2;
      case PackageType.threeMonth:
        return 3;
      case PackageType.sixMonth:
        return 6;
      case PackageType.annual:
        return 12;
      case PackageType.lifetime:
        return 1;
      case PackageType.weekly:
        return 0.25;
      case PackageType.unknown:
        return 1;
      case PackageType.custom:
        return 1;
    }
  }
}

const String _json = '''
{
"identifier" : "someId",
"serverDescription" : "some description",
"availablePackages" : [
    {
    "identifier" : "pkgId1",
    "packageType" : "MONTHLY",
    "offeringIdentifier" : "someId",
    "product" : {
                  "identifier" : "productId1",
                  "description" : "Description",
                  "title" : "Title",
                  "price" : 1.99,
                  "price_string" : "\$1.99",
                  "currency_code" : "USD"
                }
    },
    {
    "identifier" : "pkgId2",
    "packageType" : "ANNUAL",
    "offeringIdentifier" : "someId2",
    "product" : {
                  "identifier" : "productId2",
                  "description" : "Description2",
                  "title" : "Title2",
                  "price" : 17.99,
                  "price_string" : "\$17.99",
                  "currency_code" : "USD"
                }
    }
  ]
}
''';

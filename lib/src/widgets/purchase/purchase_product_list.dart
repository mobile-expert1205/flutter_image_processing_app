import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/package_wrapper.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_bloc.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/product_relative_price.dart';
import 'package:wordfinderx/src/widgets/ink_well_stack.dart';
import 'package:wordfinderx/src/widgets/overlay_progress_indicator.dart';

import '../common.dart';
import '../dialog_close_button.dart';

class PurchaseProductList extends StatelessWidget {
  static const double _productCardWidth = 120;
  static const double _productCardHeight = 140;

  static void showPurchaseDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return OverlayProgressIndicator<PurchaseBloc, PurchaseState>(
            child: Container(
              child: Center(
                child: Card(
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PurchaseProductList(),
                  ),
                ),
              ),
            ),
          );
        });
  }

  const PurchaseProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseBloc, PurchaseState>(
      listener: _blocListener,
      listenWhen: _listenWhen,
      builder: (context, state) {
        Widget body = Container();
        if (state is PurchaseInitial) {
          body = _buildProgressIndicator();
        } else if (state is PurchaseInitFailure ||
            state is PurchaseGetOfferingsFailure) {
          body = _buildFailureMessage();
        } else if (state is PurchaseGetOfferingsSuccess) {
          body = _buildList(context, state);
        }

        return Stack(
          children: [
            body,
            Positioned(
              top: 0,
              right: 0,
              child: DialogCloseButton(
                padding: EdgeInsets.all(4.0),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildFailureMessage() {
    return _buildTextMessage(LocaleKeys.purchaseInitFailure.tr());
  }

  Widget _buildTextMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 60),
      child: Text(
        message,
        style: AppStyles.noWordsFound,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(BuildContext context, PurchaseGetOfferingsSuccess state) {
    if (state.offering.availablePackages.isEmpty) {
      return _buildTextMessage(LocaleKeys.noProducts.tr());
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 60),
        Text(
          LocaleKeys.removeAllAdvert.tr(),
          style: AppStyles.purchaseScreenTitle,
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          children: _buildItems(context, state),
        ),
      ],
    );
  }

  List<Widget> _buildItems(
      BuildContext context, PurchaseGetOfferingsSuccess state) {
    final List<Widget> items = [];

    state.offering.availablePackages.forEach((Package package) {
      try {
        final ProductRelativePrice productRelativePrice =
            state.productsRelativePrice[package.product.identifier]!;
        items.add(_buildItem(context, package, productRelativePrice));
      } catch (error, stackTrace) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      }
    });

    return items;
  }

  Widget _buildItem(
    BuildContext context,
    Package package,
    ProductRelativePrice relativePrice,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWellStack(
        onTap: () => BlocProvider.of<PurchaseBloc>(context)
            .add(PurchasePurchasePackageEvent(package)),
        child: Stack(
          children: [
            _buildProduct(package, relativePrice),
            if (relativePrice.discountPercent > 0)
              _buildDiscount(relativePrice),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscount(ProductRelativePrice relativePrice) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.usedFilterCountBg,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${LocaleKeys.save.tr()} '
                '${relativePrice.discountPercent}%',
                style: AppStyles.purchaseDiscount,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProduct(
    Package package,
    ProductRelativePrice relativePrice,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPeriod(package),
              _buildPrice(package, relativePrice),
            ],
          )),
    );
  }

  Widget _buildPeriod(Package package) {
    return Container(
      width: _productCardWidth,
      height: _productCardHeight / 2,
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${package.periodString}',
            style: AppStyles.purchasePeriod,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildPrice(Package package, ProductRelativePrice relativePrice) {
    final String currencySymbol =
        package.product.priceString.replaceAll(RegExp(r'\s|\d|\.|\,'), '');
    final NumberFormat numberFormat = NumberFormat.currency(
      decimalDigits: 2,
      symbol: currencySymbol,
    );
    final String pricePerMonth =
        numberFormat.format(relativePrice.pricePerMonth);

    return Container(
      width: _productCardWidth,
      height: _productCardHeight / 2,
      child: Center(
        child: FittedBox(
          child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(children: [
              TextSpan(
                text: '${package.product.priceString}\n',
                style: AppStyles.purchasePriceText,
              ),
              TextSpan(
                text: '$pricePerMonth'
                    '${LocaleKeys.perMonth.tr()}',
                style: AppStyles.purchasePricePerMonthText,
              )
            ]),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, PurchaseState state) {
    if (state is PurchaseGetOfferingsSuccess) {
      final String text = state.userMessage.text;
      if (text.isNotEmpty) {
        showTextOnSnackBar(context: context, text: text);
        Navigator.of(context).pop();
      }
    }
  }

  bool _listenWhen(PurchaseState previous, PurchaseState current) =>
      (previous is PurchaseGetOfferingsSuccess &&
          current is PurchaseGetOfferingsSuccess &&
          previous.userMessage != current.userMessage) ||
      (previous is! PurchaseGetOfferingsSuccess &&
          current is PurchaseGetOfferingsSuccess);
}

extension PackageTypeLength on Package {
  String get periodString {
    switch (packageType) {
      case PackageType.monthly:
        return '1\n${LocaleKeys.month.tr()}';
      case PackageType.twoMonth:
        return '2\n${LocaleKeys.months.tr()}';
      case PackageType.threeMonth:
        return '3\n${LocaleKeys.months.tr()}';
      case PackageType.sixMonth:
        return '6\n${LocaleKeys.months.tr()}';
      case PackageType.annual:
        return '1\n${LocaleKeys.year.tr()}';
      case PackageType.lifetime:
        return '';
      case PackageType.weekly:
        return '1\n${LocaleKeys.week.tr()}';
      case PackageType.unknown:
        return '';
      case PackageType.custom:
        return '';
    }
  }
}

extension PurchaseUserMessageText on PurchaseUserMessage {
  String get text {
    switch (this) {
      case PurchaseUserMessage.none:
        return '';
      case PurchaseUserMessage.purchaseSuccess:
        return LocaleKeys.purchaseSuccess.tr();
      case PurchaseUserMessage.purchaseError:
        return LocaleKeys.purchaseError.tr();
    }
  }
}

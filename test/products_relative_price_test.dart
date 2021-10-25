import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_bloc.dart';
import 'package:wordfinderx/src/models/product_relative_price.dart';

void main() {
  test('Products relative price test#1', () {
    final Offering offering = Offering.fromJson(jsonDecode(_offeringJson1));
    final Map<String, ProductRelativePrice> productsRelativePrice =
        PurchaseBloc.getProductsRelativePrice(offering);
    expect(productsRelativePrice.length, 2);
    expect(productsRelativePrice['productId1']!.discountPercent, 0);
    expect(productsRelativePrice['productId1']!.pricePerMonth.toStringAsFixed(2), '11.96');
    expect(productsRelativePrice['productId2']!.discountPercent, 84);
    expect(productsRelativePrice['productId2']!.pricePerMonth.toStringAsFixed(2), '1.83');
  });

  test('Products relative price test#2', () {
    final Offering offering = Offering.fromJson(jsonDecode(_offeringJson2));
    final Map<String, ProductRelativePrice> productsRelativePrice =
    PurchaseBloc.getProductsRelativePrice(offering);
    expect(productsRelativePrice.length, 2);
    expect(productsRelativePrice['productId1']!.discountPercent, 0);
    expect(productsRelativePrice['productId1']!.pricePerMonth.toStringAsFixed(2), '3.99');
    expect(productsRelativePrice['productId2']!.discountPercent, 38);
    expect(productsRelativePrice['productId2']!.pricePerMonth.toStringAsFixed(2), '2.46');
  });
}

const String _offeringJson1 = '''
{
"identifier" : "someId",
"serverDescription" : "some description",
"availablePackages" : [
    {
    "identifier" : "pkgId1",
    "packageType" : "WEEKLY",
    "offeringIdentifier" : "someId",
    "product" : {
                  "identifier" : "productId1",
                  "description" : "Description",
                  "title" : "Title",
                  "price" : 2.99,
                  "price_string" : "\$2.99",
                  "currency_code" : "USD"
                }
    },
    {
    "identifier" : "pkgId2",
    "packageType" : "SIX_MONTH",
    "offeringIdentifier" : "someId2",
    "product" : {
                  "identifier" : "productId2",
                  "description" : "Description2",
                  "title" : "Title2",
                  "price" : 10.99,
                  "price_string" : "\$10.99",
                  "currency_code" : "USD"
                }
    }
  ]
}
''';


const String _offeringJson2 = '''
{
"identifier" : "someId",
"serverDescription" : "some description",
"availablePackages" : [
    {
    "identifier" : "pkgId2",
    "packageType" : "ANNUAL",
    "offeringIdentifier" : "someId2",
    "product" : {
                  "identifier" : "productId2",
                  "description" : "Description2",
                  "title" : "Title2",
                  "price" : 29.49,
                  "price_string" : "\$29.49",
                  "currency_code" : "USD"
                }
    },
    {
    "identifier" : "pkgId1",
    "packageType" : "MONTHLY",
    "offeringIdentifier" : "someId",
    "product" : {
                  "identifier" : "productId1",
                  "description" : "Description",
                  "title" : "Title",
                  "price" : 3.99,
                  "price_string" : "\$3.99",
                  "currency_code" : "USD"
                }
    }
  ]
}
''';

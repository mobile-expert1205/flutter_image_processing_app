class ProductRelativePrice {
  final double pricePerMonth;
  final int discountPercent;

  ProductRelativePrice({
    required this.pricePerMonth,
    required this.discountPercent,
  });

  @override
  String toString() {
    return 'ProductRelativePrice{pricePerMonth: $pricePerMonth, discountPercent: $discountPercent}';
  }
}

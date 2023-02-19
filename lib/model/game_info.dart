class GameInfo {
  final String name;
  final int price;
  final int discountPct;

  GameInfo(
      {required this.name, required this.price, required this.discountPct});

  String getPrice() {
    return '${(price.toDouble() / 100).toString()}₴';
  }

  String getDiscountPct() {
    return '$discountPct%';
  }
}

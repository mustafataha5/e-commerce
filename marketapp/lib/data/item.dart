class Item {
  String itemId;
  String imageUrl;
  String name;
  int limit;
  int availableNum;
  int price;
  String nameAr;
  int _quantity;

  Item(
      {required this.itemId,
      required this.imageUrl,
      required this.name,
      required this.nameAr,
      required this.limit,
      required this.price,
      required this.availableNum,
      int quantity = 1})
      : _quantity = quantity;

  // Getter
  int get quantity => _quantity;

  // Setter
  set quantity(int quantity) {
    _quantity = quantity;
  }
}

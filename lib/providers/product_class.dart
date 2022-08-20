class Product {
  String name;
  double price;
  int qty = 1;
  int qntty;
  List imagesUrl;
  String documentId;
  String suppId;
  Product(
      {required this.name,
      required this.price,
      required this.qntty,
      required this.imagesUrl,
      required this.documentId,
      required this.suppId,
      required this.qty});

  void incrementQuantity() {
    qty++;
  }

  void decrementQuantity() {
    qty--;
  }
}

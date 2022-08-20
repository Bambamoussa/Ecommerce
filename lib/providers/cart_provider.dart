import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/product_class.dart';

class Cart with ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems => _list;
  int? get count => _list.length;
  void addItem(
    String name,
    double price,
    int qty,
    int qntty,
    List imagesUrl,
    String documentId,
    String suppId,
  ) {
    final product = Product(
      name: name,
      price: price,
      qty: qty,
      qntty: qntty,
      imagesUrl: imagesUrl,
      documentId: documentId,
      suppId: suppId,
    );
    _list.add(product);
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    product.incrementQuantity();
    notifyListeners();
  }

  void decrementQuantity(Product product) {
    product.decrementQuantity();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }

  double get totalPrice {
    var total = 0.0;
    for (var product in _list) {
      total += product.price * product.qty;
    }
    return total;
  }
}

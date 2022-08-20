import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/product_class.dart';

class Wish with ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWhisItems => _list;
  int? get count => _list.length;
  Future<void> addWishItem(
    String name,
    double price,
    int qty,
    int qntty,
    List imagesUrl,
    String documentId,
    String suppId,
  ) async {
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

  void clearWishList() {
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

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}

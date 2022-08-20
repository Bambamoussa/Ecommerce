import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wihs_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatelessWidget {
  const CartModel({Key? key, required this.product, required this.cart}) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: Image.network(product.imagesUrl.first),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.price.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              product.qty == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) => CupertinoActionSheet(
                                            title: const Text('remove Item'),
                                            message: const Text('are you sure to remove action'),
                                            actions: <CupertinoActionSheetAction>[
                                              CupertinoActionSheetAction(
                                                /// This parameter indicates the action would be a default
                                                /// defualt behavior, turns the action's text to bold text.
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Default Action'),
                                              ),
                                              CupertinoActionSheetAction(
                                                onPressed: () async {
                                                  final wish = context.read<Wish>();
                                                  final getItem = wish.getWhisItems;
                                                  final item = getItem.firstWhereOrNull(
                                                    (element) =>
                                                        element!.documentId == product.documentId,
                                                  );

                                                  item != null
                                                      ? context.read<Cart>().removeItem(product)
                                                      : await context.read<Wish>().addWishItem(
                                                          product.name,
                                                          product.price,
                                                          1,
                                                          product.qntty,
                                                          product.imagesUrl,
                                                          product.documentId,
                                                          product.suppId);
                                                  context.read<Cart>().removeItem(product);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(' move to wishlist'),
                                              ),
                                              CupertinoActionSheetAction(
                                                /// This parameter indicates the action would perform
                                                /// a destructive action such as delete or exit and turns
                                                /// the action's text color to red.

                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  context.read<Cart>().removeItem(product);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete Item'),
                                              ),
                                            ],
                                            cancelButton: TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(fontSize: 20, color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        size: 16,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        cart.decrementQuantity(product);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.minus,
                                        size: 16,
                                      )),
                              Text(
                                product.qty.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Acme',
                                    color: product.qty == product.qntty ? Colors.red : null),
                              ),
                              IconButton(
                                  onPressed: product.qty == product.qntty
                                      ? null
                                      : () {
                                          cart.incrementQuantity(product);
                                        },
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 16,
                                  )),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

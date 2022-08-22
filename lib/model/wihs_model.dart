import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wihs_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WihsListModel extends StatelessWidget {
  const WihsListModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

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

                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  context.read<Wish>().removeItem(product);
                                },
                                icon: const Icon(Icons.delete_forever)),
                            const SizedBox(width: 10),
                            context.watch<Cart>().getItems.firstWhereOrNull(
                                              (element) => element.documentId == product.documentId,
                                            ) !=
                                        null ||
                                    product.qntty == 0
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      context.read<Cart>().addItem(
                                          product.name,
                                          product.price,
                                          1,
                                          product.qntty,
                                          product.imagesUrl,
                                          product.documentId,
                                          product.suppId);
                                    },
                                    icon: const Icon(Icons.add_shopping_cart)),
                          ],
                        )
                        // Container(
                        //   height: 35,
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey.shade200,
                        //     borderRadius: BorderRadius.circular(15),
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       product.qty == 1
                        //           ? IconButton(
                        //               onPressed: () {
                        //                 cart.removeItem(product);
                        //               },
                        //               icon: const Icon(
                        //                 Icons.delete_forever,
                        //                 size: 16,
                        //               ))
                        //           : IconButton(
                        //               onPressed: () {
                        //                 cart.decrementQuantity(product);
                        //               },
                        //               icon: const Icon(
                        //                 FontAwesomeIcons.minus,
                        //                 size: 16,
                        //               )),
                        //       Text(
                        //         product.qty.toString(),
                        //         style: TextStyle(
                        //             fontSize: 20,
                        //             fontFamily: 'Acme',
                        //             color:
                        //                 product.qty == product.qntty ? Colors.red : null),
                        //       ),
                        //       IconButton(
                        //           onPressed: product.qty == product.qntty
                        //               ? null
                        //               : () {
                        //                   cart.incrementQuantity(product);
                        //                 },
                        //           icon: const Icon(
                        //             FontAwesomeIcons.plus,
                        //             size: 16,
                        //           )),
                        //     ],
                        //   ),
                        // )
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

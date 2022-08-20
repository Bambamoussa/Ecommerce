import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/minor_screen/place_order.dart';
import 'package:multi_store_app/model/cart_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wihs_provider.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  final Widget? backButton;
  const CartScreen({Key? key, this.backButton}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            leading: widget.backButton,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: "Cart"),
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showDialog(
                            context: context,
                            title: "Cart",
                            content: "Are you sure to clear Cart ?",
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: (() {
                              context.read<Cart>().clearCart();
                              Navigator.pop(context);
                            }));
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      )),
            ],
          ),
          body: Provider.of<Cart>(context).getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Total: \$",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width * 0.40,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: MaterialButton(
                    onPressed: total == 0.0
                        ? null
                        : () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const PlaceOrderScreen()));
                          },
                    child: const Text("CHECKOUT"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("your cart is empty", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 50),
          Material(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(25),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                onPressed: () {
                  Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : Navigator.pushReplacementNamed(context, '/customer_home');
                },
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
            itemBuilder: ((context, index) {
              final product = cart.getItems[index];
              return CartModel(product: product, cart: context.read<Cart>());
            }),
            itemCount: cart.getItems.length);
      },
    );
  }
}

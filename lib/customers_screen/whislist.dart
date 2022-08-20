import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/model/wihs_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';

import 'package:multi_store_app/providers/wihs_provider.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';

import 'package:multi_store_app/widgets/appbar_widgets.dart';

import 'package:provider/provider.dart';

class WhisListScreen extends StatefulWidget {
  const WhisListScreen({Key? key}) : super(key: key);

  @override
  State<WhisListScreen> createState() => _WhisListScreenState();
}

class _WhisListScreenState extends State<WhisListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            leading: const AppBarBackButton(),
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: "Whislist"),
            actions: [
              context.watch<Wish>().getWhisItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showDialog(
                            context: context,
                            title: "Wishlist",
                            content: "Are you sure to clear wishList ?",
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: (() {
                              context.read<Wish>().clearWishList();
                              Navigator.pop(context);
                            }));
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      )),
            ],
          ),
          body: Provider.of<Wish>(context).getWhisItems.isNotEmpty
              ? const WihsItems()
              : const EmptyWihs(),
          // bottomSheet: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           const Text(
          //             "Total: \$",
          //             style: TextStyle(fontSize: 18),
          //           ),
          //           Text(
          //             context.watch<Cart>().totalPrice.toStringAsFixed(2),
          //             style: const TextStyle(
          //                 fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          //           ),
          //         ],
          //       ),
          //       YellowButton(
          //         width: 0.45,
          //         onPressed: () {},
          //         label: "CHECKOUT",
          //       )
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}

class EmptyWihs extends StatelessWidget {
  const EmptyWihs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("your WihsList is empty", style: TextStyle(fontSize: 30)),
          // const SizedBox(height: 50),
          // Material(
          //     color: Colors.lightBlueAccent,
          //     borderRadius: BorderRadius.circular(25),
          //     child: MaterialButton(
          //       minWidth: MediaQuery.of(context).size.width * 0.6,
          //       onPressed: () {
          //         Navigator.canPop(context)
          //             ? Navigator.pop(context)
          //             : Navigator.pushReplacementNamed(context, '/customer_home');
          //       },
          //       child: const Text(
          //         "Continue Shopping",
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ),
          //     ))
        ],
      ),
    );
  }
}

class WihsItems extends StatelessWidget {
  const WihsItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemBuilder: ((context, index) {
              final product = wish.getWhisItems[index];
              return WihsListModel(product: product);
            }),
            itemCount: wish.getWhisItems.length);
      },
    );
  }
}

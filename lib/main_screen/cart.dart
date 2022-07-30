import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screen/custom_home.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: "Cart"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.black,
              )),
        ],
      ),
      body: Center(
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomHomeScreen(),
                        ));
                  },
                  child: const Text(
                    "Continue Shopping",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  "Total: \$",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "00.0",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
            Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: MaterialButton(onPressed: () {}, child: const Text("CHECKOUT")))
          ],
        ),
      ),
    );
  }
}
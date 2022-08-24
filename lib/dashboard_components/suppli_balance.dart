import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("sid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          double totalPrice = 0;
          for (var item in snapshot.data!.docs) {
            totalPrice += item['orderprice'] * item['orderqty'];
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const AppBarTitle(title: "Stactistics"),
              leading: const AppBarBackButton(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BalanceModel(
                    label: "total balance",
                    value: totalPrice,
                    decimal: 2,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: MaterialButton(
                            onPressed: () {},
                            child: const Text(
                              "Get my Money",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ))),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class BalanceModel extends StatelessWidget {
  final String label;
  final dynamic value;
  final int decimal;
  const BalanceModel({
    Key? key,
    required this.label,
    required this.value,
    required this.decimal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Container(
            height: 90,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
            ),
            child: AnimatedCounter(
              count: value,
              decimal: decimal,
            ))
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final dynamic count;
  final int decimal;
  const AnimatedCounter({Key? key, this.count, required this.decimal}) : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count).animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: ((context, child) {
          return Center(
            child: Text(
              _animation.value.toStringAsFixed(widget.decimal),
              style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 40,
                  fontFamily: "Acme",
                  fontWeight: FontWeight.bold),
            ),
          );
        }));
  }
}

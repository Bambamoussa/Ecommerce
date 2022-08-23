import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multi_store_app/dashboard_components/delivered_order.dart';
import 'package:multi_store_app/dashboard_components/preparing_order.dart';
import 'package:multi_store_app/dashboard_components/shipping_order.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class SuppliOrdersScreen extends StatelessWidget {
  const SuppliOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: "Orders"),
          leading: const AppBarBackButton(),
          bottom: const TabBar(tabs: [
            RepeatTab(label: "Preparing"),
            RepeatTab(label: "Shipping"),
            RepeatTab(label: "Delivered"),
          ]),
        ),
        body: const TabBarView(children: [
          PreparingOrder(),
          ShippingOrder(),
          DeliveredOrder(),
        ]),
      ),
    );
  }
}

class RepeatTab extends StatelessWidget {
  final String label;
  const RepeatTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Center(
      child: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DashboardItem> _dashboardItems = [
      DashboardItem(
        label: "My Store",
        icon: Icons.store,
      ),
      DashboardItem(
        label: "Orders",
        icon: Icons.shop_2_outlined,
      ),
      DashboardItem(label: "Edit Profile", icon: Icons.edit),
      DashboardItem(
        label: "Manage Products",
        icon: Icons.settings,
      ),
      DashboardItem(
        label: "Balance",
        icon: Icons.attach_money,
      ),
      DashboardItem(
        label: "Statistics",
        icon: Icons.show_chart,
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: "Dashboard"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.black),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 50,
            crossAxisSpacing: 50,
            children: List.generate(_dashboardItems.length, (index) {
              return Card(
                elevation: 20,
                shadowColor: Colors.purpleAccent.shade200,
                color: Colors.blueGrey.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(_dashboardItems[index].icon, color: Colors.yellowAccent, size: 50),
                    Text(_dashboardItems[index].label.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            fontFamily: "Acme")),
                  ],
                ),
              );
            }),
          ),
        ));
  }
}

class DashboardItem {
  final String label;
  final IconData icon;

  DashboardItem({required this.label, required this.icon});
}

import 'package:flutter/material.dart';
import 'package:multi_store_app/galleries/kids_gallery.dart';
import 'package:multi_store_app/galleries/men_gallery.dart';
import 'package:multi_store_app/galleries/shoes_gallery.dart';
import 'package:multi_store_app/galleries/women_gallery.dart';
import 'package:multi_store_app/widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 9,
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const FakeSearch(),
            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.yellow,
              indicatorWeight: 8,
              tabs: [
                RepeatTab(label: "Men"),
                RepeatTab(label: "Women"),
                RepeatTab(label: "Shoes"),
                RepeatTab(label: "Bags"),
                RepeatTab(label: "Electroniques"),
                RepeatTab(label: "Accessories"),
                RepeatTab(label: "Home & Garden"),
                RepeatTab(label: "Kids"),
                RepeatTab(label: "Beauty"),
              ],
            ),
          ),
          body: const TabBarView(children: [
            MenGalleryScreen(),
            WomenGalleryScreen(),
            ShoesGalleryScreen(),
            Center(
              child: Text("Bags Screen"),
            ),
            Center(
              child: Text("Electronics Screen"),
            ),
            Center(
              child: Text("Accessories Screen"),
            ),
            Center(
              child: Text("Home & Garden Screen"),
            ),
            KidsGalleryScreen(),
            Center(
              child: Text("Beauty Screen"),
            ),
          ]),
        ));
  }
}

class RepeatTab extends StatelessWidget {
  final String label;
  const RepeatTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}

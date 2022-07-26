import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/fake_search.dart';

List<ItemsData> items = [
  ItemsData(label: 'men'),
  ItemsData(label: 'Women'),
  ItemsData(label: 'shoes'),
  ItemsData(label: 'bags'),
  ItemsData(label: 'electronics'),
  ItemsData(label: 'accessories'),
  ItemsData(label: 'home & garden'),
  ItemsData(label: 'kids'),
  ItemsData(label: 'beauty'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const FakeSearch(),
        ),
        body: Stack(
          children: [
            Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
            Positioned(bottom: 0, right: 0, child: categoryView(size)),
          ],
        ));
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      child: Container(
        height: size.height * 0.8,
        width: size.width * 0.2,
        color: Colors.grey.shade300,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                for (var element in items) {
                  element.isSelected = false;
                }
                setState(() {
                  items[index].isSelected = true;
                });
              },
              child: Container(
                height: 100,
                color: items[index].isSelected == true ? Colors.white : Colors.grey.shade300,
                child: Center(child: Text(items[index].label)),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget categoryView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  ItemsData({required this.label, this.isSelected = false});
}

import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/sub_categ_products.dart';
import 'package:multi_store_app/utilities/categ_list.dart';

class MenCategory extends StatelessWidget {
  const MenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategoryHeaderLabel(
                    headerLabel: "Men",
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children: List.generate(
                        men.length,
                        (index) => SubCategoryModel(
                          mainCategoryName: 'men',
                          subCategoryName: men[index],
                          assertName: 'images/men/men$index',
                          SubCategoryLabel: men[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.05,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        const Text("<<",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.brown,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 10)),
                        Text('men'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.brown,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 10)),
                        const Text(">>",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.brown,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 10))
                      ]),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class SubCategoryModel extends StatelessWidget {
  final String subCategoryName;
  final String mainCategoryName;
  final String assertName;
  final String SubCategoryLabel;

  const SubCategoryModel({
    Key? key,
    required this.subCategoryName,
    required this.mainCategoryName,
    required this.assertName,
    required this.SubCategoryLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          (context),
          MaterialPageRoute(
              builder: (context) => SubCategoryProducts(
                    mainCategName: mainCategoryName,
                    subCategName: subCategoryName,
                  ))),
      child: Column(children: [
        SizedBox(
          height: 70,
          width: 40,
          child: Image(image: AssetImage(assertName)),
        ),
        Text(SubCategoryLabel)
      ]),
    );
  }
}

class CategoryHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategoryHeaderLabel({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Center(
        child: Text(
          headerLabel,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
    );
  }
}

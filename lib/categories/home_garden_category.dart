import 'package:flutter/material.dart';
import 'package:multi_store_app/categories/categ_widgets.dart';
import 'package:multi_store_app/utilities/categ_list.dart';

class HomeGardenCategory extends StatelessWidget {
  const HomeGardenCategory({Key? key}) : super(key: key);

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
                    headerLabel: "Home & Garden",
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children: List.generate(
                        homeandgarden.length,
                        (index) => SubCategoryModel(
                          mainCategoryName: 'Home & Garden',
                          subCategoryName: women[index],
                          assertName: 'images/homegarden/home$index.jpg',
                          SubCategoryLabel: women[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
              bottom: 0,
              right: 0,
              child: SliderBar(
                mainCategoryName: "garden & home",
              ))
        ],
      ),
    );
  }
}

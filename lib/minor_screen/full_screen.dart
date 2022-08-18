import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenView({Key? key, required this.imagesList}) : super(key: key);

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _pageController = PageController();
  int index = 0;

  dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Center(
            child: Text(
              "${index + 1}/${widget.imagesList.length}",
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              controller: _pageController,
              children: images(),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2, child: imageView())
        ]),
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagesList.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.jumpToPage(index);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.yellow,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imagesList[index].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }));
  }

  List<Widget> images() {
    return List.generate(
        widget.imagesList.length,
        (index) => InteractiveViewer(
            transformationController: TransformationController(),
            child: Image.network(widget.imagesList[index].toString())));
  }
}

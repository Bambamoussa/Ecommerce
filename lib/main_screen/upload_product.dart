import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late double price;
  late int quantity;
  late String productName;
  late String productDescription;
  late String proId;
  String mainCategoryValue = "select category";
  String subCategoryValue = "subCategory";
  List<String> subCategoryList = [];
  bool processing = false;
  List<XFile>? imageFileList = [];
  List<String> imageUrlList = [];
  dynamic _pickImageError;
  final ImagePicker _imagePicker = ImagePicker();

  void pickerProductImage() async {
    try {
      final pickerImages =
          await _imagePicker.pickMultiImage(maxWidth: 300, maxHeight: 300, imageQuality: 95);
      setState(() {
        imageFileList = pickerImages!;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void selectedMainCateg(String? value) {
    if (value == 'select category') {
      subCategoryList = [];
    } else if (value == "men") {
      subCategoryList = men;
    } else if (value == "women") {
      subCategoryList = women;
    } else if (value == 'electronics') {
      subCategoryList = electronics;
    } else if (value == 'accessories') {
      subCategoryList = accessories;
    } else if (value == 'home & garden') {
      subCategoryList = homeandgarden;
    } else if (value == 'beauty') {
      subCategoryList = beauty;
    } else if (value == 'kids') {
      subCategoryList = kids;
    } else if (value == 'bags') {
      subCategoryList = bags;
    } else if (value == 'shoes') {
      subCategoryList = shoes;
    }
    setState(() {
      mainCategoryValue = value!;
      subCategoryValue = "subCategory";
    });
  }

  Future<void> uploadImage() async {
    if (mainCategoryValue != "select category" || subCategoryValue != "subCategory") {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imageFileList!.isNotEmpty) {
          setState(() {
            processing = true;
          });
          try {
            for (var imageFile in imageFileList!) {
              var ref = FirebaseStorage.instance.ref('product/${Path.basename(imageFile.path)}');
              await ref.putFile(File(imageFile.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
          print("image save");
          _formKey.currentState!.reset();
        } else {
          MessengerHandler.showSnackBar(_scaffoldKey, "Please picked image");
        }
      } else {
        MessengerHandler.showSnackBar(_scaffoldKey, "Please fill all the fields");
      }
    } else {
      MessengerHandler.showSnackBar(_scaffoldKey, "Please select categories");
    }
  }

  void uploadData() async {
    if (imageUrlList.isNotEmpty) {
      CollectionReference productRef = FirebaseFirestore.instance.collection('products');
      proId = const Uuid().v4();
      await productRef.doc(proId).set({
        'proid': proId,
        'maintecategory': mainCategoryValue,
        'subcategory': subCategoryValue,
        'productname': productName,
        'productdescription': productDescription,
        'price': price,
        'instock': quantity,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'proimage': imageUrlList,
        'discount': 0,
      }).whenComplete(() {
        setState(() {
          processing = false;
          imageFileList = [];
          mainCategoryValue = "select category";
          subCategoryList = [];
          imageUrlList = [];
        });
      });
    } else {
      print("no image");
    }
  }

  void uploadProduct() async {
    await uploadImage().whenComplete(() => uploadData());
    // if (mainCategoryValue != "select category" || subCategoryValue != "subCategory") {
    //   if (_formKey.currentState!.validate()) {
    //     _formKey.currentState!.save();
    //     if (imageFileList!.isNotEmpty) {
    //       try {
    //         for (var imageFile in imageFileList!) {
    //           var ref = FirebaseStorage.instance.ref('product/${Path.basename(imageFile.path)}');
    //           await ref.putFile(File(imageFile.path)).whenComplete(() async {
    //             await ref.getDownloadURL().then((value) {
    //               imageUrlList.add(value);
    //             }).whenComplete(() async {
    //               CollectionReference productRef =
    //                   FirebaseFirestore.instance.collection('products');
    //               await productRef.doc().set({
    //                 'maintecategory': mainCategoryValue,
    //                 'subcategory': subCategoryValue,
    //                 'productname': productName,
    //                 'productdescription': productDescription,
    //                 'price': price,
    //                 'instock': quantity,
    //                 'sid': FirebaseAuth.instance.currentUser!.uid,
    //                 'proimage': imageUrlList,
    //                 'discount': 0,
    //               });
    //             });
    //           });
    //         }
    //       } catch (e) {
    //         print(e);
    //       }
    //       print("image save");
    //       _formKey.currentState!.reset();
    //       setState(() {
    //         imageFileList = [];
    //         mainCategoryValue = "select category";
    //         subCategoryList = [];
    //       });
    //     } else {
    //       MessengerHandler.showSnackBar(_scaffoldKey, "Please picked image");
    //     }
    //   } else {
    //     MessengerHandler.showSnackBar(_scaffoldKey, "Please fill all the fields");
    //   }
    // } else {
    //   MessengerHandler.showSnackBar(_scaffoldKey, "Please select categories");
    // }
  }

  Widget previewImage() {
    if (imageFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imageFileList!.length,
          itemBuilder: (context, index) {
            var myFile = File(imageFileList![index].path);
            return Image.file(myFile);
          });
    } else {
      return const Text(
        "you have not \n \n picked images yet",
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            color: Colors.blueGrey.shade100,
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: previewImage(),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    const Text("*select  category",
                                        style: TextStyle(color: Colors.red)),
                                    DropdownButton(
                                      iconSize: 30,
                                      iconEnabledColor: Colors.red,
                                      iconDisabledColor: Colors.black,
                                      menuMaxHeight: 500,
                                      value: mainCategoryValue,
                                      items: maincateg
                                          .map<DropdownMenuItem<String>>(
                                              (value) => DropdownMenuItem(
                                                    child: Text(value),
                                                    value: value,
                                                  ))
                                          .toList(),
                                      onChanged: (String? value) {
                                        print(value);
                                        selectedMainCateg(value);
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text("*select  subcategory",
                                        style: TextStyle(color: Colors.red)),
                                    DropdownButton(
                                      iconSize: 30,
                                      iconEnabledColor: Colors.red,
                                      iconDisabledColor: Colors.black,
                                      menuMaxHeight: 500,
                                      disabledHint: const Text("select subCategory"),
                                      value: subCategoryValue,
                                      items: subCategoryList
                                          .map<DropdownMenuItem<String>>(
                                              (value) => DropdownMenuItem(
                                                    child: Text(value),
                                                    value: value,
                                                  ))
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          subCategoryValue = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                      child: Divider(
                        color: Colors.yellow,
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the Price';
                            } else if (!value.isValidPrice()) {
                              return "not a valid price";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            price = double.parse(value!);
                          },
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: textFormDecoration.copyWith(
                              labelText: "Price", hintText: "Price ..\$"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Quantity';
                            } else if (!value.isValidQuantity()) {
                              return 'not valid Quantity';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormDecoration.copyWith(
                              labelText: "Quantity", hintText: "Add Quantity "),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Product';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            productName = value!;
                          },
                          maxLength: 100,
                          maxLines: 3,
                          decoration: textFormDecoration.copyWith(
                              labelText: "Product name", hintText: "Enter product name ..\$"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            productDescription = value!;
                          },
                          maxLength: 800,
                          maxLines: 5,
                          decoration: textFormDecoration.copyWith(
                              labelText: "Product description",
                              hintText: "Enter product description ..\$"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: FloatingActionButton(
                  onPressed: imageFileList!.isEmpty
                      ? () {
                          pickerProductImage();
                        }
                      : () {
                          setState(() {
                            imageFileList = [];
                          });
                        },
                  child: imageFileList!.isEmpty
                      ? const Icon(Icons.photo_library, color: Colors.black)
                      : const Icon(Icons.delete_forever, color: Colors.black),
                  backgroundColor: Colors.yellow,
                ),
              ),
              FloatingActionButton(
                onPressed: processing == true ? null : uploadProduct,
                child: processing == true
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : const Icon(Icons.upload, color: Colors.black),
                backgroundColor: Colors.yellow,
              ),
            ],
          )),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: "Price",
  hintText: " Price ...\$",
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.yellow, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent.shade100, width: 2),
      borderRadius: BorderRadius.circular(10)),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$').hasMatch(this);
  }
}

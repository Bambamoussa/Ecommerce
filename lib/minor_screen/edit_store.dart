import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({Key? key, this.data}) : super(key: key);

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  late String storeName;
  late String phone;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _imagePicker = ImagePicker();
  late String storeLogo;
  late String coverImage;
  bool processing = false;
  XFile? _imagelogo;
  XFile? _imagecover;
  dynamic _pickImageError;
  pickStoreLogo() async {
    try {
      final pickerLogo = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300, imageQuality: 95);
      setState(() {
        _imagelogo = pickerLogo;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  pickCoverImage() async {
    try {
      final pickerCover = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300, imageQuality: 95);
      setState(() {
        _imagecover = pickerCover;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> uploadStoreLogo() async {
    if (_imagelogo != null) {
      try {
        var ref = FirebaseStorage.instance.ref("supplier-images/${widget.data["email"]}.jpg");
        await ref.putFile(File(_imagelogo!.path));
        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        throw Exception("errrrrrrrrrrr$e");
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future<void> uploadCoverImage() async {
    if (_imagecover != null) {
      try {
        var ref2 = FirebaseStorage.instance.ref("supplier-images/${widget.data["email"]}.jpg");
        await ref2.putFile(File(_imagecover!.path));
        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        throw Exception(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo()
          .whenComplete(() async => uploadCoverImage().whenComplete(() => editSoreData()));
    } else {
      MessengerHandler.showSnackBar(_scaffoldKey, "please full all field.");
    }
  }

  editSoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("Suppliers")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        "storename": storeName,
        "phone": phone,
        "storelogo": storeLogo,
        "coverimage": coverImage,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: "edit store"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    const Text("Store logo",
                        style: TextStyle(
                            fontSize: 24, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.data["storelogo"]),
                        ),
                        Column(
                          children: [
                            YellowButton(
                                label: "change",
                                onPressed: () {
                                  pickStoreLogo();
                                },
                                width: 0.25),
                            _imagelogo == null
                                ? const SizedBox()
                                : YellowButton(
                                    label: "reset",
                                    onPressed: () {
                                      setState(() {
                                        _imagelogo = null;
                                      });
                                    },
                                    width: 0.25),
                          ],
                        ),
                        _imagelogo == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(File(_imagelogo!.path)),
                              )
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Divider(
                          color: Colors.yellow,
                          thickness: 2,
                        )),
                  ],
                ),
                Column(
                  children: [
                    const Text(" Cover image",
                        style: TextStyle(
                            fontSize: 24, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.data["coverimage"]),
                        ),
                        Column(
                          children: [
                            YellowButton(
                                label: "change",
                                onPressed: () {
                                  pickCoverImage();
                                },
                                width: 0.25),
                            _imagecover == null
                                ? const SizedBox()
                                : YellowButton(
                                    label: "reset",
                                    onPressed: () {
                                      setState(() {
                                        _imagecover = null;
                                      });
                                    },
                                    width: 0.25),
                          ],
                        ),
                        _imagecover == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(File(_imagecover!.path)),
                              )
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Divider(
                          color: Colors.yellow,
                          thickness: 2,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter store name";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      storeName = newValue!;
                    },
                    initialValue: widget.data["storename"],
                    decoration: textFormDecoration.copyWith(
                        labelText: "store name", hintText: "Enter store name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the phone number";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      phone = newValue!;
                    },
                    initialValue: widget.data["phone"],
                    decoration: textFormDecoration.copyWith(
                        labelText: "phone", hintText: "Enter phone number"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      YellowButton(
                          label: "cancel",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: 0.25),
                      processing == true
                          ? YellowButton(label: "please waiting", onPressed: () {}, width: 0.5)
                          : YellowButton(
                              label: "save changes",
                              onPressed: () {
                                saveChanges();
                              },
                              width: 0.5),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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

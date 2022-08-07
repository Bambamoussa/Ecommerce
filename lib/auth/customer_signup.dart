import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class CustomerRegister extends StatefulWidget {
  CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  XFile? _imageFile;
  dynamic _pickImageError;
  final ImagePicker _imagePicker = ImagePicker();
  void _pickerImageCamera() async {
    try {
      final pickerImage = await _imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 300, maxHeight: 300, imageQuality: 95);
      setState(() {
        _imageFile = pickerImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void _pickerImageGallery() async {
    try {
      final pickerImage = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300, imageQuality: 95);
      setState(() {
        _imageFile = pickerImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late String name;
  late String email;
  late String password;
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const AuthHeaderLabel(headerLabel: "Sign Up"),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage:
                                  _imageFile == null ? null : FileImage(File(_imageFile!.path))),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt),
                                color: Colors.white,
                                onPressed: () {
                                  _pickerImageCamera();
                                  print("object");
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.photo),
                                color: Colors.white,
                                onPressed: () {
                                  _pickerImageGallery();
                                  print("object");
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _nameController,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        }),
                        decoration: textFormDecoration.copyWith(
                          labelText: "full Name",
                          hintText: "Enter your full name",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _emailController,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          } else if (value.isValidEmail() == false) {
                            return "Please enter a valid email";
                          } else if (value.isValidEmail() == true) {
                            return null;
                          }
                          return null;
                        }),
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormDecoration.copyWith(
                          labelText: "Email Adress",
                          hintText: "Enter your email",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        }),
                        obscureText: passwordVisible,
                        decoration: textFormDecoration.copyWith(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                            color: Colors.purple,
                          ),
                          labelText: "Password",
                          hintText: "Enter your password",
                        ),
                      ),
                    ),
                    HaveAccount(
                      haveAccount: "already have an account ?",
                      actionLabel: "Sign in",
                      onPressed: () {},
                    ),
                    AuthMainButton(
                      mainButtonLabel: "Sign up",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_imageFile != null) {
                            print("valid");
                            _formKey.currentState!.reset();
                            setState(() {
                              _imageFile = null;
                            });
                          } else {
                            MessengerHandler.showSnackBar(_scaffoldKey, "Please pick image fields");
                          }
                        } else {
                          MessengerHandler.showSnackBar(_scaffoldKey, "Please fill all the fields");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}

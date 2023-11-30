import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/consts/my_validators.dart';
import 'package:store_app/root_screen.dart';
import 'package:store_app/screens/loading_manger.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/picked_image.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

class RegisterScreen extends StatefulWidget {
  static const route = '/RegisterScreen';
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  XFile? _pickedImage;
  final auth = FirebaseAuth.instance;
  bool isloading = false;
  String? userimageurl;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // Focus Nodes
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _registerFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null) {
      MyappMethods.ShowErrorOrWarningDialog(
          context: context,
          subtitle: "Make sure to pick up an image",
          function: () {
            Navigator.pop(context);
          });
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          isloading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child("${_emailController.text.trim()}.jpg");
        await ref.putFile(File(_pickedImage!.path));
        userimageurl = await ref.getDownloadURL();
        await auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        User? user = auth.currentUser;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set({
          "userid": user.uid,
          "username": _nameController.text,
          "userimage": userimageurl,
          "useremail": _emailController.text,
          "createdat": Timestamp.now(),
          "usercart": [],
          "userwish": [],
        });
        Navigator.of(context).pushReplacementNamed(rootscreen.route);

        Fluttertoast.showToast(
            msg: "An account has been created",
            textColor: Colors.white,
            fontSize: 15);
      } catch (error) {
        MyappMethods.ShowErrorOrWarningDialog(
            context: context,
            subtitle: "an error occured ${error}",
            function: () {
              Navigator.pop(context);
            });
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyappMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManger(
          isloading: isloading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  const TitleTextWidget(
                    label: "smart store",
                    fontSize: 30,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(label: "Welcome"),
                        subTitleTextWidget(label: "Your welcome message")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: PickImageWidget(
                      pickedImage: _pickedImage,
                      function: () async {
                        await localImagePicker();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Full name",
                            prefixIcon: Icon(
                              Icons.message,
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(
                              Icons.message,
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "*********",
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "*********",
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.repeatPasswordValidator(
                                value: value,
                                password: _passwordController.text);
                          },
                          onFieldSubmitted: (value) {
                            _registerFct();
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              // backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            icon: const Icon(Ionicons.add),
                            label: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () async {
                              _registerFct();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/auth/google_btn.dart';
import 'package:store_app/auth/register.dart';
import 'package:store_app/consts/my_validators.dart';
import 'package:store_app/root_screen.dart';
import 'package:store_app/screens/loading_manger.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isloading = false;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // Focus Nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
    }
    try {
      setState(() {
        isloading = true;
      });
      await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Fluttertoast.showToast(
          msg: "login sucessful", textColor: Colors.white, fontSize: 15);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(rootscreen.route);
    } catch (error) {
      MyappMethods.ShowErrorOrWarningDialog(
          context: context,
          subtitle: "an error occured $error",
          function: () {
            Navigator.pop(context);
          });
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: TitleTextWidget(label: "Welcome back"),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                            return MyValidators.passwordValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            _loginFct();
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const subTitleTextWidget(
                              label: "Forgot password?",
                              textDecoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
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
                            icon: const Icon(Icons.login),
                            label: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () async {
                              _loginFct();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        subTitleTextWidget(
                          label: "OR connect using".toUpperCase(),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: kBottomNavigationBarHeight + 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight,
                                    child: FittedBox(
                                      child: GoogleButton(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: kBottomNavigationBarHeight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(12),
                                        // backgroundColor:
                                        // Theme.of(context).colorScheme.background,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Guest",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () async {
                                        await Navigator.of(context)
                                            .pushReplacementNamed(
                                                rootscreen.route);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const subTitleTextWidget(
                              label: "Don't have an account?",
                            ),
                            TextButton(
                              child: const subTitleTextWidget(
                                label: "Sign up",
                                textDecoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RegisterScreen.route);
                              },
                            ),
                          ],
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

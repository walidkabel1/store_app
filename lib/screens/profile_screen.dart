import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/auth/login.dart';
import 'package:store_app/innerScreens/orders_screen.dart';
import 'package:store_app/models/user_model.dart';
import 'package:store_app/providers/user_provider.dart';
import 'package:store_app/screens/loading_manger.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/innerScreens/viewed_recently.dart';
import 'package:store_app/innerScreens/wishlist.dart';
import 'package:store_app/providers/theme_provider.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

class profilepage extends StatefulWidget {
  profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

UserModel? userModel;
bool _isloading = true;

class _profilepageState extends State<profilepage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isloading = false;
      });
      return;
    }

    try {
      final userprovider = Provider.of<UserProvider>(context);
      userModel = await userprovider.fetchUserInfo();
      setState(() {
        _isloading = false;
      });
      return;
    } on FirebaseException catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        MyappMethods.ShowErrorOrWarningDialog(
            context: context,
            subtitle: "an error occured ${error.message}",
            function: () {
              print(error.message);
              Navigator.pop(context);
            });
      });
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        MyappMethods.ShowErrorOrWarningDialog(
            context: context,
            subtitle: "an error occured ${error}",
            function: () {
              print(error);
              Navigator.pop(context);
            });
      });
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    await fetchUserInfo();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProviders = Provider.of<themeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: 'Profile Screen',
        ),
        leading: Image.asset(assetsManager.shoppingcart),
      ),
      body: LoadingManger(
        isloading: _isloading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Visibility(
                  visible: user == null ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TitleTextWidget(
                      label: "please login to have ultimated acsess",
                    ),
                  )),
              user == null
                  ? SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    width: 3),
                                image: DecorationImage(
                                    image: NetworkImage(userModel!.userimage),
                                    fit: BoxFit.fill)),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextWidget(
                                label: userModel!.username,
                              ),
                              subTitleTextWidget(label: userModel!.useremail),
                            ],
                          )
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleTextWidget(label: "General"),
              ),
              SizedBox(
                height: 10,
              ),
              user == null
                  ? SizedBox.shrink()
                  : customlisttile(
                      text: "Address",
                      imagepath: assetsManager.address,
                      ontap: () {}),
              user == null
                  ? SizedBox.shrink()
                  : customlisttile(
                      text: "All Orders",
                      imagepath: assetsManager.ordersvg,
                      ontap: () {
                        Navigator.of(context).pushNamed(OrdersScreen.route);
                      }),
              customlisttile(
                  text: "WishList",
                  imagepath: assetsManager.whishlistsvg,
                  ontap: () {
                    Navigator.of(context).pushNamed(wishlist.route);
                  }),
              customlisttile(
                  text: "Viewed Recently",
                  imagepath: assetsManager.recent,
                  ontap: () {
                    Navigator.of(context).pushNamed(viewedrecently.route);
                  }),
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleTextWidget(label: "settings"),
              ),
              SizedBox(
                height: 10,
              ),
              SwitchListTile(
                  secondary: Image.asset(
                    assetsManager.theme,
                    height: 30,
                  ),
                  title: Text(themeProviders.getIsDarkTheme
                      ? "Dart Theme"
                      : "light Theme"),
                  value: themeProviders.getIsDarkTheme,
                  onChanged: (value) {
                    themeProviders.setDarkTheme(themevalue: value);
                  }),
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleTextWidget(label: "Others"),
              ),
              SizedBox(
                height: 10,
              ),
              customlisttile(
                  text: "Privacy&Policy",
                  imagepath: assetsManager.privacy,
                  ontap: () {}),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () async {
                        if (user == null) {
                          await Navigator.of(context)
                              .pushNamed(LoginScreen.route);
                        } else {
                          await MyappMethods.ShowErrorOrWarningDialog(
                              iserror: false,
                              context: context,
                              subtitle: "Are you sure ?",
                              function: () async {
                                await FirebaseAuth.instance.signOut();
                                if (!mounted) return;
                                Navigator.of(context)
                                    .pushNamed(LoginScreen.route);
                              });
                        }
                      },
                      child: FittedBox(
                        child: Row(
                          children: [
                            Icon(user == null ? Icons.login : Icons.logout),
                            SizedBox(width: 10),
                            TitleTextWidget(
                                label: user == null ? "login" : "log out"),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class customlisttile extends StatelessWidget {
  const customlisttile(
      {super.key,
      required this.text,
      required this.imagepath,
      required this.ontap});

  final String text, imagepath;
  final Function ontap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        ontap();
      },
      title: subTitleTextWidget(label: text),
      leading: Image.asset(
        imagepath,
        height: 30,
      ),
      trailing: Icon(Icons.arrow_circle_right_outlined),
    );
  }
}

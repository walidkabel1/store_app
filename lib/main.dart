import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/auth/login.dart';
import 'package:store_app/auth/register.dart';
import 'package:store_app/consts/theme_data.dart';
import 'package:store_app/firebase_options.dart';
import 'package:store_app/innerScreens/orders_screen.dart';
import 'package:store_app/innerScreens/product_details.dart';
import 'package:store_app/innerScreens/viewed_recently.dart';
import 'package:store_app/innerScreens/wishlist.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/orders_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/providers/theme_provider.dart';
import 'package:store_app/providers/user_provider.dart';
import 'package:store_app/providers/viewedRecentlr_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/root_screen.dart';
import 'package:store_app/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ViewedRecentlyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<themeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          routes: {
            productdetails.route: (context) => const productdetails(),
            wishlist.route: (context) => const wishlist(),
            viewedrecently.route: (context) => const viewedrecently(),
            LoginScreen.route: (context) => const LoginScreen(),
            RegisterScreen.route: (context) => const RegisterScreen(),
            searchpage.route: (context) => const searchpage(),
            rootscreen.route: (context) => const rootscreen(),
            OrdersScreen.route: (context) => const OrdersScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Store App',
          theme: styles.themeData(
              context: context, isDarkTheme: themeProvider.getIsDarkTheme),
          home: const LoginScreen(),
        );
      }),
    );
  }
}

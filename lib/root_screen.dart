import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/cart/cart_screen.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/providers/user_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/screens/home_screen.dart';
import 'package:store_app/screens/profile_screen.dart';
import 'package:store_app/screens/search_screen.dart';
import 'package:store_app/widgets/subtitle_text.dart';

class rootscreen extends StatefulWidget {
  const rootscreen({super.key});
  static const route = '/rootscreen';

  @override
  State<rootscreen> createState() => _rootscreenState();
}

class _rootscreenState extends State<rootscreen> {
  List<Widget> screens = [homepage(), searchpage(), cartpage(), profilepage()];
  PageController? controller;
  int currentscreen = 0;
  bool isloadingprods = true;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentscreen);
  }

  @override
  void didChangeDependencies() {
    if (isloadingprods) {
      fetchfct();
    }
    super.didChangeDependencies();
  }

  Future<void> fetchfct() async {
    final productprovider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartprovider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    final userprovider = Provider.of<UserProvider>(context);

    try {
      Future.wait(
          {productprovider.fetchproducts(), userprovider.fetchUserInfo()});
      Future.wait({cartprovider.fetchcart(), wishlistProvider.fetchwishlist()});
    } catch (error) {
      rethrow;
    } finally {
      setState(() {
        isloadingprods = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartprovider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
          elevation: 2,
          height: kBottomNavigationBarHeight,
          selectedIndex: currentscreen,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onDestinationSelected: (index) {
            setState(() {
              currentscreen = index;
            });
            controller!.jumpToPage(currentscreen);
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'home'),
            NavigationDestination(icon: Icon(Icons.search), label: 'search'),
            Badge(
                alignment: Alignment.center,
                label: subTitleTextWidget(
                  label: cartprovider.getcartitems.length.toString(),
                ),
                backgroundColor: Colors.red,
                child: NavigationDestination(
                    icon: Icon(Icons.shop_sharp), label: 'cart')),
            NavigationDestination(icon: Icon(Icons.person_2), label: 'profile')
          ]),
    );
  }
}

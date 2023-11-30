import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/products/product_widget.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/cart/empty_cartwidget.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/title_text.dart';

class wishlist extends StatelessWidget {
  wishlist({super.key});
  static const route = '/wishlist';

  @override
  Widget build(BuildContext context) {
    final wishlist_provider = Provider.of<wishlistProvider>(context);

    Size size = MediaQuery.of(context).size;
    return wishlist_provider.getwishlistitems.isEmpty
        ? cartwidget(
            imagepath: assetsManager.bagwish,
            subtitle:
                'Looks like you have not added any thing to your cart , Go ahead & Explore top categories',
            title: 'Your Wishlist Is Empty')
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      MyappMethods.ShowErrorOrWarningDialog(
                          iserror: false,
                          context: context,
                          subtitle: "remove items",
                          function: () {
                            wishlist_provider.clearwishlistfromfirebase();
                            // wishlist_provider.clearwishlist();
                            Navigator.pop(context);
                          });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
              title: TitleTextWidget(
                label:
                    'wishlist (${wishlist_provider.getwishlistitems.length})',
              ),
              leading: Image.asset(assetsManager.shoppingcart),
            ),
            body: DynamicHeightGridView(
              itemCount: wishlist_provider.getwishlistitems.length,
              builder: ((context, index) {
                return productwidget(
                  productid: wishlist_provider.getwishlistitems.values
                      .toList()[index]
                      .productid,
                );
              }),
              crossAxisCount: 2,
            ),
          );
  }
}

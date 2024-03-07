import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/products/product_widget.dart';
import 'package:store_app/providers/viewedRecentlr_provider.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/cart/empty_cartwidget.dart';
import 'package:store_app/widgets/title_text.dart';

class viewedrecently extends StatelessWidget {
  const viewedrecently({super.key});
  static const route = '/viewedrecently';

  @override
  Widget build(BuildContext context) {
    final viewedrecentlyprovider = Provider.of<ViewedRecentlyProvider>(context);

    Size size = MediaQuery.of(context).size;
    return viewedrecentlyprovider.getViewedRecentlyitems.isEmpty
        ? cartwidget(
            imagepath: assetsManager.bagwish,
            subtitle:
                'Looks like you have not added any thing to your viewedrecently , Go ahead & Explore top categories',
            title: 'Your viewedrecently Is Empty')
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_shopping_cart_outlined,
                      color: Colors.red,
                    ))
              ],
              title: TitleTextWidget(
                label:
                    'viewedrecently (${viewedrecentlyprovider.getViewedRecentlyitems.length})',
              ),
              leading: Image.asset(assetsManager.shoppingcart),
            ),
            body: DynamicHeightGridView(
              itemCount: viewedrecentlyprovider.getViewedRecentlyitems.length,
              builder: ((context, index) {
                return productwidget(
                  productid: viewedrecentlyprovider
                      .getViewedRecentlyitems.values
                      .toList()[index]
                      .productid,
                );
              }),
              crossAxisCount: 2,
            ),
          );
  }
}

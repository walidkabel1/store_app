import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/innerScreens/product_details.dart';
import 'package:store_app/models/products_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/viewedRecentlr_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/heart_btn.dart';

class latestarrivalwidget extends StatelessWidget {
  const latestarrivalwidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productmodel = Provider.of<ProductModel>(context);
    final wishlist_Provider = Provider.of<wishlistProvider>(context);
    final cartprovider = Provider.of<CartProvider>(context);
    final viewedrecentlyprovider = Provider.of<ViewedRecentlyProvider>(context);

    Size size = MediaQuery.of(context).size;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        viewedrecentlyprovider.addProductToHistory(
            productid: productmodel.productId);
        Navigator.of(context)
            .pushNamed(productdetails.route, arguments: productmodel.productId);
      },
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: size.width * 0.30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FancyShimmerImage(
                        width: size.width * 0.20,
                        height: size.width * 0.23,
                        imageUrl: productmodel.productImage),
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productmodel.productTitle,
                          style: TextStyle(fontSize: 8),
                          maxLines: 2,
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            HeartButtonWidget(
                                productid: productmodel.productId),
                            IconButton(
                                onPressed: () async {
                                  if (cartprovider.IsProductInCart(
                                      productid: productmodel.productId)) {
                                    return;
                                  }
                                  try {
                                    await cartprovider.addtocartfirebase(
                                        productid: productmodel.productId,
                                        quantity: 1,
                                        context: context);
                                  } catch (e) {
                                    MyappMethods.ShowErrorOrWarningDialog(
                                        context: context,
                                        subtitle: e.toString(),
                                        function: () {});
                                  }
                                },
                                icon: cartprovider.IsProductInCart(
                                        productid: productmodel.productId)
                                    ? Icon(Icons.check)
                                    : Icon(
                                        Icons.add_shopping_cart,
                                        size: 18,
                                      )),
                          ],
                        ),
                      ),
                      FittedBox(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${productmodel.productPrice}\$",
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      )),
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

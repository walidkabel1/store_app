import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/providers/viewedRecentlr_provider.dart';
import 'package:store_app/innerScreens/product_details.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/heart_btn.dart';
import 'package:store_app/widgets/title_text.dart';

class productwidget extends StatelessWidget {
  const productwidget({super.key, required this.productid});
  final String productid;
  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);
    final cartprovider = Provider.of<CartProvider>(context);
    final viewedrecentlyprovider = Provider.of<ViewedRecentlyProvider>(context);

    final getcurrentproduct =
        productprovider.FindByProductId(productid: productid);
    Size size = MediaQuery.of(context).size;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        viewedrecentlyprovider.addProductToHistory(
            productid: getcurrentproduct!.productId);
        Navigator.of(context)
            .pushNamed(productdetails.route, arguments: productid);
      },
      child: getcurrentproduct == null
          ? SizedBox.shrink()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: FancyShimmerImage(
                      width: double.infinity,
                      height: size.height * 0.25,
                      imageUrl: getcurrentproduct.productImage,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: TitleTextWidget(
                          label: getcurrentproduct.productTitle,
                          maxlines: 2,
                        ),
                      ),
                      Flexible(
                          child: HeartButtonWidget(
                        productid: getcurrentproduct.productId,
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TitleTextWidget(
                          label: "${getcurrentproduct.productPrice}\$",
                          color: Colors.red,
                        ),
                      ),
                      Flexible(
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlue,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              if (cartprovider.IsProductInCart(
                                  productid: getcurrentproduct.productId)) {
                                return;
                              }
                              try {
                                await cartprovider.addtocartfirebase(
                                    productid: getcurrentproduct.productId,
                                    quantity: 1,
                                    context: context);
                              } catch (e) {
                                MyappMethods.ShowErrorOrWarningDialog(
                                    context: context,
                                    subtitle: e.toString(),
                                    function: () {});
                              }
                              // cartprovider.addProductToCart(
                              //     productid: productid);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: cartprovider.IsProductInCart(
                                      productid: productid)
                                  ? Icon(Icons.check)
                                  : Icon(
                                      Icons.add_shopping_cart,
                                      size: 18,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

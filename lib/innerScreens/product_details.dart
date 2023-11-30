import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/heart_btn.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

class productdetails extends StatefulWidget {
  const productdetails({super.key});
  static const route = '/productdetails';
  @override
  State<productdetails> createState() => _productdetailssState();
}

class _productdetailssState extends State<productdetails> {
  @override
  Widget build(BuildContext context) {
    String productid = ModalRoute.of(context)!.settings.arguments as String;
    final productprovider = Provider.of<ProductProvider>(context);
    final cartprovider = Provider.of<CartProvider>(context);

    final getcurrentproduct =
        productprovider.FindByProductId(productid: productid);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: TitleTextWidget(label: "ShopSmart"),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_basket_rounded,
                color: Colors.lightBlue,
              ))
        ],
      ),
      body: getcurrentproduct == null
          ? SizedBox.shrink()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: FancyShimmerImage(
                          width: double.infinity,
                          height: size.height * 0.35,
                          imageUrl: getcurrentproduct.productImage)),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: 280,
                          child: TitleTextWidget(
                            fontStyle: FontStyle.italic,
                            label: getcurrentproduct.productTitle,
                            maxlines: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TitleTextWidget(
                          label: "${getcurrentproduct.productPrice}\$",
                          color: Colors.lightBlue,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Row(
                    children: [
                      Material(
                        color: Color.fromARGB(255, 116, 235, 164),
                        shape: CircleBorder(),
                        child: HeartButtonWidget(
                            productid: getcurrentproduct.productId),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 146, 7, 7),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(40))),
                            onPressed: () async {
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
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    Icon(cartprovider.IsProductInCart(
                                            productid: productid)
                                        ? Icons.check
                                        : Icons.add_shopping_cart),
                                    SizedBox(
                                      width: 35,
                                    ),
                                    cartprovider.IsProductInCart(
                                            productid: productid)
                                        ? TitleTextWidget(
                                            label: "Already Added to cart")
                                        : TitleTextWidget(label: "Add to cart")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            TitleTextWidget(label: getcurrentproduct.productId),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: subTitleTextWidget(
                            label: getcurrentproduct.productCategory),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TitleTextWidget(
                    label: getcurrentproduct.productDescription,
                    maxlines: 8,
                  ),
                )
              ],
            ),
    );
  }
}

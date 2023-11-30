import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/cart/bottom_checkout.dart';
import 'package:store_app/cart/quantity_btm.dart';
import 'package:store_app/widgets/heart_btn.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

class filledcartwidget extends StatelessWidget {
  const filledcartwidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);
    final cartmodelprovider = Provider.of<cartmodel>(context);
    final cart_provider = Provider.of<CartProvider>(context);

    final getcurrentproduct =
        productprovider.FindByProductId(productid: cartmodelprovider.productid);
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: getcurrentproduct!.productImage,
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              IntrinsicWidth(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.6,
                          child: TitleTextWidget(
                            label: getcurrentproduct.productTitle,
                            maxlines: 2,
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                cart_provider.removeitemfromcartfirebase(
                                    productid: getcurrentproduct.productId,
                                    cartid: cartmodelprovider.cartid,
                                    quantity: cartmodelprovider.quantity);
                                // cart_provider.deleteproduct(
                                //     productid: cartmodelprovider.productid);
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                            HeartButtonWidget(
                                productid: getcurrentproduct.productId),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subTitleTextWidget(
                          label: "${getcurrentproduct.productPrice}\$",
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return quantitybutton(
                                  cart_model: cartmodelprovider,
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.arrow_downward),
                          label: Text("Qty: ${cartmodelprovider.quantity} "),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

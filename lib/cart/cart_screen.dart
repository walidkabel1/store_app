import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:store_app/cart/bottom_checkout.dart';
import 'package:store_app/cart/empty_cartwidget.dart';
import 'package:store_app/cart/filled_cartwidget.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/providers/user_provider.dart';
import 'package:store_app/screens/loading_manger.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:store_app/widgets/title_text.dart';
import 'package:uuid/uuid.dart';

class cartpage extends StatefulWidget {
  const cartpage({super.key});

  @override
  State<cartpage> createState() => _cartpageState();
}

// ignore: camel_case_types
class _cartpageState extends State<cartpage> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final cartprovider = Provider.of<CartProvider>(context);
    final productprovider = Provider.of<ProductProvider>(context);
    final userprovider = Provider.of<UserProvider>(context);

    Size size = MediaQuery.of(context).size;
    return cartprovider.getcartitems.isEmpty
        ? cartwidget(
            imagepath: assetsManager.shoppingbasket,
            subtitle:
                'Looks like you have not added any thing to your cart , Go ahead & Explore top categories',
            title: 'Your Cart Is Empty')
        : LoadingManger(
            isloading: isloading,
            child: Scaffold(
                bottomSheet: Ckeckoutwidget(
                  function: () async {
                    await placeOrder(
                        productProvider: productprovider,
                        cartProvider: cartprovider,
                        userProvider: userprovider);
                  },
                ),
                appBar: AppBar(
                  actions: [
                    IconButton(
                        onPressed: () {
                          MyappMethods.ShowErrorOrWarningDialog(
                              iserror: false,
                              context: context,
                              subtitle: "remove items",
                              function: () {
                                cartprovider.clearcartfromfirebase();
                                Navigator.pop(context);
                              });
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ))
                  ],
                  title: TitleTextWidget(
                    label:
                        'cart (${cartprovider.getcartitems.length.toString()})',
                  ),
                  leading: Image.asset(assetsManager.shoppingcart),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: cartprovider.getcartitems.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                                value: cartprovider.getcartitems.values
                                    .toList()
                                    .reversed
                                    .toList()[index],
                                child: const filledcartwidget());
                          }),
                    ),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                )),
          );
  }

  Future<void> placeOrder(
      {required ProductProvider productProvider,
      required CartProvider cartProvider,
      required UserProvider userProvider}) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isloading = true;
      });
      cartProvider.getcartitems.forEach((key, value) async {
        final getcurrentproduct =
            productProvider.FindByProductId(productid: value.productid);
        final orderid = const Uuid().v4();
        await FirebaseFirestore.instance.collection("orders").doc(orderid).set({
          "userId": uid,
          "orderid": orderid,
          "productTitle": getcurrentproduct!.productTitle,
          "productPrice":
              double.parse(getcurrentproduct.productPrice) * value.quantity,
          "username": userProvider.getUserModel!.username,
          "productid": value.productid,
          "productImage": getcurrentproduct.productImage,
          "productQuantity": value.quantity,
          "ordertime": Timestamp.now(),
          "totalprice":
              cartProvider.CheckOutPrice(productprovider: productProvider)
        });
      });
    } catch (e) {
      MyappMethods.ShowErrorOrWarningDialog(
          context: context, subtitle: e.toString(), function: () {});
    } finally {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: "Order has been submitted ");
      cartProvider.clearcart();
    }
  }
}

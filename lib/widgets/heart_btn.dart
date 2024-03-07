import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/services/myapp_methods.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productid,
  });
  final double size;
  final Color color;
  final String productid;
  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

bool isloading = false;

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final wishListprovider = Provider.of<WishlistProvider>(context);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: IconButton(
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
          ),
          onPressed: () async {
            setState(() {
              isloading = true;
            });
            try {
              if (wishListprovider.getwishlistitems
                  .containsKey(widget.productid)) {
                wishListprovider.removeitemfromwishlistfirebase(
                    productid: widget.productid,
                    wishlistid: wishListprovider
                        .getwishlistitems[widget.productid]!.wishlistid);
              } else {
                wishListprovider.addtowishlistfirebase(
                    productid: widget.productid, context: context);
              }
              await wishListprovider.fetchwishlist();
            } catch (e) {
              MyappMethods.ShowErrorOrWarningDialog(
                  context: context, subtitle: e.toString(), function: () {});
            } finally {
              setState(() {
                isloading = false;
              });
            }
            // wish_listprovider.addOrRemoveProducttowishlist(
            //     productid: widget.productid);
          },
          icon: isloading
              ? CircularProgressIndicator()
              : Icon(wishListprovider.IsProductInwishlist(
                      productid: widget.productid)
                  ? IconlyBold.heart
                  : IconlyLight.heart),
          color:
              wishListprovider.IsProductInwishlist(productid: widget.productid)
                  ? Colors.red
                  : Colors.grey),
    );
  }
}

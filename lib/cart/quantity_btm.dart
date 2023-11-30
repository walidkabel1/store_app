import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/widgets/subtitle_text.dart';

class quantitybutton extends StatelessWidget {
  const quantitybutton({super.key, required this.cart_model});
  final cartmodel cart_model;

  @override
  Widget build(BuildContext context) {
    final cartprovider = Provider.of<CartProvider>(context);

    return Column(
      children: [
        Container(
            height: 6,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(12))),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          cartprovider.UpdateQuantity(
                              productid: cart_model.productid,
                              quantity: index + 1);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: subTitleTextWidget(label: "${index + 1}"),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        )),
      ],
    );
  }
}

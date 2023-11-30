import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

class Ckeckoutwidget extends StatelessWidget {
  const Ckeckoutwidget({super.key, required this.function});
  final Function function;
  @override
  Widget build(BuildContext context) {
    final cart_provider = Provider.of<CartProvider>(context);
    final productprovider = Provider.of<ProductProvider>(context);

    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Colors.grey))),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  children: [
                    FittedBox(
                        child: TitleTextWidget(
                            label: "Total (6 Products/ 6 Items)")),
                    subTitleTextWidget(
                      label:
                          "${cart_provider.CheckOutPrice(productprovider: productprovider).toInt()} \$ ",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await function();
                  },
                  child: subTitleTextWidget(label: 'Check Out'))
            ],
          ),
        ),
      ),
    );
  }
}

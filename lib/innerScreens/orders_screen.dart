import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/cart/empty_cartwidget.dart';
import 'package:store_app/models/order_model.dart';
import 'package:store_app/providers/orders_provider.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/widgets/orders_widget.dart';
import 'package:store_app/widgets/title_text.dart';

class OrdersScreen extends StatefulWidget {
  static const route = "/OrdersScreen";
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final orderprovider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(label: "Placed Orders"),
      ),
      body: FutureBuilder<List<OrderModel>>(
          future: orderprovider.fetchorders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: SelectableText(
                    "an error has been occured ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || orderprovider.getorders.isEmpty) {
              return cartwidget(
                imagepath: assetsManager.order,
                subtitle: "",
                title: "No orders has been placed yet",
              );
            }
            return ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: OrdersWidgetFree(
                        orderModel: orderprovider.getorders[index]),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemCount: snapshot.data!.length);
          }),
    );
  }
}

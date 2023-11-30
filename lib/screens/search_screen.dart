import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/products_model.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/products/product_widget.dart';
import 'package:store_app/widgets/title_text.dart';

class searchpage extends StatefulWidget {
  searchpage({super.key});

  @override
  static const route = '/searchpage';
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  late TextEditingController searchtextcontroller;
  List<ProductModel> searchlist = [];

  @override
  void initState() {
    searchtextcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchtextcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);
    String? passedcategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productslist = passedcategory == null
        ? productprovider.getproducts
        : productprovider.FindBycategory(categoryname: passedcategory);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
            label: passedcategory == null ? "search screen" : passedcategory,
          ),
          leading: Image.asset(assetsManager.shoppingcart),
        ),
        body: productslist.isEmpty
            ? Center(
                child: Text("no products found"),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: searchtextcontroller,
                      decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: IconButton(
                              onPressed: () {
                                searchtextcontroller.clear();
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.red,
                              )),
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: Colors.lightBlue,
                              ))),
                      onChanged: (value) {
                        setState(() {
                          searchlist = productprovider.searchquery(
                              passedlist: productslist,
                              searchtext: searchtextcontroller.text);
                        });
                      },
                    ),
                  ),
                  if (searchtextcontroller.text.isNotEmpty &&
                      searchlist.isEmpty) ...[
                    Center(
                      child: Text("no products found"),
                    )
                  ],
                  Expanded(
                      child: DynamicHeightGridView(
                          builder: (context, index) {
                            return productwidget(
                              productid: searchtextcontroller.text.isNotEmpty
                                  ? searchlist[index].productId
                                  : productslist[index].productId,
                            );
                          },
                          itemCount: searchtextcontroller.text.isNotEmpty
                              ? searchlist.length
                              : productslist.length,
                          crossAxisCount: 2))
                ],
              ),
      ),
    );
  }
}

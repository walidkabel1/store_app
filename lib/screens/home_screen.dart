import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/constants/constants.dart';
import 'package:store_app/products/category_widget.dart';
import 'package:store_app/products/latest_arrival.dart';
import 'package:store_app/widgets/title_text.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
            label: 'Home Screen',
          ),
          leading: Image.asset(assetsManager.shoppingcart),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Swiper(
                    autoplay: true,
                    pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotSwiperPaginationBuilder(color: Colors.red)),
                    control: SwiperControl(),
                    itemCount: constants.bannerslist.length,
                    itemBuilder: (context, index) {
                      return Image.asset(constants.bannerslist[index]);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleTextWidget(
                  label: "Latest arrival",
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productprovider.getproducts.length < 10
                      ? productprovider.getproducts.length
                      : 10,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                        value: productprovider.getproducts[index],
                        child: latestarrivalwidget());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleTextWidget(
                  label: "Categories",
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children:
                    List.generate(constants.categorieslist.length, (index) {
                  return categorywidget(
                      image: constants.categorieslist[index].image,
                      name: constants.categorieslist[index].name);
                }),
              )
            ],
          ),
        ));
  }
}

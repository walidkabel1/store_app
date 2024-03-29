import 'package:flutter/material.dart';
import 'package:store_app/screens/search_screen.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

// ignore: camel_case_types, must_be_immutable
class cartwidget extends StatelessWidget {
  cartwidget(
      {super.key,
      required this.imagepath,
      required this.subtitle,
      required this.title});
  String imagepath, title, subtitle;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              imagepath,
              height: size.height * 0.40,
              width: double.infinity,
            ),
            const TitleTextWidget(
              label: "Whoops!",
              fontSize: 40,
              color: Colors.red,
            ),
            const SizedBox(
              height: 30,
            ),
            subTitleTextWidget(
              label: title,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TitleTextWidget(
                maxlines: 3,
                label: subtitle,
                fontSize: 17,
              ),
            ),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: () {
                  Navigator.of(context).pushNamed(searchpage.route);
                },
                child: const subTitleTextWidget(
                  label: "Shop now",
                  fontSize: 20,
                ))
          ],
        ),
      ),
    );
  }
}

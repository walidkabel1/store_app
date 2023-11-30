import 'package:flutter/material.dart';
import 'package:store_app/screens/search_screen.dart';

class categorywidget extends StatelessWidget {
  categorywidget({required this.image, required this.name, super.key});
  final String name, image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(searchpage.route, arguments: name);
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 40,
            width: 40,
          ),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }
}

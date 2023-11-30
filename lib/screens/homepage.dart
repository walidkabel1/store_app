import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/theme_provider.dart';

class homepages extends StatelessWidget {
  const homepages({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProviders = Provider.of<themeProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "hello world",
            style: TextStyle(fontSize: 60),
          ),
          SwitchListTile(
              title: Text(
                  themeProviders.getIsDarkTheme ? "Dart Theme" : "light Theme"),
              value: themeProviders.getIsDarkTheme,
              onChanged: (value) {
                themeProviders.setDarkTheme(themevalue: value);
              })
        ],
      ),
    );
  }
}

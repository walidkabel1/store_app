import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class themeProvider with ChangeNotifier {
  static const THEMESTATUS = "theame status";
  bool _darktheme = false;
  bool get getIsDarkTheme => _darktheme;
  themeProvider() {
    getThemeDark();
  }

  Future<void> setDarkTheme({required bool themevalue}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(THEMESTATUS, themevalue);
    _darktheme = themevalue;
    notifyListeners();
  }

  Future<bool> getThemeDark() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _darktheme = pref.getBool(THEMESTATUS) ?? false;
    notifyListeners();
    return _darktheme;
  }
}

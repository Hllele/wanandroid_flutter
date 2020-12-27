import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter2/page/tab_navigation.dart';
import 'package:wanandroid_flutter2/res/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  int themeIndex = await getTheme();
  runApp(MyApp(
    themeIndex: themeIndex,
  ));
}

Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int themeIndex = sp.getInt("themeIndex");
  return themeIndex == null ? 6 : themeIndex;
}

class MyApp extends StatelessWidget {
  final int themeIndex;

  const MyApp({Key key, this.themeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wanandroid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: WColors.themeColor[themeIndex]["primaryColor"],
        primaryColorDark: WColors.themeColor[themeIndex]["primaryColorDark"],
        accentColor: WColors.themeColor[themeIndex]["colorAccent"]
      ),
      home: TabNavigation(),
    );
  }
}


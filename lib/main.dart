
import 'package:ecommerce_int2/screens/splash_page.dart';
import 'package:flutter/material.dart';
import '../../db_helper.dart';



// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.debugDbInfo(); // <-- prints path/tables/row counts
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHOP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.transparent,
        primarySwatch: Colors.pink,
        fontFamily: "Montserrat",
      ),
      home: SplashScreen(),
    );
  }
}



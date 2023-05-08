import 'package:flutter/material.dart';
import 'package:my_app/utils/routes.dart';
import 'package:my_app/pages/login_page.dart';

void main(List<String> args) => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepPurple)),
        ),
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      initialRoute: MyRoutes.loginRoute,
      routes: {
        MyRoutes.loginRoute: (context) => const LoginPage(),
      },
    );
  }
}

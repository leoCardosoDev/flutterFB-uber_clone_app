import 'package:flutter/material.dart';
import 'package:ubercloneapp/routes/routes.dart';
import 'package:ubercloneapp/screens/home_screen.dart';

final ThemeData _themeData = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a),
);

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "Uber Clone",
  initialRoute: '/',
  theme: _themeData,
  onGenerateRoute: Routes.generateRoutes,
  home: HomeScreen(),
));
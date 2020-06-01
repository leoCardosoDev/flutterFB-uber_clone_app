import 'package:flutter/material.dart';
import 'package:ubercloneapp/screens/driver_panel.dart';
import 'package:ubercloneapp/screens/home_screen.dart';
import 'package:ubercloneapp/screens/passeger_panel.dart';
import 'package:ubercloneapp/screens/register_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;

      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
        break;
  
      case '/passager':
        return MaterialPageRoute(builder: (_) => PassegerPanel());
        break;
  
      case '/driver':
        return MaterialPageRoute(builder: (_) => DriverPanel());
        break;
  
  
  
      default:
        _errorRoute();
    }
  }
  
  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text('Tela não encontrada!'),
          ),
          body: Center(
            child: Text('Tela não encontrada!'),
          ),
        );
      }
    );
  }
}

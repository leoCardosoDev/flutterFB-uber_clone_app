import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverPanel extends StatefulWidget {
  @override
  _DriverPanelState createState() => _DriverPanelState();
}

class _DriverPanelState extends State<DriverPanel> {
 
 Future _userSignOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
  Navigator.pushReplacementNamed(context, '/');
 }
 
 List<String> itemsMenu = ['Configurações', 'Sair'];
 void _chooseMenuItem(String choose){
  switch(choose){
   case 'Sair':
    _userSignOut();
    break;
  }
 }
 
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text('Painel do Motorista'),
     actions: <Widget>[
      PopupMenuButton<String>(
       onSelected: _chooseMenuItem,
       itemBuilder: (context){
        return itemsMenu.map((String item){
         return PopupMenuItem<String>(
          value: item,
          child: Text(item),
         );
        }).toList();
       },
      ),
     ],
    ),
    body: Container(),
   );
  }
}



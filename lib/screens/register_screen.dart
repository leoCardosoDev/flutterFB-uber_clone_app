import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubercloneapp/models/users.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _erromsg = '';

  bool _typeUser = false;

  void _validateFields() {
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    if (name.isNotEmpty) {
      if (email.isNotEmpty && email.contains('@')) {
        if (password.isNotEmpty && password.length >= 6) {
          User user = User();
          user.name = name;
          user.email = email;
          user.password = password;
          user.typeUser = user.verifyUserType(_typeUser);
          _registerUser(user);
        } else {
          setState(() {
            _erromsg = "A senha precisa conter no minimo 6 caracteres";
          });
        }
      } else {
        setState(() {
          _erromsg = "Digite um E-mail válido";
        });
      }
    } else {
      setState(() {
        _erromsg = "Nome não pode ser vazio";
      });
    }
  }

  void _registerUser(User user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore _db = Firestore.instance;

    auth
        .createUserWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      _db.collection('users').document(firebaseUser.user.uid).setData(user.toMap());
      
      switch(user.typeUser){
       case 'motorista':
        Navigator.pushNamedAndRemoveUntil(context, '/driver', (_) => false);
        break;
       case 'passageiro':
        Navigator.pushNamedAndRemoveUntil(context, '/passager', (_) => false);
        break;
      }
    }).catchError((error){
      _erromsg = "Erro ao Cadastrar.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Nome Completo',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                   keyboardType: TextInputType.emailAddress,
                    controller: _controllerEmail,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                   obscureText: true,
                    controller: _controllerPassword,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text('Passageiro'),
                      Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: _typeUser,
                        onChanged: (bool value) {
                          setState(() {
                            _typeUser = value;
                          });
                        },
                      ),
                      Text('Motorista'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        _validateFields();
                      },
                      child: Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _erromsg,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

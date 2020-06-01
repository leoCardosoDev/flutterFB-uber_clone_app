import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubercloneapp/models/users.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String _erromsg = '';
  bool _isLoading = false;

  void _validateFields() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    
    setState(() {
      _isLoading = true;
    });

      if (email.isNotEmpty && email.contains('@')) {
        if (password.isNotEmpty && password.length >= 6) {
          User user = User();
          user.email = email;
          user.password = password;
          _loginUser(user);
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
  }
  
  void _loginUser(User user){
    auth.signInWithEmailAndPassword(email: user.email, password: user.password).then(
        (firebaseUser){
          _redirectPanelByUserType(firebaseUser.user.uid);
        })
      .catchError((error){
      _erromsg = "Erro ao logar. Verifique se e-mail ou senha estão corretos.";
    });
  }
  
  Future _redirectPanelByUserType(String uid)async{
   Firestore db = Firestore.instance;
   
   DocumentSnapshot snapshot = await db.collection('users').document(uid).get();
   Map<String, dynamic> data = snapshot.data;
   String userType = data['typeUser'];
   
   setState(() {
     _isLoading = false;
   });
   
   if(userType == 'passageiro')
    Navigator.pushReplacementNamed(context, '/passager');
   else
    Navigator.pushReplacementNamed(context, '/driver');
  }
  
  Future _verifyUserSignIn() async {
   FirebaseUser userSignIn = await auth.currentUser();
   if(userSignIn != null){
    String uid = userSignIn.uid;
    _redirectPanelByUserType(uid);
   }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyUserSignIn();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fundo.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 22),
                  child: Image.asset(
                    'images/logo.png',
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                      hintText: 'E-mail',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    controller: _controllerPassword,
                    obscureText: true,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                      hintText: 'Senha',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
                        'Entrar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                     Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Não tem conta? Cadastre-se!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
               Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                 child: Text(_erromsg, style: TextStyle(color: Colors.red, fontSize: 14),),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ubercloneapp/models/users.dart';

class UserFirebase{
 
 
 static Future<FirebaseUser> getCurrentUser() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  return await auth.currentUser();
 }

 static Future<User> getDataUser() async {
  FirebaseUser firebaseUser = await getCurrentUser();
  String uid = firebaseUser.uid;
  
  Firestore db = Firestore.instance;
  DocumentSnapshot snapshot = await db.collection('users').document(uid).get();
  Map<String, dynamic> datas = snapshot.data;
  String typeUser = datas['typeUser'];
  String email = datas['email'];
  String name = datas['name'];
  
  User user = User();
  user.uid = uid;
  user.name = name;
  user.email = email;
  user.typeUser = typeUser;
  
  return user;
 }
 
}
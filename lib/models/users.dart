class User{
 String _uid;
 String _name;
 String _email;
 String _password;
 String _typeUser;

 User();
 
 Map<String, dynamic> toMap(){
  Map<String, dynamic> map = {
   'name' : this.name,
   'email': this.email,
   'typeUser': this.typeUser
  };
  return map;
 }
 
 String verifyUserType(bool typeUser){
  return typeUser ? 'motorista' : 'passageiro';
 }

 String get typeUser => _typeUser;

  set typeUser(String value) {
    _typeUser = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }
}
import 'package:ubercloneapp/models/destiny.dart';
import 'package:ubercloneapp/models/users.dart';

class Requisition{
 
 String _id;
 String _status;
 User _passager;
 User _driver;
 Destiny _destiny;
 
 Requisition();

 Map<String, dynamic> toMap(){
 
  Map<String, dynamic> passager = {
   'name' : this.passager.name,
   'email': this.passager.email,
   'typeUser': this.passager.typeUser,
   'uid': this.passager.uid,
  };

  Map<String, dynamic> destiny = {
   'street' : this.destiny.street,
   'number' : this.destiny.number,
   'neig' : this.destiny.neig,
   'zipCode' : this.destiny.zipCode,
   'lat' : this.destiny.lat,
   'lon' : this.destiny.lon,
  };
  
  Map<String, dynamic> dataRequisition = {
   'status' : this.status,
   'passager': passager,
   'driver': null,
   'destiny': destiny
  };
  return dataRequisition;
 }

 Destiny get destiny => _destiny;

  set destiny(Destiny value) {
    _destiny = value;
  }

  User get driver => _driver;

  set driver(User value) {
    _driver = value;
  }

  User get passager => _passager;

  set passager(User value) {
    _passager = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}

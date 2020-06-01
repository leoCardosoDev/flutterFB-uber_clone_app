import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubercloneapp/models/destiny.dart';
import 'package:ubercloneapp/models/requisition.dart';
import 'package:ubercloneapp/models/users.dart';
import 'package:ubercloneapp/utils/status_requisition.dart';
import 'package:ubercloneapp/utils/user_firebase.dart';

class PassegerPanel extends StatefulWidget {
  @override
  _PassegerPanelState createState() => _PassegerPanelState();
}

class _PassegerPanelState extends State<PassegerPanel> {
  TextEditingController _destinyController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _cameraPosition = CameraPosition(target: LatLng(-23.486626, -46.895216));

  Set<Marker> _markes = {};
  
  bool _showBoxDestiny = true;
  String _txtBtn;
  Color _colorBtn;
  Function _functionBtn;

  void _callUber() async {
    String destinyAddress = _destinyController.text;

    if (destinyAddress.isNotEmpty) {
      List<Placemark> addressList = await Geolocator().placemarkFromAddress(destinyAddress);

      if (addressList != null && addressList.length > 0) {
        Placemark address = addressList[0];
        Destiny destiny = Destiny();

        destiny.city = address.administrativeArea;
        destiny.zipCode = address.postalCode;
        destiny.neig = address.subLocality;
        destiny.street = address.thoroughfare;
        destiny.number = address.subThoroughfare;

        destiny.lat = address.position.latitude;
        destiny.lon = address.position.longitude;

        String confirmedAddress;
        confirmedAddress = "\n Cidade: " + destiny.city;
        confirmedAddress += "\n Rua: " + destiny.street + ", " + destiny.number;
        confirmedAddress += "\n Bairro: " + destiny.neig;
        confirmedAddress += "\n Cep: " + destiny.zipCode;

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Confirmação do endereço'),
                content: Text(confirmedAddress),
                contentPadding: EdgeInsets.all(16),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text(
                      'Confirmar',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      _saveReq(destiny);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  void _saveReq(Destiny destiny) async {
    User passager = await UserFirebase.getDataUser();
    Requisition requisition = Requisition();
    requisition.destiny = destiny;
    requisition.passager = passager;
    requisition.status = StatusRequisition.AGUARDANDO;
    
    Firestore db = Firestore.instance;
    db.collection('requisition').add(requisition.toMap());
    
    _statusUberWaiting();
    
  }

  Future _userSignOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  List<String> itemsMenu = ['Configurações', 'Sair'];
  void _chooseMenuItem(String choose) {
    switch (choose) {
      case 'Sair':
        _userSignOut();
        break;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _addListenerLocation() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _showMarker(position);

      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      _moveCamera(_cameraPosition);
    });
  }

  Future _recoveryLastLocation() async {
    Position position =
        await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _showMarker(position);
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        _moveCamera(_cameraPosition);
      }
    });
  }

  Future _moveCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _showMarker(Position position) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio), 'images/passageiro.png')
        .then((BitmapDescriptor icon) {
      Marker markersPassager = Marker(
          markerId: MarkerId('marker-passeger'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "Meu Local"),
          icon: icon);

      setState(() {
        _markes.add(markersPassager);
      });
    });
  }
  
  void _cancelUber(){}
  
  void _changeBtnText(String txt, Color color, Function function){
    setState(() {
      _txtBtn = txt;
      _colorBtn = color;
      _functionBtn = function;
    });
  }
  
  void _statusUberCall(){
    _showBoxDestiny = true;
    _changeBtnText('Chamar Uber', Color(0xff37474f), (){_callUber();});
  }

  void _statusUberWaiting(){
    _showBoxDestiny = false;
    _changeBtnText('Cancelar Corrida', Colors.red, (){_cancelUber();});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recoveryLastLocation();
    _addListenerLocation();
    _statusUberCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel do Passageiro'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _chooseMenuItem,
            itemBuilder: (context) {
              return itemsMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _cameraPosition,
                onMapCreated: _onMapCreated,
                markers: _markes,
                //myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
              Visibility(
                visible: _showBoxDestiny ,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 20, bottom: 15),
                                width: 10,
                                height: 10,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                )),
                              hintText: 'Meu Local',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: _destinyController,
                            decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 20, bottom: 15),
                                width: 10,
                                height: 10,
                                child: Icon(
                                  Icons.local_taxi,
                                  color: Colors.black,
                                )),
                              hintText: 'Digite o Destino',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Padding(
                  padding:
                      Platform.isIOS ? EdgeInsets.fromLTRB(20, 10, 20, 25) : EdgeInsets.all(10),
                  child: SizedBox(
                    height: 50,
                    child: RaisedButton(
                      onPressed: _functionBtn,
                      child: Text(
                        _txtBtn,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: _colorBtn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

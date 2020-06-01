class Destiny {
 String _street;
 String _number;
 String _city;
 String _neig;
 String _zipCode;
 double _lat;
 double _lon;

 Destiny();

 double get lon => _lon;

  set lon(double value) {
    _lon = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }

  String get zipCode => _zipCode;

  set zipCode(String value) {
    _zipCode = value;
  }

  String get neig => _neig;

  set neig(String value) {
    _neig = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get number => _number;

  set number(String value) {
    _number = value;
  }

  String get street => _street;

  set street(String value) {
    _street = value;
  }
}
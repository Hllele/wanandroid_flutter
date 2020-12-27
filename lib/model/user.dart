

class User{
  static final User singleton = User._internal();

  factory User(){
    return singleton;
  }

  User._internal();

  List<String> cookie;
  String userName;



}
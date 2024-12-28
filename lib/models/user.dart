class User {
  late final String token;
  User._User();
  static User? _user;

  factory User() {
    if (_user == null) {
      _user = User._User();
    }
    return _user!;
  }
  void settoken(String token) {
    _user!.token = token;
  }

  String gettoken() {
    return token;
  }
}

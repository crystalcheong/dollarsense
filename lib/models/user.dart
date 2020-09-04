class CurrentUser {
  final String uid;

  ///Constructor
  CurrentUser({this.uid});
}

class UserData {
  final String uid;
  final String fullName;
  final String email;
  final String avatar;

  UserData({this.uid, this.fullName, this.email, this.avatar = ''});
}

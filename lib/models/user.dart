class User{

  final String uid;

  ///Constructor
  User({ this.uid });
}

class UserData{

  final String uid;
  final String fullName;
  final String email;
  final String avatar;

  UserData({ this.uid, this.fullName, this.email, this.avatar='' });

}
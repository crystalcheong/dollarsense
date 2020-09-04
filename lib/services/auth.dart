import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';
import '../models/budget.dart';
import '../models/user.dart';

class AuthService {
  ///Create user object based on FirebaseUser
  CurrentUser _userFromFirebaseUser(FirebaseUser user) {
    //Create User based if FirebaseUser != null else return null
    return user != null ? CurrentUser(uid: user.uid) : null;
  }

  //[1] Initialise an instance of FirebaseAuth class
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Auth change user stream when there is change in state
  Stream<CurrentUser> get user {
    //Map a FirebaseUser into custom defined User object
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser); //Same as the below (shorthand syntax)
    // .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  ///sign in anonymously (ASYNC)
  Future signInAnonymous() async {
    try {
      //[2] Request Firebase to sign in user
      AuthResult result = await _auth.signInAnonymously();
      //[3] Fetch the current signed-in user
      FirebaseUser user = result.user;
      //[4] Return custom User object from models/user.dart
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///register with email and password
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      FirebaseUser user = result.user;

      //Create user document in Firestore
      await DatabaseService(uid: user.uid)
          .updateUserData(fullName, email.trim());
      await DatabaseService(uid: user.uid).createTransactionList();
      await DatabaseService(uid: user.uid)
          .updateBudget(new Budget(month: 0, limit: 0.0));

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///sign out <ASYNC>
  Future signOut() async {
    try {
      //Use signOut() from Firebase
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///delete <ASYNC>
  Future deleteUser(String email, String password) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      AuthCredential credentials = EmailAuthProvider.getCredential(
          email: email.trim(), password: password);
      print("FIREBASEUSER : $user");
      AuthResult result = await user?.reauthenticateWithCredential(credentials);
      print("CREDENTIALS : $credentials");
      await DatabaseService(uid: result.user.uid)
          .deleteUserData(); // called from database class
      await DatabaseService(uid: result.user.uid)
          .deleteUserTransactions(); // called from database class
      await DatabaseService(uid: result.user.uid)
          .deleteBudget(); // called from database class
      await result.user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateUser(UserData userData, String password, String newFullName,
      String newEmail) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      AuthCredential credentials = EmailAuthProvider.getCredential(
          email: userData.email, password: password);
      print("FIREBASEUSER : $user");
      AuthResult result = await user?.reauthenticateWithCredential(credentials);
      print("CREDENTIALS : $credentials");
      await DatabaseService(uid: result.user.uid).updateUserData(
          newFullName, newEmail,
          avatar: userData.avatar); // called from database class
      await result.user.updateEmail(newEmail);
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

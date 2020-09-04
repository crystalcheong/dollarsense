import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboard/onboard.dart';
import '../shared/navigation/nav_bar.dart';
import '../screens/authenticate/authenticate.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  final SharedPreferences sharedPrefs;
  Wrapper(this.sharedPrefs);

  @override
  Widget build(BuildContext context) {
    var initialLoad = sharedPrefs.getBool('initialLoad');
    print("PREFS RECEIVED FOR STATUS -> ${sharedPrefs.getBool('initialLoad')}");

    //Retrieve USER object from StreamProvider in main.dart
    final user = Provider.of<CurrentUser>(context);
    print(user);

    if (initialLoad) {
      return Onboard(sharedPrefs);
    } else {
      //Not logged in
      if (user == null) {
        return Authenticate();
      } else {
        return NavBarLayout(user: user);
      }
    }
  }
}

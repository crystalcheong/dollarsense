import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/loading.dart';
import './screens/wrapper.dart';
import './services/auth.dart';
import './models/user.dart';

void main() {
  // Ensure all plugins are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Apply application UI overlay (FULL SCREEN)
  SystemChrome.setEnabledSystemUIOverlays([]).then((_) {
    // Retrieve stored preferences before starting application
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
    sharedPrefs.then((prefs) {
      var initialLoad = prefs.getBool('initialLoad') ?? true;
      if (initialLoad) prefs.setBool('initialLoad', initialLoad);
      runApp(DollarSense(sharedPrefs: prefs));
    });
  });
}

class DollarSense extends StatelessWidget {
  final SharedPreferences sharedPrefs;
  DollarSense({this.sharedPrefs});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Restrict portrait mode only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // Retrieve User object from stream
          return StreamProvider<CurrentUser>.value(
            value: AuthService().user,

            //Application
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Wrapper(sharedPrefs),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

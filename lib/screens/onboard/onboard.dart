import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_onboarding_screen/flutter_onboarding.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

import '../wrapper.dart';
import '../../shared/theme.dart';

class Onboard extends StatefulWidget {

  final SharedPreferences sharedPrefs;
  Onboard(this.sharedPrefs);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {

  bool showOnboard = true;

  void toggleView(){
    //Toggles boolean value regardless of T/F
    setState(() => showOnboard = !showOnboard);

    if(!showOnboard){
      widget.sharedPrefs.setBool('initialLoad', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(showOnboard) return OnboardContent(toggleView: toggleView);
    else return Wrapper(widget.sharedPrefs);
  }
}

class OnboardContent extends StatelessWidget {

  final Function toggleView;
  OnboardContent({this.toggleView});

  final pages = [
    SkOnboardingModel(
        title: 'TRACK EXPENSES',
        description:
            'List down latest transactions ans set monthly budgets to keep track of your spending',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/track_expenses.png'),
    SkOnboardingModel(
        title: 'ALL-IN-ONE FINANCE',
        description:
            'We bring together everything to give you a clearer look at your finances',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/allinone_finance.png'),
    SkOnboardingModel(
        title: 'INTUITIVE GRAPHS',
        description: 'Visualize your monthly expenses to evalute and improve your spending habits',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/intuitive_graphs.png'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SKOnboardingScreen(
        bgColor: kBackground,
        themeColor: kPrimary,
        pages: pages,
        skipClicked: (value) {
          print("Skip");
          toggleView();
        },
        getStartedClicked: (value) {
          print("Get Started");
          toggleView();
        },
      ),
    );
  }
}
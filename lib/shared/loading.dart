import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackground,
      child: Center(
        child: SpinKitFoldingCube(
          color: kLightSecondary,
          size: 50.0,
        ),
      ),
    );
  }
}

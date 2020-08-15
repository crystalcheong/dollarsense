import 'package:flutter/material.dart';

import '../../shared/notification/alert_notification.dart';
import '../../shared/theme.dart';
import '../../data/globals.dart' as globals;

class Support extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;
  Support(this.scaffoldKey);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {

  //For form validation
  final _formKey = GlobalKey<FormState>(); 

  //Track form value
  String _message = '';

  @override
  Widget build(BuildContext context) {

    OverlayEntry entry;

    return Scaffold(key: widget.scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,

      appBar: AppBar(
        centerTitle: true,
        title: new Text("Contact Support", style: TextStyle(color: kDarkSecondary)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: kDarkSecondary),
            onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[

          IconButton(
            icon: Icon( Icons.send,
              color: kDarkSecondary,
            ),
            onPressed: () async {
              print("Message: $_message");

              if(_message.isEmpty){
                //Display error alert notification
                entry = alertOverlay(AlertNotification(text: 'Message sent cannot be empty!', color: Colors.red[400]));
                Navigator.of(globals.scaffoldKey.currentContext).overlay.insert(entry);
                overlayDuration(entry);
              }
              else{
                //Display success alert notification
                entry = alertOverlay(AlertNotification(text: 'Message sent!', color: Colors.deepPurple));
                Navigator.of(globals.scaffoldKey.currentContext).overlay.insert(entry);
                overlayDuration(entry, pop: true, ctxt: context);
              }
            },
          )

        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Text(
                "Got a feedback or experiencing problems? Write to us and we will get back to you as soon as possible!",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ),

            Divider( color: Colors.black ),

            Expanded(
              child: Form( key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    maxLines: 150,
                    keyboardType: TextInputType.multiline,
                    onChanged: (val){setState(() => _message = val);},
                    decoration: InputDecoration(
                      hintText: "Write a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ) 

          ],
      ),
    );
  }
}

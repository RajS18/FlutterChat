import 'package:chatapp/widgets/chats/messages.dart';
import 'package:chatapp/widgets/chats/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();//super.initState() should always run before the childs initState() implementation.
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions(); //for granting push notifications.
    fbm.configure(onMessage: (msg) {// fired when notification is sent while app is in the foreground
      print(msg);
      return;
    }, onLaunch: (msg) {// fired when notification is sent while app isshut down
      print(msg);
      return;
    }, onResume: (msg) {// fired when notification is sent while app is in the background (in RAM)
      print(msg);
      return;
    }); //
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Window'), actions: [
        DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          items: [
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Logout')
                  ],
                ),
              ),
              value:
                  'Logout', //act as an identifier for this particular DropDownMenuItem
            ),
          ],
          onChanged: (identifier) {
            //onclicking some button in items list of DropdownButton(), passing value as identifier
            //this value is same as items:value attribute.
            if (identifier == 'Logout') {
              FirebaseAuth.instance.signOut(); //to signOut from the app.
            }
          },
        ),
      ]),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              // because Messages will return a list view which will have h/w of column instead of full screen
              //without expanded.
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      //StreamBuilder->Creates a new [StreamBuilder] that builds itself based on the latest snapshot of interaction
//with the specified [stream] and whose build strategy is given by [builder].
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Firestore.instance
      //         .collection("/chats/nHqc8K9wsj9FxMRW9r1t/messages")
      //         .add({'text': 'This is the default add message'});
      //     //adding the map{} as value to provided collection with default documet ID.
      //   },
      //   backgroundColor: Colors.blue,
      //   splashColor: Colors.green,
      // ),
    );
  }
}

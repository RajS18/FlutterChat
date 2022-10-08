import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  void sendMessage() async {
    FocusScope.of(context).unfocus(); //make the keypad disappear.
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
        
    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'user_image': userData['image_url'], 
      //instead to solve the problem regarding displaying username on new message bubbles, we will instead store
      //username as well when sending the new message. So every time a new chat message is entered in FireStore
      //DB, we get to store username as well. and now Stream builder can directly pick up it from the chat collection.
    }); //add a new message row in the chat collection.
    //Now as soon as the new message is added to the chat collection. The stream connected to the chat collection is
    // alerted and hence the chat screen is updated accordingly
    //we will also add the image url that is captured when the user signs up in the usertable here in every new message submit.
    _cont.clear();
  }

  final _cont = new TextEditingController();
  var _enteredMessage = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a message...'),
              controller: _cont,
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                  //update the _enteredmessage variable on every key stroke.
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : sendMessage,
          )
        ],
      ),
    );
  }
}

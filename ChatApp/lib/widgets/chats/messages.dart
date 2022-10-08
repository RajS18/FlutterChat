import 'package:chatapp/widgets/chats/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapShot) {
        if (futureSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          //Here we used .orderBy() to make the stream, order the chat messages by comparing 'createdAt' value of chat messages
          //descending: true will make the chat message with higher TimeStamp value passed in stream first.
          builder: (ctx, streamSnapShot) {
            if (streamSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              final chatdocs = streamSnapShot.data.documents;
              if (futureSnapShot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                reverse: true,
                itemCount: chatdocs.length,
                itemBuilder: (ctx, i) => MessageBubble(
                  chatdocs[i]['text'],
                  chatdocs[i]['username'],
                  chatdocs[i]['user_image'],
                  chatdocs[i]['userId'] == futureSnapShot.data.uid,
                  key: ValueKey(chatdocs[i].documentID),
                  //We can create this with the value key and use some unique value. Every message here has a unique 
//value. It has a unique document I.D. so we can reach out to Chet docs and for to give an index access document
//I.D. written like  above.
//It might be able to efficiently update this list even without the key but it's certainly all to won't hurt.
                ),
              );
            }
          },
        );
      },
    );
  }
}

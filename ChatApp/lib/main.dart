import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:chatapp/screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          //This accent color brightness will show flutter that accent color is dark and
          //hence anything on this must be brighter.
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pinkAccent,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )),
          //Now here pay attention what happens if we want to render the screens as per auth conditions of the user auth.
//streamBuilder will take stream and builder as argument. Builder will build the screens depending on the value provided 
//by the altered stream attribute in->'userSnapShot'
//this gives us a stream and this stream will emit a new value whenever auth state changes and the auth state 
//changes when we sign up when we log in when we log out.
      home: StreamBuilder(stream:FirebaseAuth.instance.onAuthStateChanged ,builder: (ctx,userSnapShot){
        if(userSnapShot.connectionState==ConnectionState.waiting){
          return SplashScreen();
        }
        if(userSnapShot.hasData){
          return ChatScreen();
        }

        return AuthScreen();
      })
    );
  }
}

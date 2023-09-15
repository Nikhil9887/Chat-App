import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() => runApp(FlashChat());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // you can't use both home and initialRoute property at a time
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //       // body1: TextStyle(color: Colors.black54), // body1 is deprecated
      //       // it is now replaced with bodyText2
      //       bodyText2: TextStyle(color: Colors.black54)),
      // ),

      // we commented this one out cause we can just change the color of the text inside the
      // rounded button that we created
      // that will change text color of all the rounded buttons
    );
  }
}

import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      // it's running fine on the emulator like the animation and stuff, the text animation too
      // but not getting the desired results on physical device (phone)

      // upperBound: 100.0, // if we want to use CurvedAnimation then we can't have an upperbound greater than 1
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    controller.forward();
    // controller.reverse(from: 1.0);

    // animation.addStatusListener((status) {
    //   // print(status);
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    animation =
        // ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);
        ColorTween(begin: Colors.blueGrey, end: Colors.white)
            .animate(controller);

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // backgroundColor: Colors.red.withOpacity(controller.value),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                      // height: animation.value * 100,
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Flash Chat',
                        speed: const Duration(milliseconds: 250),
                      )
                    ],
                    // 'Flash Chat',
                    // '${controller.value.toInt()}%',
                    //  TextStyle(
                    //   fontSize: 45.0,
                    //   fontWeight: FontWeight.w900,
                    // ),
                    totalRepeatCount: 4,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 16.0),
            //   child: Material(
            //     elevation: 5.0,
            //     color: Colors.lightBlueAccent,
            //     borderRadius: BorderRadius.circular(30.0),
            //     child: MaterialButton(
            //       onPressed: () {
            //         //Go to login screen.
            //         // Navigator.push(context, MaterialPageRoute(
            //         //   builder: (context) {
            //         //     return LoginScreen();
            //         //   },
            //         Navigator.pushNamed(context, LoginScreen.id);
            //       },
            //       minWidth: 200.0,
            //       height: 42.0,
            //       child: Text(
            //         'Log In',
            //       ),
            //     ),
            //   ),
            // ),
            RoundedButton(
                color: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            // RoundedButton(color),
            RoundedButton(
              color: Colors.blueAccent,
              title: "Register",
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}

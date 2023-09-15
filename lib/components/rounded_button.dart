import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  late final Color color;
  late final String title;
  late final VoidCallback onPressed;

  RoundedButton({
    required this.color,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          // onPressed: () {
          //   //Go to registration screen.
          //   // Navigator.push(context,
          //   //     MaterialPageRoute(builder: (context) {
          //   //   return RegistrationScreen();
          //   Navigator.pushNamed(context, RegistrationScreen.id);
          // },
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          // child: Text(
          //   'Register',
          // ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

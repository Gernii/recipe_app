import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key, required this.onPressed})
      : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    Image _buildLogo() {
      return Image.asset(
        "assets/g-logo.png",
        height: 18.0,
        width: 18.0,
      );
    }

    Opacity _buildText() {
      return const Opacity(
        opacity: 0.54,
        child: Text(
          "Sign in with Google",
          style: TextStyle(
            fontFamily: 'Roboto-Medium',
            color: Colors.black,
          ),
        ),
      );
    }

    return MaterialButton(
      height: 40.0,
      onPressed: () => onPressed(),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(),
          const SizedBox(width: 24.0),
          _buildText(),
        ],
      ),
    );
  }
}

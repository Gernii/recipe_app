import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String caption;
  final Function onPressed;

  const SettingsButton(this.icon, this.title, this.caption, this.onPressed,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      textColor: const Color(0xFF807a6b),
      padding: EdgeInsets.all(20.0),
      onPressed: () => onPressed(),
      child: Row(
        children: [
          Icon(this.icon),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.title),
              SizedBox(height: 5.0),
              Text(this.caption, style: Theme.of(context).textTheme.caption),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  const Button({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => onPressed(), child: Text(buttonText));
  }
}

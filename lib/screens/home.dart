import 'package:flutter/material.dart';
import 'package:simple_login/core/const/textsize_const.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      "WELCOME",
      style: TextStyle(fontSize: TextSize.large),
    )));
  }
}

import 'package:flutter/material.dart';
import 'package:simple_login/core/auth/authentication.dart';
import 'package:simple_login/core/const/color_const.dart';
import 'package:simple_login/core/const/textsize_const.dart';
import 'package:simple_login/screens/registration.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _userRecord = {};

  Future<void> _login() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();

      Authentication().loginUser(_userRecord["email"], _userRecord["password"]).then((value) {
        if (value.user!.uid.isNotEmpty) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed")));
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty || !value.contains("@")) {
                  return "Please enter a valid email address.";
                }
                return null;
              },
              onSaved: (value) => _userRecord["email"] = value!,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return "Password must be at least 6 characters long.";
                }
                return null;
              },
              onSaved: (value) => _userRecord["password"] = value!,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text(
                "Login",
                style: TextStyle(fontSize: TextSize.medium),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const RegistrationPage())),
              child: const Text(
                "Register Here!",
                style: TextStyle(fontSize: TextSize.medium, color: ColorConst.textColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

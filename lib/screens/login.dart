import 'package:flutter/material.dart';
import 'package:simple_login/core/auth/authentication.dart';
import 'package:simple_login/core/const/validation_error.dart';
import 'package:simple_login/screens/registration.dart';
import 'package:simple_login/widgets/button.dart';
import '../core/const/color_const.dart';
import '../core/const/textsize_const.dart';
import 'home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(13.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _userRecord = {};

  Future<void> _login() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();

      FocusScope.of(context).unfocus(); //closing keyboard

      setState(() {
        _isLoading = true;
      });
      try {
        await Authentication().loginUser(_userRecord["email"], _userRecord["password"]);
        navigateToHome();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showScaffoldMessenger();
      }
    }
  }

  void showScaffoldMessenger() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed")));
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextFormField(
            labelText: "Email",
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _userRecord["email"] = value!,
            validator: (value) {
              if (value!.isEmpty || !value.contains("@")) {
                return FieldValidationErrors.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            labelText: "Password",
            obscureText: true,
            onSaved: (value) => _userRecord["password"] = value!,
            validator: (value) {
              if (value!.isEmpty || value.length < 6) {
                return FieldValidationErrors.invalidPassword;
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          !_isLoading ? Button(onPressed: _login, buttonText: "Login") : const Center(child: CircularProgressIndicator.adaptive()),
          const RegisterButton(),
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String?) onSaved;
  final String? Function(String?) validator;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.onSaved,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const RegistrationPage())),
      child: const Text(
        "Register Here!",
        style: TextStyle(fontSize: TextSize.medium, color: ColorConst.textColor),
      ),
    );
  }
}

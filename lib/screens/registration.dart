import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_login/screens/home.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _birthdateController = TextEditingController();

  String? _emailError;

  String? _passwordError;

  String? _fullNameError;

  String? _phoneNumberError;

  String? _birthdateError;

  bool registerLoading = false;

  Map<String, dynamic> validator() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final birthdate = _birthdateController.text.trim();

    bool validateFields() {
      if (email.isEmpty || !email.contains('@')) {
        _emailError = 'Please enter a valid email address';
        return false;
      }
      if (password.isEmpty || password.length < 6) {
        _passwordError = 'Password must be at least 6 characters long';
        return false;
      }
      if (fullName.isEmpty) {
        _fullNameError = 'Please enter your full name';
        return false;
      }
      if (phoneNumber.isEmpty) {
        _phoneNumberError = 'Please enter a phone number';
        return false;
      }
      if (birthdate.isEmpty) {
        _birthdateError = 'Please enter your birthdate';
        return false;
      }
      return true;
    }

    if (!validateFields()) {
      setState(() {});
      return {};
    }
    return {"email": email, "password": password, "fullName": fullName, "phoneNumber": phoneNumber, "birthdate": birthdate};
  }

  Future<void> _registerUser(BuildContext context) async {
    final validationRes = validator();
    if (validationRes.isNotEmpty) {
      try {
        setState(() {
          registerLoading = true;
        });
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: validationRes["email"],
          password: validationRes["password"],
        );

        final User user = userCredential.user!;

        // Store additional user data in Firestore
        _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': validationRes["email"],
          'fullName': validationRes["fullName"],
          'phoneNumber': validationRes["phoneNumber"],
          'birthdate': validationRes["birthdate"],
          // Add other user data fields as needed
        }).then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
        }).onError((error, stackTrace) {
          setState(() {
            registerLoading = false;
          });
        });
      } catch (e) {
        setState(() {
          registerLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registration Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTextFieldWithSpacing(
                controller: _emailController,
                labelText: 'Email',
                errorText: _emailError,
              ),
              _buildTextFieldWithSpacing(
                controller: _passwordController,
                labelText: 'Password',
                errorText: _passwordError,
                obscureText: true,
              ),
              _buildTextFieldWithSpacing(
                controller: _fullNameController,
                labelText: 'Full Name',
                errorText: _fullNameError,
              ),
              _buildTextFieldWithSpacing(
                controller: _phoneNumberController,
                labelText: 'Phone Number',
                maxLength: 10,
                errorText: _phoneNumberError,
              ),
              _buildTextFieldWithSpacing(
                controller: _birthdateController,
                labelText: 'Birthdate (YYYY-MM-DD)',
                errorText: _birthdateError,
              ),
              registerLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        _registerUser(context);
                      },
                      child: const Text('Register'),
                    )
            ],
          ),
        ));
  }
}

Widget _buildTextFieldWithSpacing({required TextEditingController controller, required String labelText, String? errorText, bool obscureText = false, int? maxLength}) {
  return Column(
    children: [
      TextField(
        maxLength: maxLength,
        controller: controller,
        decoration: InputDecoration(labelText: labelText, counter: Container()),
        obscureText: obscureText,
      ),
      if (errorText != null)
        Text(
          errorText,
          style: const TextStyle(color: Colors.red),
        ),
      const SizedBox(height: 10), // Add spacing here
    ],
  );
}

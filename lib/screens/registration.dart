import 'package:flutter/material.dart';
import 'package:simple_login/core/const/color_const.dart';
import 'package:simple_login/core/const/validation_error.dart';
import 'package:simple_login/core/firestore/firestore_operations.dart';
import 'package:simple_login/screens/home.dart';
import 'package:simple_login/widgets/button.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  String? _emailError;

  String? _passwordError;

  String? _fullNameError;

  String? _phoneNumberError;

  String? _addressError;

  bool registerLoading = false;

  Map<String, dynamic> validator() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final address = _addressController.text.trim();

    bool validateFields() {
      if (email.isEmpty || !email.contains('@')) {
        _emailError = FieldValidationErrors.invalidEmail;
        return false;
      }
      if (password.isEmpty || password.length < 6) {
        _passwordError = FieldValidationErrors.invalidPassword;
        return false;
      }
      if (fullName.isEmpty) {
        _fullNameError = FieldValidationErrors.emptyFullName;
        return false;
      } else if (fullName.contains(RegExp(r'[0-9]'))) {
        // Check if full name contains any numbers
        _fullNameError = FieldValidationErrors.fullNameContainsNumbers;
        return false;
      }

      if (phoneNumber.isEmpty) {
        _phoneNumberError = FieldValidationErrors.emptyPhoneNumber;
        return false;
      } else if (phoneNumber.contains(RegExp(r'[A-Za-z]'))) {
        // Check if phone number contains alphabetic characters
        _phoneNumberError = FieldValidationErrors.phoneNumberContainsAlphabets;
        return false;
      }
      if (address.isEmpty) {
        _addressError = FieldValidationErrors.emptyAddress;
        return false;
      }
      return true;
    }

    if (!validateFields()) {
      setState(() {});
      return {};
    }
    return {"email": email, "password": password, "fullName": fullName, "phoneNumber": phoneNumber, "address": address};
  }

  Future<void> _registerUser() async {
    final validationRes = validator();
    if (validationRes.isNotEmpty) {
      try {
        setState(() {
          registerLoading = true;
        });
        await FireStoreOperations().registerUser(validationRes);
        navigateToHome();
      } catch (e) {
        setState(() {
          registerLoading = false;
        });
        showScaffoldMessenger();
      }
    }
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
  }

  void showScaffoldMessenger() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Failed")));
  }

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    _fullNameController.dispose();

    _phoneNumberController.dispose();

    _addressController.dispose();
    super.dispose();
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
                controller: _addressController,
                labelText: 'Address',
                errorText: _addressError,
              ),
              registerLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Button(onPressed: _registerUser, buttonText: "Register")
            ],
          ),
        ));
  }
}

Widget _buildTextFieldWithSpacing({required TextEditingController controller, required String labelText, String? errorText, bool obscureText = false, int? maxLength}) {
  return Column(
    children: [
      TextField(
        keyboardType: labelText == "Phone Number" ? TextInputType.phone : TextInputType.text,
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

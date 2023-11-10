import 'package:flutter/material.dart';
import 'package:junction23/common_widgets/custom_solid_button.dart';
import 'package:junction23/common_widgets/text_input_field.dart';
import 'package:junction23/constants/app_spacing.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
// create text editing controlelr for email, password, confirm password, username, and a form key
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Sign Up')),
          leading: const SizedBox(),
        ),
        body: Stack(children: [
          Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextInputField(
                        controller: _usernameController,
                        labelText: "Username",
                        validator: "username"),
                    gapH24,
                    TextInputField(
                        controller: _emailController,
                        labelText: "E-Mail",
                        validator: "email"),
                    gapH24,
                    TextInputField(
                        controller: _passwordController,
                        labelText: "Password",
                        validator: "password"),
                    gapH24,
                    TextInputField(
                        controller: _confirmPasswordController,
                        labelText: "Confirm Password",
                        validator: "password"),
                    gapH24,
                    CustomSolidButton(
                      text: "Sign Up",
                      onPressed: () {},
                    )
                  ],
                )),
          ),
        ]));
  }
}

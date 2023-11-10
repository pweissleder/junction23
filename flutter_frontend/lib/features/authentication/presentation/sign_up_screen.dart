import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/common_widgets/custom_solid_button.dart';
import 'package:junction23/common_widgets/text_input_field.dart';
import 'package:junction23/constants/app_spacing.dart';
import 'package:junction23/constants/design.dart';
import 'package:junction23/features/authentication/data/sign_up_firebase.dart';
import 'package:junction23/features/routing/app_router.dart';

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

  String state = "";
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
                    gapH16,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p32, right: Spacing.p32),
                      child: TextInputField(
                          controller: _usernameController,
                          labelText: "Username",
                          validator: "username"),
                    ),
                    gapH24,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p32, right: Spacing.p32),
                      child: TextInputField(
                          controller: _emailController,
                          labelText: "E-Mail",
                          validator: "email"),
                    ),
                    gapH24,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p32, right: Spacing.p32),
                      child: TextInputField(
                          controller: _passwordController,
                          labelText: "Password",
                          validator: "password"),
                    ),
                    gapH24,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p32, right: Spacing.p32),
                      child: TextInputField(
                          controller: _confirmPasswordController,
                          labelText: "Confirm Password",
                          validator: "password"),
                    ),
                    gapH24,
                    if (state.isNotEmpty)
                      Text(state, style: const TextStyle(color: error)),
                    if (state.isNotEmpty) gapH24,
                    CustomSolidButton(
                      text: "Sign Up",
                      gradient: gradient1,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // if form is valid
                          // sign up user
                          try {
                            await signUpUser(
                                _emailController.text,
                                _passwordController.text,
                                _usernameController.text);
                          } catch (e) {
                            setState(() {
                              state = e.toString();
                            });
                          }
                          // if sign up is successful navigate to home screen
                          if (mounted) context.push("/");
                        }
                      },
                    )
                  ],
                )),
          ),
        ]));
  }
}

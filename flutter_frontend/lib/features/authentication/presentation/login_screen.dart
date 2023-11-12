import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/common_widgets/custom_solid_button.dart';
import 'package:junction23/common_widgets/custom_text_button.dart';
import 'package:junction23/common_widgets/text_input_field.dart';
import 'package:junction23/constants/app_spacing.dart';
import 'package:junction23/constants/design.dart';
import 'package:junction23/features/routing/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text controlelr for login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Login')),
          leading: const SizedBox(),
        ),
        body: Stack(children: [
          Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    gapH24,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p16, right: Spacing.p16),
                      child: TextInputField(
                          controller: _emailController,
                          labelText: "E-Mail",
                          validator: "email"),
                    ),
                    gapH24,
                    Padding(
                        padding: const EdgeInsets.only(
                            left: Spacing.p16, right: Spacing.p16),
                        child: TextInputField(
                            controller: _passwordController,
                            labelText: "Password",
                            validator: "password")),
                    gapH24,
                    CustomSolidButton(
                      text: "Login",
                      gradient: gradient1,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // if form is valid
                          // login user
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            context.pushNamed(AppRouting.home);
                          });
                          // if login is successful navigate to home screen
                          // if login is unsuccessful show error message
                        }
                      },
                    ),
                    gapH16,
                    CustomTextButton(
                        text: "Create Account",
                        fontSize: h7,
                        onPressed: () {
                          context.pushNamed(AppRouting.signUp);
                        })
                  ],
                )),
          ),
        ]));
  }
}

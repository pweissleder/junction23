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
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Dropdown menu items for gender selection
  String _selectedGender = 'Prefer not to say';
  List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  String state = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Sign Up')),
          leading: const SizedBox(),
        ),
        body: SingleChildScrollView(
          child: Center(
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
                    gapH8,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p32, right: Spacing.p32),
                      child: TextInputField(
                          controller: _emailController,
                          labelText: "E-Mail",
                          validator: "email"),
                    ),

                    gapH8,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Spacing.p32),
                      child: TextInputField(
                        controller: _ageController,
                        labelText: "Age",
                        validator: "",
                      ),
                    ),
                    gapH8,

                    // Add Height Input Field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Spacing.p32),
                      child: TextInputField(
                        controller: _heightController,
                        labelText: "Height (cm)",
                        validator: "",
                      ),
                    ),
                    gapH8,

                    // Add Weight Input Field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Spacing.p32),
                      child: TextInputField(
                        controller: _weightController,
                        labelText: "Weight (kg)",
                        validator: "",
                      ),
                    ),
                    gapH8,

                    // Gender Dropdown
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Spacing.p32),
                      child: DropdownButtonFormField(
                        value: _selectedGender,
                        items: _genderOptions
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    gapH8,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p32, right: Spacing.p32),
                      child: TextInputField(
                          controller: _passwordController,
                          labelText: "Password",
                          validator: "password"),
                    ),
                    gapH8,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Spacing.p32, right: Spacing.p32),
                      child: TextInputField(
                          controller: _confirmPasswordController,
                          labelText: "Confirm Password",
                          validator: "password"),
                    ),
                    gapH16,
                    if (state.isNotEmpty)
                      Text(state, style: const TextStyle(color: error)),
                    if (state.isNotEmpty) gapH8,
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
                                _usernameController.text,
                                _ageController.text,
                                _heightController.text,
                                _weightController.text,
                                _selectedGender);
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
        ));
  }
}

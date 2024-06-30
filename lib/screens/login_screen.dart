import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/services/auth.dart' as MusicAppAuth;
import 'package:provider/provider.dart';
import '../common/custom_input_field.dart';
import '../common/page_header.dart';
import 'forget_password_screen.dart';
import 'registration_screen.dart';
import 'package:email_validator/email_validator.dart';
import '../common/page_heading.dart';
import '../common/custom_form_button.dart';
import '../screens/main_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider = Provider.of<MusicAppAuth.AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: authProvider.loginFormKey,
                    child: Column(
                      children: [
                        const PageHeading(title: 'Log-in'),
                        CustomInputField(
                          labelText: 'Email',
                          hintText: 'Your email id',
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Email is required!';
                            }
                            if (!EmailValidator.validate(textValue)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          controller: authProvider.emailController,
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          labelText: 'Password',
                          hintText: 'Your password',
                          obscureText: true,
                          suffixIcon: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Password is required!';
                            }
                            return null;
                          },
                          controller: authProvider.passwordController,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: size.width * 0.80,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                            ),
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                color: Color(0xff939393),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomFormButton(
                          innerText: 'Login',
                          onPressed: () async {
                            if (authProvider.loginFormKey.currentState!.validate()) {
                              User? user = await authProvider.signInWithEmailAndPassword();
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => MainScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to sign in. Please check your credentials.'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomFormButton(
                          innerText: 'Login with Google',
                          onPressed: () async {
                            User? user = await authProvider.signInWithGoogle();
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to sign in with Google. Please try again later.'),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          width: size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account ? ',
                                style: TextStyle(fontSize: 13, color: Color(0xff939393), fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignupPage()),
                                ),
                                child: const Text(
                                  'Sign-up',
                                  style: TextStyle(fontSize: 15, color: Color(0xff748288), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

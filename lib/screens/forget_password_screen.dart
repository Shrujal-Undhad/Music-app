import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../common/custom_form_button.dart';
import '../common/page_header.dart';
import '../common/page_heading.dart';
import 'login_screen.dart';
import '../common/custom_input_field.dart';

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late TextEditingController _emailController;
  late AuthProvider _authService;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthProvider>(context);

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
                  child: ForgetPasswordForm(emailController: _emailController, authService: _authService),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgetPasswordForm extends StatefulWidget {
  final TextEditingController emailController;
  final AuthProvider authService;

  ForgetPasswordForm({super.key, required this.emailController, required this.authService});

  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final GlobalKey<FormState> _forgetPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _forgetPasswordFormKey,
      child: Column(
        children: [
          const PageHeading(title: 'Forgot password'),
          CustomInputField(
            labelText: 'Email',
            hintText: 'Your email id',
            isDense: true,
            validator: (textValue) {
              if (textValue == null || textValue.isEmpty) {
                return 'Email is required!';
              }
              return null;
            },
            controller: widget.emailController,
          ),
          const SizedBox(height: 20),
          CustomFormButton(
            innerText: 'Submit',
            onPressed: () {
              _handleForgetPassword(context);
            },
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                'Back to login',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff939393),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleForgetPassword(BuildContext context) {
    if (_forgetPasswordFormKey.currentState!.validate()) {
      widget.authService.resetPassword(widget.emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
    }
  }
}

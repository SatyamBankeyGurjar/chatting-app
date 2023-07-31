import 'package:flutter/material.dart';
import 'package:messanger_app/services/auth/AuthService.dart';
import 'package:provider/provider.dart';

import '../components/myButton.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // siogn up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password do not match !')));
      return;
    }

    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Register nhi ho rha he")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 50,
            ),

            //Icon
            Icon(
              Icons.message,
              size: 100,
              color: Colors.grey[800],
            ),

            const SizedBox(
              height: 50,
            ),

            //Message
            const Text(
              "Let's create an account for you",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(
              height: 25,
            ),

            //email textfield
            MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false),

            const SizedBox(
              height: 10,
            ),

            //confirm-password textfield
            MyTextField(
                controller: confirmPasswordController,
                hintText: 'Password',
                obscureText: true),

            const SizedBox(
              height: 10,
            ),

            //password textfield
            MyTextField(
                controller: passwordController,
                hintText: 'Confirm Password',
                obscureText: true),

            const SizedBox(
              height: 25,
            ),

            //sign in button
            myButton(onTap: signUp, text: "Register"),

            const SizedBox(
              height: 50,
            ),

            //not a member? resister now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already a member?'),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

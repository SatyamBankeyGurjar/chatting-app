import 'package:flutter/material.dart';
import 'package:messanger_app/components/myButton.dart';
import 'package:messanger_app/components/my_text_field.dart';
import 'package:provider/provider.dart';

import '../services/auth/AuthService.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //log in user
  void logIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
              "Welcome back you've been missed",
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

            //password textfield
            MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true),

            const SizedBox(
              height: 25,
            ),

            //sign in button
            myButton(onTap: logIn, text: "Login"),

            const SizedBox(
              height: 50,
            ),

            //not a member? resister now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member?'),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Resister now',
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
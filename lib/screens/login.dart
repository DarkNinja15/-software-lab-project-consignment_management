import 'package:flutter/material.dart';
// import 'package:flutter_consignment/models/user_model.dart';
import 'package:flutter_consignment/screens/company.dart';
import 'package:flutter_consignment/screens/home.dart';
import 'package:flutter_consignment/screens/register.dart';
import 'package:flutter_consignment/services/auth.dart';
// import 'package:flutter_consignment/services/local%20storage/user_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/auth.png'),
                const SizedBox(height: 20),
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please enter all fields'),
                            ));
                            return;
                          }
                          if (emailController.text.endsWith("@company.com") &&
                              passwordController.text == "password@123") {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const CompanyPage(),
                              ),
                              (route) => false,
                            );
                            return;
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            await AuthMethods()
                                .login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              context,
                            )
                                .then((value) {
                              if (value != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            });
                            // if (user != null) {
                            //   await UserPreferences.saveUser(user)
                            //       .then((value) {
                            //     setState(() {});
                            //   });
                            // }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

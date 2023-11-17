import 'package:flutter/material.dart';
// import 'package:flutter_consignment/models/user_model.dart';
import 'package:flutter_consignment/screens/home.dart';
import 'package:flutter_consignment/screens/login.dart';
import 'package:flutter_consignment/services/auth.dart';
// import 'package:flutter_consignment/services/local%20storage/user_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    _formkey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formkey,
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
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (String? val) {
                      if (val == null) {
                        return 'Please enter name';
                      }
                      for (int i = 0; i < val.length; i++) {
                        int ascii = val.codeUnitAt(i);
                        if (!((ascii >= 65 && ascii <= 90) ||
                            (ascii >= 97 && ascii <= 122) ||
                            ascii == 32)) {
                          return 'Name should only consist of alphabets';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (String? val) {
                      if (val == null) {
                        return 'Please enter email';
                      }
                      if (!val.contains('@') || !val.contains('.')) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Create Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password should be atleast 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.blue,
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await AuthMethods()
                                  .register(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                context,
                              )
                                  .then((value) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                  (route) => false,
                                );
                              });
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: const Text('Register'),
                        ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                    child: const Text('Login To Existing Account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

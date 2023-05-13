import 'package:chat_box_using_firebase/ui/auth/login.dart';
import 'package:chat_box_using_firebase/ui_logics/methods.dart';
import 'package:chat_box_using_firebase/widget/button_widget.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        body: loading
            ? Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 20,
                    child: const CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Sign Up to Continue!',
                        style: TextStyle(
                          fontSize: 19.0,
                        ),
                      ),
                      const SizedBox(
                        height: 100.0,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_rounded),
                            hintText: 'Enter your name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_rounded),
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_rounded),
                            hintText: 'Enter your password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Center(
                          child: ButtonWidget(
                        loading: loading,
                        buttonText: 'SignUp',
                        onTap: () {
                          if (nameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            setState(() {
                              loading = true;
                            });

                            createAccount(
                                    nameController.text.toString(),
                                    emailController.text.toString(),
                                    passwordController.text.toString())
                                .then((user) {
                              if (user != null) {
                                setState(() {
                                  loading = false;
                                });
                                debugPrint("Account Created");
                              } else {
                                debugPrint("Account Not Created");
                              }
                            });
                          } else {
                            debugPrint("Please enter the data in the fields");
                          }
                        },
                      )),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: const Text(
                                'Login to continue',
                                style: TextStyle(color: Colors.blue),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

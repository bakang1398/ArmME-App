import 'package:arm_me/providers/login_provider.dart';
import 'package:arm_me/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool validateLogin() {
    if(emailController.text.isEmpty) {
      setState(() {
        errorMessage = "Please enter email address.";
      });
      return false;
    } else if(passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Please enter the password.";
      });
      return false;
    } else {
      errorMessage = null;
    }
    return true;
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Consumer<LoginProvider>(
        builder: (context, value, child) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: Column(
                  children: [
                    const Text("Login", style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800),),
                    const SizedBox(height: 12,),
                    const Text("Welcome to ArmME", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                    const SizedBox(height: 40,),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hint: const Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade100
                          )
                        )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          hint: const Text(
                            "Password",
                            style: TextStyle(
                                color: Colors.grey
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade100
                              )
                          )
                      ),
                    ),
                    const SizedBox(height: 40,),
                    errorMessage != null || value.errorMessage != null ? Center(
                      child: Text(
                        value.errorMessage ?? errorMessage ?? "",
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                    ) : Container(),
                    const SizedBox(height: 10,),
                    value.isLoading ? Center(
                      child: CircularProgressIndicator(),
                    ) : Container(
                      child: ElevatedButton(
                        onPressed: ()  {
                          if (!validateLogin()) {
                            return;
                          }

                          if(errorMessage == null || value.errorMessage == null) {
                            Provider
                                .of<LoginProvider>(context, listen: false)
                                .login(emailController.text, passwordController
                                .text, () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                    builder: (context) => StatusScreen(),
                                  )
                              );
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                          foregroundColor: Colors.white
                        ),
                        child: Center(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}

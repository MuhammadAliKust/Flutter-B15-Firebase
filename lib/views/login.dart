import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/providers/user.dart';
import 'package:flutter_b15_firebase/services/auth.dart';
import 'package:flutter_b15_firebase/services/user.dart';
import 'package:flutter_b15_firebase/views/forgot_pwd.dart';
import 'package:flutter_b15_firebase/views/get_all_categories.dart';
import 'package:flutter_b15_firebase/views/register.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();

  TextEditingController pwdController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: pwdController,
          ),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Email cannot be empty.")));
                      return;
                    }
                    if (pwdController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password cannot be empty.")));
                      return;
                    }
                    try {
                      isLoading = true;
                      setState(() {});
                      await AuthServices()
                          .loginUser(
                              email: emailController.text,
                              password: pwdController.text)
                          .then((val) async {
                        await UserServices()
                            .getUser(val!.uid.toString())
                            .then((userData) {
                          isLoading = false;
                          setState(() {});
                          userProvider.setUser(userData);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Message"),
                                  content: Text("Logged In"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GetAllCategoriesView()));
                                        },
                                        child: Text("Okay"))
                                  ],
                                );
                              });
                        });
                      });
                    } catch (e) {
                      isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Login")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterView()));
              },
              child: Text("Go to Register")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordView()));
              },
              child: Text("Go to Forgot Password"))
        ],
      ),
    );
  }
}

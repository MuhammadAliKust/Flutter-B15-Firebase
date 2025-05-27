import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/user.dart';
import 'package:flutter_b15_firebase/services/auth.dart';
import 'package:flutter_b15_firebase/services/user.dart';
import 'package:flutter_b15_firebase/views/login.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController pwdController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: phoneController,
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: addressController,
          ),
          SizedBox(
            height: 30,
          ),
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
                          .registerUser(
                              email: emailController.text,
                              password: pwdController.text)
                          .then((val) async {
                        await UserServices()
                            .createUser(UserModel(
                                name: nameController.text,
                                phone: phoneController.text,
                                address: addressController.text,
                                email: emailController.text,
                                createdAt:
                                    DateTime.now().millisecondsSinceEpoch,
                                docId: val!.uid.toString()))
                            .then((val) {
                          isLoading = false;
                          setState(() {});
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Message"),
                                  content: Text("Registered"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView()));
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
                  child: Text("Register"))
        ],
      ),
    );
  }
}

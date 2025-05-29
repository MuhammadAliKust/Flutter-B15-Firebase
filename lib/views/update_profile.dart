import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/user.dart';
import 'package:flutter_b15_firebase/providers/user.dart';
import 'package:flutter_b15_firebase/services/auth.dart';
import 'package:flutter_b15_firebase/services/user.dart';
import 'package:flutter_b15_firebase/views/login.dart';
import 'package:provider/provider.dart';

class UpdateProfileView extends StatefulWidget {
  UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false);
    nameController =
        TextEditingController(text: user.getUser()!.name.toString());
    addressController =
        TextEditingController(text: user.getUser()!.address.toString());
    phoneController =
        TextEditingController(text: user.getUser()!.phone.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
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
            height: 20,
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ElevatedButton(
              onPressed: () async {
                try {
                  isLoading = true;
                  setState(() {});
                  await UserServices()
                      .updateUser(UserModel(
                      docId: user.getUser()!.docId.toString(),
                      name: nameController.text,
                      phone: phoneController.text,
                      address: addressController.text))
                      .then((val) async {
                    await UserServices().getUser(
                        user.getUser()!.docId.toString()).then((val) {
                      user.setUser(val);

                      isLoading = false;
                      setState(() {});
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Message"),
                              content: Text(
                                  "Profile has been updated successfully"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
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
              child: Text("Update"))
        ],
      ),
    );
  }
}

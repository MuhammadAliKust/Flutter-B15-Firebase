import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_b15_firebase/%20models/user.dart';

class UserServices {
  ///Create User
  Future createUser(UserModel model) async {
    return await FirebaseFirestore.instance
        .collection('b15UserCollection')
        .doc(model.docId)
        .set(model.toJson(model.docId.toString()));
  }

  ///Get LoggedIn User Data

  Future<UserModel> getUser(String userID) async {
    return await FirebaseFirestore.instance
        .collection('b15UserCollection')
        .doc(userID)
        .get()
        .then((val) => UserModel.fromJson(val.data()!));
  }
}

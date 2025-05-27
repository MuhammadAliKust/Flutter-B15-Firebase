import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  void setUser(UserModel val) {
    _userModel = val;
    notifyListeners();
  }

  UserModel? getUser() => _userModel;
}

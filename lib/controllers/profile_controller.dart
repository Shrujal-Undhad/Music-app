import 'package:flutter/material.dart';
import '../models/user_data.dart';

class ProfileProvider with ChangeNotifier {
  late UserData _userData;

  UserData get userData => _userData;

  void init(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

}

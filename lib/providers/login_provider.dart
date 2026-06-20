import 'package:arm_me/services/arm_me_service.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier{
  final _service = ArmMeService();
  bool isLoading = false;
  String? errorMessage;
  String token = '';

  void login(String userName, String password, Function() onComplete) async {
    isLoading = true;
    notifyListeners();

    try{
      var receivedToken = await _service.login(userName, password);
      token = receivedToken;
      debugPrint("the token value: $token");
      isLoading = false;
      notifyListeners();
      onComplete();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
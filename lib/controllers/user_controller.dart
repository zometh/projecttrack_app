import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class UserController extends GetxController{
  static UserController get to => Get.find();
  String get getEmail => connectedUserMail.value;
  String get getUid => connectedUid.value;
  Rx<MyUser> connectedUser = MyUser.empty().obs;
  MyUser get getUser => connectedUser.value;

  RxString connectedUserMail = "".obs;
  RxString connectedUid = "".obs;
  updateConnectedUserMail(){
    connectedUserMail.value = AuthService().connectedUserMail!;
    connectedUid.value = AuthService().connectedUid!;
    update();
  }
  updateConnectedUser(MyUser user){
    connectedUser.value = user;
    update();

  }

  void resetUser() {
    connectedUser.value = MyUser.empty();
    update();

  }
}
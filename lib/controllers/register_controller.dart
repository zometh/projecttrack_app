import 'dart:io';

import 'package:get/get.dart';


class AuthController extends GetxController {
  static AuthController get to => Get.find();
  Rx<String> email = "".obs;
  Rx<String> password = "".obs;
  Rx<String> fullName = "".obs;
  
  // Initialize with a Rx<File> instead of Rx<File>?
  Rx<File?> file = Rx<File?>(null);
  
  updateRegisterValues(String email, String password, String fullName, File image) {
    this.email.value = email;
    this.password.value = password;
    this.fullName.value = fullName;
    file.value = image;
    update();
  }
  updateLoginValue(String email, String password,){
    this.email.value = email;
    this.password.value = password;
    update();
  }
  resetValue() {
    email.value = "";
    password.value = "";
    fullName.value = "";
    file.value = null;
  }
}

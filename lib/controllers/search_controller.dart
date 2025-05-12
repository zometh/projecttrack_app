import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProjectController extends GetxController {
  late Rx<TextEditingController> searchController;
  String get search => searchController.value.text;
  RxInt projectStatus = 0.obs;
  int get status => 0;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    searchController = TextEditingController().obs;

  }
  updateStatus(int status){
    projectStatus.value = status;
    update();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    searchController.value.dispose();
    super.dispose();
  }
  int getStatus(){
    switch(projectStatus.value){
      case 0:
        return -1;
      case 1:
        return 0;
      case 2:
        return 1;
      case 3:
        return 2;
      default:
        return 3;
    }
  }
  
}

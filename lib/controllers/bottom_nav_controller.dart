import 'package:get/get.dart';

class BottomNavBarController extends GetxController{
  static BottomNavBarController get to => Get.find();
  Rx<int> currentIdex = 0.obs;
  int get index => currentIdex.value;
  updateIndex(int index){
    currentIdex.value = index;
    update();
  }
}
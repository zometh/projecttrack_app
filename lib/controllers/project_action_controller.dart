import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProjectActionController extends GetxController {
  static ProjectActionController get to => Get.find();
  int? priority;
  late Rx<TextEditingController> title;
  late Rx<TextEditingController> description;
  Rx<DateTime> start = DateTime.now().obs;
  Rx<DateTime> end = DateTime.now().obs;
  Timestamp? startDate;
  Timestamp? endDate;
  String? pTitle;
  String? pDescription;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    title = TextEditingController().obs;
    description = TextEditingController().obs;
  }

  updateValue() {
    startDate = Timestamp.fromDate(start!.value);
    endDate = Timestamp.fromDate(end!.value);
    pTitle = title!.value.text.trim();
    pDescription = description!.value.text.trim();
    update();
  }

  resetValue() {
    title.value = TextEditingController();
    description.value = TextEditingController();
    start.value = DateTime.now();
    end.value = DateTime.now();
    priority = null;
  }

  updatePriority(int newValue) {
    priority = newValue;
    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    title.value.dispose();
    description.value.dispose();
    super.dispose();
  }
}

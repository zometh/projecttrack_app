import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:toastification/toastification.dart';

void showSuccess({required String message, String title = ""}) {
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    title: CustomText(
      text: title,
      color: Colors.white,
      fontSize: 13.sp,
      fontWeight: FontWeight.bold,
    ),
    description: CustomText(text: message, fontSize: 13.sp),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 4),
    borderRadius: BorderRadius.circular(4.0),
    applyBlurEffect: true,
  );
}

void showError({required String message, String title = "ERREUR"}) {
  toastification.show(
    type: ToastificationType.error,
    style: ToastificationStyle.fillColored,
    title: CustomText(
      text: title,
      color: Colors.white,
      fontSize: 13.sp,
      fontWeight: FontWeight.bold,
    ),
    description: CustomText(text: message, fontSize: 13.sp),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 4),
    borderRadius: BorderRadius.circular(4.0),
    applyBlurEffect: true,
  );
}

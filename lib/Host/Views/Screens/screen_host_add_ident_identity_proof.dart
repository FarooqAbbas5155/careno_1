import 'dart:io';

import 'package:careno/Host/Views/Screens/screen_host_account_pending.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/controllers/controller_host_add_identity_proof.dart';
import 'package:careno/widgets/custom_button.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/file_pick.dart';

class ScreenHostAddIdentIdentityProof extends StatelessWidget {
  const ScreenHostAddIdentIdentityProof({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControllerHostAddIdentityProof controllerHostAddIdentityProof =
        Get.put(ControllerHostAddIdentityProof());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Identity Proof",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.sp),
              ),
              Text(
                "Upload Proof of Insurance Certificate",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
              ).marginSymmetric(vertical: 20.h),
              buildInsuranceProof(controllerHostAddIdentityProof)
                  .marginSymmetric(horizontal: 31.w, vertical: 20.h),
              Text(
                "Upload Your National ID (Front)",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
              ).marginSymmetric(vertical: 20.h),
              buildIdCardFront(controllerHostAddIdentityProof)
                  .marginSymmetric(horizontal: 31.w, vertical: 20.h),
              Text(
                "Upload Your National ID (Back)",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
              ).marginSymmetric(vertical: 20.h),
              buildIdCardBack(controllerHostAddIdentityProof)
                  .marginSymmetric(horizontal: 31.w, vertical: 20.h),
              Obx(() {
                return CustomButton(
                    isLoading: controllerHostAddIdentityProof.loading.value,
                    title: "Share Proof",
                    onPressed: () async {
                      var response = await controllerHostAddIdentityProof
                          .updateIdentityProof();
                      if (response=="success") {
                        Get.offAll(()=>ScreenHostAccountPending());
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));

                      }
                    });
              }).marginSymmetric(horizontal: 8.w, vertical: 20.h)
            ],
          ).marginSymmetric(horizontal: 25.w),
        ),
      ),
    );
  }

  Obx buildInsuranceProof(
      ControllerHostAddIdentityProof controllerHostAddIdentityProof) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          controllerHostAddIdentityProof.insurancePath.value =
              await FilePick().pickImage(ImageSource.gallery);
        },
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: AppColors.appPrimaryColor,
          dashPattern: [6, 6, 6, 6],
          strokeWidth: .5.sp,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: 152.w,
              width: Get.width,
              child: (controllerHostAddIdentityProof.insurancePath.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomSvg(
                          name: "insurance",
                        ),
                        Text(
                          "Click for add",
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appPrimaryColor),
                        )
                      ],
                    )
                  : Image.file(
                      File(controllerHostAddIdentityProof.insurancePath.value)),
            ),
          ),
        ),
      );
    });
  }

  Obx buildIdCardFront(
      ControllerHostAddIdentityProof controllerHostAddIdentityProof) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          controllerHostAddIdentityProof.idFrontPath.value =
              await FilePick().pickImage(ImageSource.gallery);
        },
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: AppColors.appPrimaryColor,
          dashPattern: [6, 6, 6, 6],
          strokeWidth: .5.sp,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: 152.w,
              width: Get.width,
              child: (controllerHostAddIdentityProof.idFrontPath.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomSvg(
                          name: "id-front",
                        ),
                        Text(
                          "Click for add",
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appPrimaryColor),
                        )
                      ],
                    )
                  : Image.file(
                      File(controllerHostAddIdentityProof.idFrontPath.value)),
            ),
          ),
        ),
      );
    });
  }

  Obx buildIdCardBack(
      ControllerHostAddIdentityProof controllerHostAddIdentityProof) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          controllerHostAddIdentityProof.idBackPath.value =
              await FilePick().pickImage(ImageSource.gallery);
        },
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: AppColors.appPrimaryColor,
          dashPattern: [6, 6, 6, 6],
          strokeWidth: .5.sp,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: 152.w,
              width: Get.width,
              child: controllerHostAddIdentityProof.idBackPath.value.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomSvg(
                          name: "id-back",
                        ),
                        Text(
                          "Click for add",
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appPrimaryColor),
                        )
                      ],
                    )
                  : Image.file(
                      File(controllerHostAddIdentityProof.idBackPath.value)),
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/text_field.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class ForGotPasswordScreen extends StatefulWidget {
  const ForGotPasswordScreen({super.key});

  @override
  State<ForGotPasswordScreen> createState() => _ForGotPasswordScreenState();
}

class _ForGotPasswordScreenState extends State<ForGotPasswordScreen> {
  final numberController = TextEditingController();
  final otpController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      color: backGroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backGroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.065).copyWith(top: h * 0.026, bottom: h * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios, size: 22),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.035),
                    child: Center(
                      child: assetImage(AppAssets.appLogo, height: h * 0.14),
                    ),
                  ),
                  AppString.forgotPassword.boldRobotoTextStyle(fontSize: 22),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.045),
                    child: AppString.numberText
                        .semiBoldBarlowTextStyle(fontSize: 15, fontColor: greyTextColor)
                        .paddingSymmetric(horizontal: w * 0.015),
                  ),
                  AppTextField(
                    onChanged: (value) {
                      if (numberController.text.length == 10) {
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      }
                    },
                    widthContainer: w * 0.65,
                    width: w * 0.2,
                    maxLength: 10,
                    inputType: TextInputType.number,
                    controller: numberController,
                    icon: numberController.text.length == 10
                        ? GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                              decoration:
                                  BoxDecoration(color: blackColor, borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: AppString.otpText
                                    .semiBoldBarlowTextStyle(fontSize: 10, fontColor: backGroundColor),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    hintText: AppString.numberTextHint,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Responsive.isDesktop(context) ? h * 0.04 : h * 0.015),
                    child: AppString.otpTextData
                        .semiBoldBarlowTextStyle(fontSize: 15, fontColor: greyTextColor)
                        .paddingSymmetric(horizontal: w * 0.015),
                  ),
                  AppTextField(
                    maxLength: 6,
                    inputType: TextInputType.number,
                    obscure: isVisible,
                    controller: otpController,
                    icon: const SizedBox(),
                    hintText: AppString.otpTextHint,
                  ),
                  (Responsive.isDesktop(context) ? h * 0.09 : h * 0.05).addHSpace(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.03).copyWith(bottom: h * 0.15),
                    child: MaterialButton(
                      onPressed: () {
                        Get.offAllNamed(Routes.homeScreen);
                      },
                      color: Colors.black,
                      height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppString.forgotPassword
                              .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
                        ],
                      ),
                    ),
                  ),
                  (h * 0.02).addHSpace(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

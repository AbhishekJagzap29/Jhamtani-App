import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Screen/AuthScreen/auth_controller.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Widgets/text_field.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController authScreenController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<AuthController>(
      builder: (controller) {
        return Container(
          color: backGroundColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backGroundColor,
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.065)
                      .copyWith(top: h * 0.026, bottom: h * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios, size: 22)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.035),
                        child: Center(
                          child: assetImage(AppAssets.appLogo, height: h * 0.14),
                        ),
                      ),
                      AppString.registerHeadingText
                          .boldRobotoTextStyle(fontSize: 22),
                      AppString.welcomeText
                          .regularBarlowTextStyle(fontSize: 15),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.045),
                        child: AppString.nameText
                            .semiBoldBarlowTextStyle(
                                fontSize: 15, fontColor: greyTextColor)
                            .paddingSymmetric(horizontal: w * 0.015),
                      ),
                      AppTextField(
                        controller: controller.nameController,
                        icon: Icon(
                          Icons.person,
                          size: Responsive.isTablet(context)
                              ? h * 0.031
                              : h * 0.025,
                        ),
                        hintText: AppString.enterNameText,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Responsive.isDesktop(context)
                                ? h * 0.04
                                : h * 0.015),
                        child: AppString.emailText
                            .semiBoldBarlowTextStyle(
                                fontSize: 15, fontColor: greyTextColor)
                            .paddingSymmetric(horizontal: w * 0.015),
                      ),
                      AppTextField(
                        controller: controller.emailController,
                        icon: Icon(
                          Icons.email_outlined,
                          size: Responsive.isTablet(context)
                              ? h * 0.031
                              : h * 0.025,
                        ),
                        hintText: AppString.emailHint,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: h * 0.015),
                      //   child: AppString.numberText
                      //       .semiBoldBarlowTextStyle(
                      //           fontSize: 15, fontColor: greyTextColor)
                      //       .paddingSymmetric(horizontal: w * 0.015),
                      // ),
                      // LoginTextField(
                      //   isMobile: true,
                      //   inputType: TextInputType.number,
                      //   controller: controller.mobileNOController,
                      //   icon: const Icon(Icons.call),
                      //   hintText: AppString.numberTextHint,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Responsive.isDesktop(context)
                                ? h * 0.04
                                : h * 0.015),
                        child: AppString.userText
                            .semiBoldBarlowTextStyle(
                                fontSize: 15, fontColor: greyTextColor)
                            .paddingSymmetric(horizontal: w * 0.015),
                      ),
                      InnerShadowContainer(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Responsive.isDesktop(context)
                                  ? w * 0.0155
                                  : Responsive.isTablet(context)
                                      ? w * 0.035
                                      : w * 0.047),
                          child: Center(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text(controller.selectType,
                                  style: controller.selectType != "Select Type"
                                      ? textFieldTextStyle
                                      : textFieldHintTextStyle),
                              underline: const SizedBox(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: blackColor,
                                size: Responsive.isTablet(context)
                                    ? h * 0.031
                                    : h * 0.025,
                              ),
                              items: ["Maker", "Checker", "Approver"]
                                  .map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: items.regularBarlowTextStyle(
                                      fontSize: 16),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                controller.changeUserType(newValue.toString());
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Responsive.isDesktop(context)
                                ? h * 0.04
                                : h * 0.015),
                        child: AppString.passwordText
                            .semiBoldBarlowTextStyle(
                                fontSize: 15, fontColor: greyTextColor)
                            .paddingSymmetric(horizontal: w * 0.015),
                      ),
                      AppTextField(
                        obscure: !controller.isResVisible,
                        controller: controller.passWordController,
                        icon: GestureDetector(
                          onTap: () {
                            controller.resIsObSecure();
                          },
                          child: Icon(
                            controller.isResVisible
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black,
                          ),
                        ),
                        hintText: AppString.passwordHint,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03,
                            vertical: Responsive.isDesktop(context)
                                ? h * 0.065
                                : h * 0.03),
                        child: controller.registerApiResponse.status ==
                                Status.LOADING
                            ? showCircular()
                            : MaterialButton(
                                onPressed: () {
                                  controller.userRegister();
                                },
                                color: Colors.black,
                                height: Responsive.isDesktop(context)
                                    ? h * 0.078
                                    : h * 0.058,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: w * 0.05),
                                    AppString.signUpText.boldRobotoTextStyle(
                                        fontSize: 16,
                                        fontColor: backGroundColor),
                                    Padding(
                                      padding: EdgeInsets.only(right: w * 0.03),
                                      child: assetImage(AppAssets.arrowIcon,
                                          height: h * 0.015),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            AppString.alreadyAccountText
                                .regularRobotoTextStyle(fontSize: 15),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: AppString.signInText
                                  .boldRobotoTextStyle(fontSize: 17)
                                  .paddingOnly(top: h * 0.0045),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

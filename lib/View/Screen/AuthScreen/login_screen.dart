import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/View/Screen/AuthScreen/auth_controller.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Widgets/text_field.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authScreenController = Get.put(AuthController());
  @override
  // void initState() {
  //   authScreenController.checkGps();
  //   authScreenController.getLocation();
  //   super.initState();
  // }

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
                  padding: EdgeInsets.symmetric(horizontal: w * 0.065),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.035),
                        child: Center(
                          child: assetImage(AppAssets.appLogo, height: h * 0.14),
                        ),
                      ),
                      AppString.loginHeadingText.boldRobotoTextStyle(fontSize: 22),
                      AppString.loginSubHeadingText.regularBarlowTextStyle(fontSize: 15),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.045),
                        child: AppString.userName
                            .semiBoldBarlowTextStyle(fontSize: 15, fontColor: greyTextColor)
                            .paddingSymmetric(horizontal: w * 0.015),
                      ),
                      AppTextField(
                        controller: controller.loginEmailController,
                        icon: Icon(
                          Icons.person,
                          size: Responsive.isDesktop(context)
                              ? h * 0.04
                              : Responsive.isTablet(context)
                                  ? h * 0.031
                                  : h * 0.025,
                        ).paddingOnly(right: Responsive.isDesktop(context) ? w * 0.02 : 0),
                        // icon: Image.asset(AppAssets.mailIcon, scale: 2),
                        hintText: AppString.emailEnterText,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Responsive.isDesktop(context) ? h * 0.03 : h * 0.015),
                        child: AppString.passwordText
                            .semiBoldBarlowTextStyle(fontSize: 15, fontColor: greyTextColor)
                            .paddingSymmetric(horizontal: w * 0.015),
                      ),
                      AppTextField(
                        obscure: !controller.isVisible,
                        controller: controller.passwordController,
                        icon: GestureDetector(
                          onTap: () {
                            controller.isObSecure();
                          },
                          child: Icon(
                            controller.isVisible ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                            color: Colors.black,
                            size: Responsive.isDesktop(context)
                                ? h * 0.04
                                : Responsive.isTablet(context)
                                    ? h * 0.031
                                    : h * 0.025,
                          ).paddingOnly(right: Responsive.isDesktop(context) ? w * 0.02 : 0),
                        ),
                        hintText: AppString.passwordHint,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Responsive.isDesktop(context) ? h * 0.04 : h * 0.015, bottom: h * 0.037),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.forGotPasswordScreen);
                            },
                            child: AppString.forgotPasswordText.semiBoldBarlowTextStyle(fontSize: 14, fontColor: greyTextColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03)
                            .copyWith(bottom: Responsive.isDesktop(context) ? h * 0.08 : h * 0.14),
                        child: controller.loginApiResponse.status == Status.LOADING
                            ? showCircular()
                            : MaterialButton(
                                onPressed: () async {
                                  await controller.userLogin(screen: "login");
                                  // await controller.locationData();
                                },
                                color: Colors.black,
                                height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: w * 0.05),
                                    AppString.signInText.boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
                                    Padding(
                                      padding: EdgeInsets.only(right: w * 0.03),
                                      child: assetImage(AppAssets.arrowIcon, height: h * 0.015),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            AppString.dontHaveAccountText.regularRobotoTextStyle(fontSize: 15),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.registerScreen);
                              },
                              child: AppString.signUpText.boldRobotoTextStyle(fontSize: 17).paddingOnly(top: h * 0.0045),
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

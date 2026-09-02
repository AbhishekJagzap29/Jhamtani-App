import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      if (preferences.getString(SharedPreference.isLogin) == "true") {
        Get.offAllNamed(Routes.bottomBar);
      } else {
        Get.offAllNamed(Routes.introScreen);
      }
    });
  }

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backGroundColor,
          body: Center(
            child: assetImage(AppAssets.appLogo1,
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.45),
          ),
        ),
      ),
    );
  }
}

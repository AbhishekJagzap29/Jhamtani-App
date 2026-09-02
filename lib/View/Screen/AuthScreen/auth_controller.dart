import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/auth_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/login_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/register_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/Api/Services/base_service.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';

class AuthController extends GetxController {
  final loginEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNOController = TextEditingController();
  final userTypeController = TextEditingController();
  final passWordController = TextEditingController();
  String selectType = 'Select Type';
  bool isVisible = false;

  changeUserType(String value) {
    selectType = value;
    update();
  }

  isObSecure() {
    isVisible = !isVisible;
    update();
  }

  bool isResVisible = false;

  resIsObSecure() {
    isResVisible = !isResVisible;
    update();
  }

  /// LOGIN VIEW MODEl

  ApiResponse _loginApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get loginApiResponse => _loginApiResponse;

  Future<dynamic> userLogin({String? screen}) async {
    hideKeyBoard(Get.overlayContext!);

    if (screen == "change_password") {
      if (preferences.getString(SharedPreference.userName).toString().isEmpty) {
        errorSnackBar("Required Field", 'Please enter login details');
      } else if (preferences
          .getString(SharedPreference.userPassword)
          .toString()
          .isEmpty) {
        errorSnackBar("Required Field", 'Please enter password');
      } else {
        _loginApiResponse = ApiResponse.loading(message: 'Loading');
        update();
        try {
          Map<String, dynamic> body = {
            "db": ApiRouts.databaseName,
            "login":
                preferences.getString(SharedPreference.userName).toString(),
            "password":
                preferences.getString(SharedPreference.userPassword).toString(),
          };
          log('body==========>>>>>> ${body}');


          LoginResponseModel response = await AuthRepo().loginRepo(body: body);
          _loginApiResponse = ApiResponse.complete(response);

          log('response==========>>>>>> ${response}');

          if (response.uid != null) {

            preferences.putString(
                SharedPreference.userLoginData, jsonEncode(response));
            preferences.putString(
                SharedPreference.userId, response.uid.toString());
            // preferences.putString(
            //     SharedPreference.userType, response.userType ?? "");
           preferences.putString(
  SharedPreference.userType,
  (response.userType ?? []).join(','), 
);
            preferences.putString(
                SharedPreference.userName, response.username ?? '');
           
            if (response.uid != null) {
              sendOneSignalData(response.uid);
            }
          } else {
            errorSnackBar(
                "Login Failed", 'Please enter correct username and password');
            preferences.logOut();
          }

          log("_loginApiResponse==>$response");
        } catch (e) {
          _loginApiResponse = ApiResponse.error(message: e.toString());
          if (e.toString() == "Error During Communication:No Internet access") {
            errorSnackBar("Login Failed", "Please turn on your internet!");
          }
          preferences.logOut();
          log("_loginApiResponse=ERROR=>$e");
        }
      }

      update();
    } else {
      if (loginEmailController.text.isEmpty &&
          passwordController.text.isEmpty) {
        errorSnackBar("Required Field", 'Please enter login details');
      } else if (loginEmailController.text.isEmpty) {
        errorSnackBar("Required Field", 'Please enter email address');
      }
      // else if (!loginEmailController.text.isValidEmail()) {
      //   showERRORSnackBar('Please enter valid email address');
      // }
      else if (passwordController.text.isEmpty) {
        errorSnackBar("Required Field", 'Please enter password');
      } else {
        _loginApiResponse = ApiResponse.loading(message: 'Loading');
        update();
        try {
          Map<String, dynamic> body = {
            "db": ApiRouts.databaseName,
            "login": loginEmailController.text.toString().trim(),
            "password": passwordController.text.toString().trim(),
          };

          log('body==========>>>>>> ${body}');

          LoginResponseModel response = await AuthRepo().loginRepo(body: body);
          _loginApiResponse = ApiResponse.complete(response);

          log('response==========>>>>>> ${response}');

          if (response.uid != null) {
            preferences.putString(SharedPreference.isLogin, "true");
            preferences.putBool(
                SharedPreference.isAdmin, response.isAdmin ?? false);
            preferences.putString(
                SharedPreference.userLoginData, jsonEncode(response));
            preferences.putString(
                SharedPreference.userId, response.uid.toString());
            // preferences.putString(
            //    SharedPreference.userType, response.userType ?? "");
preferences.putString(
  SharedPreference.userType,
  (response.userType ?? []).join(','), // converts List<String> to "maker,hqi_maker"
);
            preferences.putString(SharedPreference.userPassword,
                passwordController.text.toString().trim());
            preferences.putString(
                SharedPreference.userName, response.username ?? '');
            preferences.putBool(SharedPreference.del_activity_users,
                response.del_activity_users ?? false);
            Get.offAllNamed(Routes.bottomBar);
            Future.delayed(
              const Duration(milliseconds: 500),
            ).then(
              (value) =>
                  successSnackBar("Success", 'Welcome, Login successfully'),
            );

            if (response.uid != null) {
              sendOneSignalData(response.uid);
            }
          } else {
            errorSnackBar(
                "Login Failed", 'Please enter correct username and password');
          }

          log("_loginApiResponse==>$response");
        } catch (e) {
          _loginApiResponse = ApiResponse.error(message: e.toString());
          if (e.toString() == "Error During Communication:No Internet access") {
            errorSnackBar("Login Failed", "Please turn on your internet!");
          }

          log("_loginApiResponse=ERROR=>$e");
        }
      }

      update();
    }
  }

  /// REGISTER VIEW MODEl

  ApiResponse _registerApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get registerApiResponse => _registerApiResponse;

  Future<dynamic> userRegister() async {
    hideKeyBoard(Get.overlayContext!);
    if (nameController.text.isEmpty &&
        emailController.text.isEmpty &&
        passWordController.text.isEmpty &&
        selectType == "Select Type") {
      errorSnackBar("Required Field", 'Please enter sign up details');
    } else if (nameController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter name');
    } else if (emailController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter email address');
    }
    // else if (!emailController.text.isValidEmail()) {
    //   showERRORSnackBar('Please enter valid email address');
    // }
    else if (selectType == "Select Type") {
      errorSnackBar("Required Field", 'Please select user type');
    } else if (passWordController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter password');
    } else {
      _registerApiResponse = ApiResponse.loading(message: 'Loading');
      update();
      try {
        Map<String, dynamic> body = {
          "name": nameController.text,
          "email": emailController.text,
          "password": passWordController.text,
          if (selectType == "Maker") "maker": 1,
          if (selectType == "Checker") "checker": 1,
          if (selectType == "Approver") "approver": 1,
        };
        RegisterResponseModel response =
            await AuthRepo().registerRepo(body: body);

        _registerApiResponse = ApiResponse.complete(response);

        if (response.status == "SUCCESS") {
          Future.delayed(const Duration(milliseconds: 500)).then((value) =>
              successSnackBar(
                  "Register Success", 'Register successfully, Please login'));
          Get.offAllNamed(Routes.loginScreen);
        } else {
          errorSnackBar("Register Failed", '${response.message}');
        }

        log("_registerApiResponse==>$response");
      } catch (e) {
        _registerApiResponse = ApiResponse.error(message: e.toString());

        if (e.toString() == "Error During Communication:No Internet access") {
          errorSnackBar("Register Failed", "Please turn on your internet!");
        }

        log("_registerApiResponse=ERROR=>$e");
      }
    }

    update();
  }

  /// SEND ONE SIGNAL DATA

  ApiResponse _sendOneSignalDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get sendOneSignalDataApiResponse => _sendOneSignalDataApiResponse;

  Future<dynamic> sendOneSignalData(id) async {
    final data = OneSignal.User.pushSubscription;
    final String playerId = data.id.toString();
    final String token = data.token.toString();
    print('===========ID======>${data.id}');
    print('===========TOKEN======>${data.token}');

    try {
      Map<String, dynamic> body = {
        "id": id.toString(),
        "player_id": playerId.toString(),
        "token": token.toString(),
      };
      SuccessDataResponseModel response =
          await AuthRepo().sendOneSignalData(body: body);

      _sendOneSignalDataApiResponse = ApiResponse.complete(response);

      log("_sendOneSignalDataApiResponse==>$response");
    } catch (e) {
      _sendOneSignalDataApiResponse = ApiResponse.error(message: e.toString());
      log("_sendOneSignalDataApiResponse=ERROR=>$e");
    }
    update();
  }

  // ///Current Location
  // bool services = false;
  // bool hasPermission = false;
  // late LocationPermission permission;
  // late Position position;
  // String lat = "";
  // String long = "";

  // /// Check Gps
  // Future checkGps() async {
  //   services = await Geolocator.isLocationServiceEnabled();
  //   if (services) {
  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         log('Location permissions are denied');
  //       } else if (permission == LocationPermission.deniedForever) {
  //         log("'Location permissions are permanently denied");
  //       } else {
  //         hasPermission = true;
  //       }
  //     } else {
  //       hasPermission = true;
  //     }
  //
  //     if (hasPermission) {
  //       getLocation();
  //       update();
  //     }
  //   } else {
  //     log("GPS Service is not enabled, turn on GPS location");
  //   }
  //   update();
  // }

  // /// Get Location
  // void getLocation() async {
  //   position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   long = position.longitude.toString();
  //   lat = position.latitude.toString();
  //   update();
  //   LocationSettings locationSettings = const LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 100,
  //   );
  //
  //   StreamSubscription<Position> positionStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position position) {
  //     long = position.longitude.toString();
  //     lat = position.latitude.toString();
  //     update();
  //   });
  // }

  // /// LOCATION VIEW MODEl
  //
  // ApiResponse _locationApiResponse =
  //     ApiResponse.initial(message: 'Initialization');
  //
  // ApiResponse get locationApiResponse => _locationApiResponse;
  //
  // Future<dynamic> locationData() async {
  //   _locationApiResponse = ApiResponse.loading(message: 'Loading');
  //   Map<String, dynamic> body = {
  //     "lat": lat,
  //     "long": long,
  //   };
  //   try {
  //     SuccessDataResponseModel response =
  //         await AuthRepo().locationRepo(body: body);
  //
  //     _locationApiResponse = ApiResponse.complete(response);
  //
  //     log("_locationApiResponse==>$response");
  //   } catch (e) {
  //     _locationApiResponse = ApiResponse.error(message: e.toString());
  //     log("_locationApiResponse=ERROR=>$e");
  //   }
  //   update();
  // }
}

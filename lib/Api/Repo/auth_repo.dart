import 'dart:developer';
import 'package:jhamtani_app/Api/ResponseModel/login_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/register_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/Api/Services/api_service.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import '../Services/base_service.dart';

class AuthRepo {
  Map<String, String> header = {
    'Content-Type': 'application/json',
  };
  Map<String, String> header1 = {
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// LOGIN REPO

  Future<dynamic> loginRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.loginAPI,
      apiType: APIType.aPost,
      body: body,
      header: header,
    );

    log('loginResponseModel----123----response>> $response');

    LoginResponseModel loginResponseModel =
        LoginResponseModel.fromJson(response);

    log('loginResponseModel --- response>> $loginResponseModel');

    return loginResponseModel;
  }

  /// REGISTER REPO

  Future<dynamic> registerRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.registerAPI,
      apiType: APIType.aPost,
      body: body,
      header: header,
    );

    log('registerResponseModel --- response>> $response');

    RegisterResponseModel registerResponseModel =
        RegisterResponseModel.fromJson(response);

    log('registerResponseModel --- response>> $response');

    return registerResponseModel;
  }

  /// ONE SIGNAL NOTIFICATION

  Future<dynamic> sendOneSignalData({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.oneSignal,
      apiType: APIType.aPost,
      body: body,
      header: header,
    );

    log('response --- response>> $response');

    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);

    log('successDataResponseModel --- response>> $successDataResponseModel');

    return successDataResponseModel;
  }




  // ///LOCATION AUTH REPO
  //
  // Future<dynamic> locationRepo({Map<String, dynamic>? body}) async {
  //   log("------->>>>>header----$header1");
  //   var response = await APIService().getResponse(
  //     url: ApiRouts.userLocation,
  //     apiType: APIType.aPost,
  //     body: body,
  //     header: header1,
  //   );
  //
  //   log('locationResponseModel----123----response>> $response');
  //
  //   SuccessDataResponseModel locationResponseModel =
  //       SuccessDataResponseModel.fromJson(response);
  //
  //   log('locationResponseModel --- response>> $locationResponseModel');
  //
  //   return locationResponseModel;
  // }
}

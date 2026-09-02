import 'dart:developer';

import 'package:jhamtani_app/Api/ResponseModel/get_report_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_tower_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/Api/Services/api_service.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';

import '../Services/base_service.dart';

class ReportRepo {
  Map<String, String> header = {
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };
  Map<String, String> header1 = {
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// Add Checker Report :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> addCheckerReportRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.addCheckReport,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    SuccessDataResponseModel successDataResponseModel =
        SuccessDataResponseModel.fromJson(response);
    log('addCheckerReportRepo --- response>> $response');
    return successDataResponseModel;
  }

  /// Get Tower Data :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getTowerRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getTower,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    GetTowerResponseModel getTowerResponseModel =
        GetTowerResponseModel.fromJson(response);
    log('getTowerResponseModel --- response>> $response');
    return getTowerResponseModel;
  }

  /// Get Report Data :::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> getReportRepo({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getReport,
      apiType: APIType.aPost,
      body: body,
      header: header1,
    );

    GetReportResponseModel getReportResponseModel =
        GetReportResponseModel.fromJson(response);
    log('getReportResponseModel --- response>> $response');
    return getReportResponseModel;
  }

  Future<dynamic> updateReportRepo(Map<String, dynamic> body) async {
    var response = await APIService().getResponse(
        url: ApiRouts.updateReport,
        apiType: APIType.aPost,
        body: body,
        header: header1);

    SuccessDataResponseModel successDataResponseModel =
    SuccessDataResponseModel.fromJson(response);
    log('updateReportRepo --- response>> $response');

    return successDataResponseModel;
  }
}

import 'dart:convert';

import 'package:jhamtani_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';

GetCheckPointDetailsByActivityTypeId getCheckPointDetailsByActivityTypeIdFromJson(String str) =>
    GetCheckPointDetailsByActivityTypeId.fromJson(json.decode(str));

String getCheckPointDetailsByActivityTypeIdToJson(GetCheckPointDetailsByActivityTypeId data) =>
    json.encode(data.toJson());

class GetCheckPointDetailsByActivityTypeId {
  String? status;
  String? message;
  ListChecklistDataByAc? activityData;

  GetCheckPointDetailsByActivityTypeId({
    this.status,
    this.message,
    this.activityData,
  });

  factory GetCheckPointDetailsByActivityTypeId.fromJson(Map<String, dynamic> json) =>
      GetCheckPointDetailsByActivityTypeId(
        status: json["status"],
        message: json["message"],
        activityData:
            json["activity_data"] == null ? null : ListChecklistDataByAc.fromJson(json["activity_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "activity_data": activityData?.toJson(),
      };
}

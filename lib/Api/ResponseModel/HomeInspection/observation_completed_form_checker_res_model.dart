import 'dart:convert';

ObservationCompleteeckerFromChResponseModel observationCompleteeckerFromChResponseModelFromJson(String str) =>
    ObservationCompleteeckerFromChResponseModel.fromJson(json.decode(str));

String observationCompleteeckerFromChResponseModelToJson(ObservationCompleteeckerFromChResponseModel data) =>
    json.encode(data.toJson());

class ObservationCompleteeckerFromChResponseModel {
  String? status;
  String? message;
  List<ObservationCompleteData>? data;

  ObservationCompleteeckerFromChResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory ObservationCompleteeckerFromChResponseModel.fromJson(Map<String, dynamic> json) =>
      ObservationCompleteeckerFromChResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ObservationCompleteData>.from(
                json["data"].map((x) => ObservationCompleteData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.map((x) => x.toJson()).toList(),
      };
}

class ObservationCompleteData {
  int? observationId;
  String? status;
  String? completedDate;
  String? remark;

  ObservationCompleteData({
    this.observationId,
    this.status,
    this.completedDate,
    this.remark,
  });

  factory ObservationCompleteData.fromJson(Map<String, dynamic> json) =>
      ObservationCompleteData(
        observationId: json["observation_id"],
        status: json["status"],
        completedDate: json["completed_date"],
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "observation_id": observationId,
        "status": status,
        "completed_date": completedDate,
        "remark": remark,
      };
}

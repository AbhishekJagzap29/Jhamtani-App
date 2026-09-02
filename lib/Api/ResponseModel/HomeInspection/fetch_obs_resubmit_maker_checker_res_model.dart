import 'dart:convert';

FetchMakerObservationDetailsModel fetchMakerObservationDetailsModelFromJson(String str) =>
    FetchMakerObservationDetailsModel.fromJson(json.decode(str));

String fetchMakerObservationDetailsModelToJson(FetchMakerObservationDetailsModel data) =>
    json.encode(data.toJson());

class FetchMakerObservationDetailsModel {
  String? status;
  String? message;
  MakerObservationData? data;

  FetchMakerObservationDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory FetchMakerObservationDetailsModel.fromJson(Map<String, dynamic> json) =>
      FetchMakerObservationDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? MakerObservationData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class MakerObservationData {
  int? observationId;
  String? date;
  String? targetDate;
  String? issueCategory;
  String? issueType;
  String? remark;
  List<String>? makerUploadedImg;
    List<String>? checkerUploadedImg;


  MakerObservationData({
    this.observationId,
    this.date,
    this.targetDate,
    this.issueCategory,
    this.issueType,
    this.remark,
    this.makerUploadedImg,
    this.checkerUploadedImg,
  });

  factory MakerObservationData.fromJson(Map<String, dynamic> json) =>
      MakerObservationData(
        observationId: json["observation_id"],
        date: json["date"],
        targetDate: json["target_date"],
        issueCategory: json["issue_category"],
        issueType: json["issue_type"],
        remark: json["remark"],
        makerUploadedImg: json["maker_uploaded_img"] != null
            ? List<String>.from(json["maker_uploaded_img"])
            : [],

              checkerUploadedImg: json["checker_uploaded_img"] != null
            ? List<String>.from(json["checker_uploaded_img"])
            : [],
      );

  Map<String, dynamic> toJson() => {
        "observation_id": observationId,
        "date": date,
        "target_date": targetDate,
        "issue_category": issueCategory,
        "issue_type": issueType,
        "remark": remark,
        "maker_uploaded_img": makerUploadedImg,
                "checker_uploaded_img": checkerUploadedImg,

      };
}

import 'dart:convert';

ResubmitToCheckerResponseModel resubmitToCheckerResponseModelFromJson(String str) =>
    ResubmitToCheckerResponseModel.fromJson(json.decode(str));

String resubmitToCheckerResponseModelToJson(ResubmitToCheckerResponseModel data) =>
    json.encode(data.toJson());

class ResubmitToCheckerResponseModel {
  String? status;
  String? message;
  ResubmitToCheckerData? data; 
  ResubmitToCheckerResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory ResubmitToCheckerResponseModel.fromJson(Map<String, dynamic> json) =>
      ResubmitToCheckerResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? ResubmitToCheckerData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ResubmitToCheckerData {
  int? id;
  String? name;
  int? userId;
  String? date;
  String? targetDate;
  String? remark;
  List<String>? makerUploadedImg;
  List<String>? checkerUploadedImg;
  String? observationCategory;
  String? impactType;

  ResubmitToCheckerData({
    this.id,
    this.name,
    this.userId,
    this.date,
    this.targetDate,
    this.remark,
    this.makerUploadedImg,
    this.checkerUploadedImg,
    this.observationCategory,
    this.impactType,
  });


  factory ResubmitToCheckerData.fromJson(Map<String, dynamic> json) =>
      ResubmitToCheckerData(
        id: json["observation_id"],
        name: json["name"],
        userId: json["user_id"],
        date: json["date"],
        targetDate: json["target_date"],
        impactType: json["impact_type"],
        remark: json["remark"],
        makerUploadedImg: json["maker_uploaded_img"] != null
            ? List<String>.from(json["maker_uploaded_img"])
            : [],
             checkerUploadedImg: json["checker_uploaded_img"] != null
            ? List<String>.from(json["checker_uploaded_img"])
            : [],
        observationCategory:json["observation_category"],
      );

  Map<String, dynamic> toJson() => {
        "observation_id": id,
        "name": name,
        "user_id": userId,
        "date": date,
        "target_date": targetDate,
        "remark": remark,
        "maker_uploaded_img": makerUploadedImg,
        "checker_uploaded_img": checkerUploadedImg,
        "observation_category":observationCategory,
        "impact_type": impactType,
      };
}

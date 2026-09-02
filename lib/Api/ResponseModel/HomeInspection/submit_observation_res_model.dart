import 'dart:convert';

SubmitObservationResponseModel submitObservationResponseModelFromJson(
        String str) =>
    SubmitObservationResponseModel.fromJson(json.decode(str));

String submitFlatObservationResponseModelToJson(
        SubmitObservationResponseModel data) =>
    json.encode(data.toJson());

class SubmitObservationResponseModel {
  String? status;
  String? message;
  ObservationData? data;

  SubmitObservationResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory SubmitObservationResponseModel.fromJson(Map<String, dynamic> json) =>
      SubmitObservationResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? ObservationData.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ObservationData {
  int? id;
  String? name;
  String? description;
  String? impact;
  int? userId;
  int? locationId;
  String? date;
  String? issueCategoryId;
  String? issueTypeId;
  List<String>? checkerUploadedImg;
  List<String>? makerUploadedImg; 
  String? remark;
  String? targetDate;
  //String? observationCategory;
  String? impactType;
  ObservationData({
    this.id,
    this.name,
    this.description,
    this.impact,
    this.userId,
    this.locationId,
    this.date,
    this.issueCategoryId,
    this.issueTypeId,
    this.checkerUploadedImg,
    this.makerUploadedImg,
    this.remark,
    this.targetDate,
   // this.observationCategory,
    this.impactType,
  });

  factory ObservationData.fromJson(Map<String, dynamic> json) =>
      ObservationData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        impact: json["impact"],
        userId: json["user_id"],
        locationId: json["location_id"],
        date: json["date"],
        targetDate: json["target_date"],
        remark: json["remark"],
        impactType: json["impact_type"],
        issueCategoryId: json["issue_category_id"]?.toString(),
        issueTypeId: json["issue_type_id"]?.toString(),
        checkerUploadedImg: json["checker_uploaded_img"] != null
            ? List<String>.from(json["checker_uploaded_img"])
            : [],
        makerUploadedImg: json["maker_uploaded_img"] != null
            ? List<String>.from(json["maker_uploaded_img"])
            : [],
        //    observationCategory: json["observation_category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "impact": impact,
        "user_id": userId,
        "location_id": locationId,
        "date": date,
        "remark":remark,
        "issue_category_id": issueCategoryId,
        "issue_type_id": issueTypeId,
        "checker_uploaded_img": checkerUploadedImg ?? [],
        "maker_uploaded_img": makerUploadedImg ?? [],
                "target_date": targetDate,
              //  "observation_category":observationCategory,
                "impact_type" : impactType,
      };
}

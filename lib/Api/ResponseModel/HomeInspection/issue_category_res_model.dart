import 'dart:convert';

IssueCategoryResponseModel issueCategoryResponseModelFromJson(String str) =>
    IssueCategoryResponseModel.fromJson(json.decode(str));

String issueCategoryResponseModelToJson(IssueCategoryResponseModel data) =>
    json.encode(data.toJson());

class IssueCategoryResponseModel {
  String? status;
  String? message;
  List<IssueCategoryData>? data;

  IssueCategoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory IssueCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      IssueCategoryResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<IssueCategoryData>.from(
                json["data"].map((x) => IssueCategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class IssueCategoryData {
  int? id;
  String? name;
  int? sequence;
  int ?userId;

  IssueCategoryData({
    this.id,
    this.name,
    this.sequence,
    this.userId
  });

  factory IssueCategoryData.fromJson(Map<String, dynamic> json) =>
      IssueCategoryData(
        id: json["issue_category_id"],
        name: json["name"],
        sequence: json["sequence"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "issue_category_id": id,
        "name": name,
        "sequence": sequence,
        "user_id": userId,
      };
}

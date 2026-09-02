import 'dart:convert';

IssueTypeResponseModel issueTypeResponseModelFromJson(String str) =>
    IssueTypeResponseModel.fromJson(json.decode(str));

String issueTypeResponseModelToJson(IssueTypeResponseModel data) =>
    json.encode(data.toJson());

class IssueTypeResponseModel {
  String? status;
  String? message;
  List<IssueTypeData>? data;

  IssueTypeResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory IssueTypeResponseModel.fromJson(Map<String, dynamic> json) =>
      IssueTypeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<IssueTypeData>.from(
                json["data"].map((x) => IssueTypeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class IssueTypeData {
  int? id;
  String? name;
  int? sequence;
  int? userId;

  IssueTypeData({
    this.id,
    this.name,
    this.sequence,
    int?userId,
  });

  factory IssueTypeData.fromJson(Map<String, dynamic> json) => IssueTypeData(
        id: json["issue_type_id"],
        name: json["name"],
        sequence: json["sequence"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "issue_type_id": id,
        "name": name,
        "sequence": sequence,
        "user_id":userId,
      };
}

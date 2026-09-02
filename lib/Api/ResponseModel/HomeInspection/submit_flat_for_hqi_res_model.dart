import 'dart:convert';

SubmitFlatForHQIResponseModel submitFlatForHQIResponseModelFromJson(String str) =>
    SubmitFlatForHQIResponseModel.fromJson(json.decode(str));

String submitFlatForHQIResponseModelToJson(SubmitFlatForHQIResponseModel data) =>
    json.encode(data.toJson());

class SubmitFlatForHQIResponseModel {
  String? status;
  String? message;
  List<SubmitFlatData>? data;

  SubmitFlatForHQIResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory SubmitFlatForHQIResponseModel.fromJson(Map<String, dynamic> json) =>
      SubmitFlatForHQIResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SubmitFlatData>.from(
                json["data"].map((x) => SubmitFlatData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SubmitFlatData {
  int? id;
  String? name;
  int? sequence;
  int? userId;

  SubmitFlatData({
    this.id,
    this.name,
    this.sequence,
    this.userId,
  });

  factory SubmitFlatData.fromJson(Map<String, dynamic> json) =>
      SubmitFlatData(
        id: json["id"],
        name: json["name"],
        sequence: json["sequence"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sequence": sequence,
        "user_id": userId,
      };
}

import 'dart:convert';

CompleteForHQIResponseModel completeForHQIResponseModelFromJson(String str) =>
    CompleteForHQIResponseModel.fromJson(json.decode(str));

String completeForHQIResponseModelModelToJson(
        CompleteForHQIResponseModel data) =>
    json.encode(data.toJson());

class CompleteForHQIResponseModel {
  String? status;
  String? message;
  List<CompleteForHqi>? data;

  CompleteForHQIResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CompleteForHQIResponseModel.fromJson(Map<String, dynamic> json) =>
      CompleteForHQIResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CompleteForHqi>.from(
                json["data"].map((x) => CompleteForHqi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CompleteForHqi {
  int? id;
  String? name;

  CompleteForHqi({
    this.id,
    this.name,
  });

  factory CompleteForHqi.fromJson(Map<String, dynamic> json) => CompleteForHqi(
        id: json["issue_type_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "issue_type_id": id,
        "name": name,
      };
}

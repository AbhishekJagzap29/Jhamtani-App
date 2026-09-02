import 'dart:convert';

RegisterResponseModel registerResponseModelFromJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) =>
    json.encode(data.toJson());

class RegisterResponseModel {
  String? status;
  String? message;

  RegisterResponseModel({
    this.status,
    this.message,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}

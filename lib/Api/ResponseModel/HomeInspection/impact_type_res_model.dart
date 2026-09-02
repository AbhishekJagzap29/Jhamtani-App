import 'dart:convert';

ImpactTypeResponseModel impactTypeResponseModelFromJson(String str) =>
    ImpactTypeResponseModel.fromJson(json.decode(str));

String impactTypeResponseModelToJson(ImpactTypeResponseModel data) =>
    json.encode(data.toJson());

class ImpactTypeResponseModel {
  String? status;
  String? message;
  List<ImpactTypeData>? data;

  ImpactTypeResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory ImpactTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return ImpactTypeResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] == null
          ? []
          : List<ImpactTypeData>.from(
              json['data'].map(
                (x) => ImpactTypeData.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data == null
            ? []
            : List<dynamic>.from(
                data!.map((x) => x.toJson()),
              ),
      };
}

class ImpactTypeData {
  String? key;
  String? name;

  ImpactTypeData({
    this.key,
    this.name,
  });

  factory ImpactTypeData.fromJson(Map<String, dynamic> json) {
    return ImpactTypeData(
      key: json['key']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
      };
}
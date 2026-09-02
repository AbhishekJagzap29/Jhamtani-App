// import 'dart:convert';

// GetHQITowersResponseModel getHQITowersResponseModelFromJson(String str) =>
//     GetHQITowersResponseModel.fromJson(json.decode(str));

// String getHQITowersResponseModelToJson(GetHQITowersResponseModel data) =>
//     json.encode(data.toJson());

// class GetHQITowersResponseModel {
//   String? status;
//   String? message;
//   List<HQITower>? data;

//   GetHQITowersResponseModel({this.status, this.message, this.data});

//   factory GetHQITowersResponseModel.fromJson(Map<String, dynamic> json) =>
//       GetHQITowersResponseModel(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null
//             ? []
//             : List<HQITower>.from(
//                 json["data"].map((x) => HQITower.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class HQITower {
//   int? id;
//   String? name;
//   int? userId;

//   HQITower({this.id, this.name, this.userId});

//   factory HQITower.fromJson(Map<String, dynamic> json) => HQITower(
//         id: json["tower_id"],
//         name: json["name"],
//                 userId: json["user_id"],

//       );

//   Map<String, dynamic> toJson() => {
//         "tower_id": id,
//         "name": name,
//         "user_id": userId,
//       };
// }









import 'dart:convert';

GetHQITowersResponseModel getHQITowersResponseModelFromJson(String str) =>
    GetHQITowersResponseModel.fromJson(json.decode(str));

String getHQITowersResponseModelToJson(GetHQITowersResponseModel data) =>
    json.encode(data.toJson());

class GetHQITowersResponseModel {
  String? status;
  String? message;
  HQIData? data;

  GetHQITowersResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetHQITowersResponseModel.fromJson(Map<String, dynamic> json) =>
      GetHQITowersResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? HQIData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class HQIData {
  String? checklistName;
  String? imageUrl;
  List<HQITower>? towerData;

  HQIData({
    this.checklistName,
    this.imageUrl,
    this.towerData,
  });

  factory HQIData.fromJson(Map<String, dynamic> json) => HQIData(
        checklistName: json["checklist_name"],
        imageUrl: json["image_url"],
        towerData: json["tower_data"] != null
            ? List<HQITower>.from(
                json["tower_data"].map((x) => HQITower.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "checklist_name": checklistName,
        "image_url": imageUrl,
        "tower_data": towerData != null
            ? List<dynamic>.from(towerData!.map((x) => x.toJson()))
            : [],
      };
}

class HQITower {
  int? id;
  String? name;
  double? progress;

  HQITower({
    this.id,
    this.name,
    this.progress,
  });

  factory HQITower.fromJson(Map<String, dynamic> json) => HQITower(
        id: json["tower_id"],
        name: json["name"],
        progress: (json["progress"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "tower_id": id,
        "name": name,
        "progress": progress,
      };
}

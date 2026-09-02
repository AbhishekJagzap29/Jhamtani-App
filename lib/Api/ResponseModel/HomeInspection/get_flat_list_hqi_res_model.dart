import 'dart:convert';

FlatListForHQIResponseModel flatListForHQIResponseModelFromJson(String str) =>
    FlatListForHQIResponseModel.fromJson(json.decode(str));

String flatListForHQIResponseModeloJson(FlatListForHQIResponseModel data) =>
    json.encode(data.toJson());

class FlatListForHQIResponseModel {
  String? status;
  String? message;
  List<HQIFlatData>? data;

  FlatListForHQIResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FlatListForHQIResponseModel.fromJson(Map<String, dynamic> json) =>
      FlatListForHQIResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<HQIFlatData>.from(
                json["data"].map((x) => HQIFlatData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HQIFlatData {
  int? id;
  String? name;
  int? sequence;
  String? progress;
  int? userId;
  double? flatHQIProgressPercentage;
   bool isHQICompleted;

  HQIFlatData({
    this.id,
    this.name,
    this.sequence,
    this.progress,
    this.userId,
    this.flatHQIProgressPercentage,
    this.isHQICompleted = false,
  });

  factory HQIFlatData.fromJson(Map<String, dynamic> json) => HQIFlatData(
      id: json["flat_id"],
      name: json["flat_name"],
      sequence: json["sequence"],
      progress: json["progress"].toString(),
      userId: json["user_id"],
      flatHQIProgressPercentage: json["flat_hqi_progress_percentage"]);


  Map<String, dynamic> toJson() => {
        "flat_id": id,
        "flat_name": name,
        "sequence": sequence,
        "progress": progress,
        "user_id": userId,
        "flat_hqi_progress_percentage":
            flatHQIProgressPercentage, };
}

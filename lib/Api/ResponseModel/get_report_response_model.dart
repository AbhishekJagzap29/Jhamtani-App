// To parse this JSON data, do
//
//     final getReportResponseModel = getReportResponseModelFromJson(jsonString);

import 'dart:convert';

GetReportResponseModel getReportResponseModelFromJson(String str) => GetReportResponseModel.fromJson(json.decode(str));

String getReportResponseModelToJson(GetReportResponseModel data) => json.encode(data.toJson());

class GetReportResponseModel {
  String? status;
  String? message;
  List<TowerDatum>? towerData;

  GetReportResponseModel({
    this.status,
    this.message,
    this.towerData,
  });

  GetReportResponseModel copyWith({
    String? status,
    String? message,
    List<TowerDatum>? towerData,
  }) =>
      GetReportResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        towerData: towerData ?? this.towerData,
      );

  factory GetReportResponseModel.fromJson(Map<String, dynamic> json) => GetReportResponseModel(
    status: json["status"],
    message: json["message"],
    towerData: json["tower_data"] == null ? [] : List<TowerDatum>.from(json["tower_data"]!.map((x) => TowerDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "tower_data": towerData == null ? [] : List<dynamic>.from(towerData!.map((x) => x.toJson())),
  };
}

class TowerDatum {
  int? trainingReportId;
  String? projectInfoId;
  String? projectName;
  String? userId;
  DateTime? trainingDatedOn;
  String? topicOfTraining;
  String? towerId;
  String? towerName;
  String? trainerName;
  String? trainingStartTime;
  String? trainingEndTime;
  String? totalDuration;
  String? totalManhours;
  String? description;
  String? location;
  List<TrainingGivenTo>? trainingGivenTo;
  List<String>? overallImages;

  TowerDatum({
    this.trainingReportId,
    this.projectInfoId,
    this.projectName,
    this.userId,
    this.trainingDatedOn,
    this.topicOfTraining,
    this.towerId,
    this.towerName,
    this.trainerName,
    this.trainingStartTime,
    this.trainingEndTime,
    this.totalDuration,
    this.totalManhours,
    this.description,
    this.location,
    this.trainingGivenTo,
    this.overallImages,
  });

  TowerDatum copyWith({
    int? trainingReportId,
    String? projectInfoId,
    String? projectName,
    String? userId,
    DateTime? trainingDatedOn,
    String? topicOfTraining,
    String? towerId,
    String? towerName,
    String? trainerName,
    String? trainingStartTime,
    String? trainingEndTime,
    String? totalDuration,
    String? totalManhours,
    String? description,
    String? location,
    List<TrainingGivenTo>? trainingGivenTo,
    List<String>? overallImages,
  }) =>
      TowerDatum(
        trainingReportId: trainingReportId ?? this.trainingReportId,
        projectInfoId: projectInfoId ?? this.projectInfoId,
        projectName: projectName ?? this.projectName,
        userId: userId ?? this.userId,
        trainingDatedOn: trainingDatedOn ?? this.trainingDatedOn,
        topicOfTraining: topicOfTraining ?? this.topicOfTraining,
        towerId: towerId ?? this.towerId,
        towerName: towerName ?? this.towerName,
        trainerName: trainerName ?? this.trainerName,
        trainingStartTime: trainingStartTime ?? this.trainingStartTime,
        trainingEndTime: trainingEndTime ?? this.trainingEndTime,
        totalDuration: totalDuration ?? this.totalDuration,
        totalManhours: totalManhours ?? this.totalManhours,
        description: description ?? this.description,
        location: location ?? this.location,
        trainingGivenTo: trainingGivenTo ?? this.trainingGivenTo,
        overallImages: overallImages ?? this.overallImages,
      );

  factory TowerDatum.fromJson(Map<String, dynamic> json) => TowerDatum(
    trainingReportId: json["training_report_id"],
    projectInfoId: json["project_info_id"],
    projectName: json["project_name"],
    userId: json["user_id"],
    trainingDatedOn: json["training_dated_on"] == null ? null : DateTime.parse(json["training_dated_on"]),
    topicOfTraining: json["topic_of_training"],
    towerId: json["tower_id"],
    towerName: json["tower_name"],
    trainerName: json["trainer_name"],
    trainingStartTime: json["training_start_time"],
    trainingEndTime: json["training_end_time"],
    totalDuration: json["total_duration"],
    totalManhours: json["total_manhours"],
    description: json["description"],
    location: json["location"],
    trainingGivenTo: json["training_given_to"] == null ? [] : List<TrainingGivenTo>.from(json["training_given_to"]!.map((x) => TrainingGivenTo.fromJson(x))),
    overallImages: json["overall_images"] == null ? [] : List<String>.from(json["overall_images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "training_report_id": trainingReportId,
    "project_info_id": projectInfoId,
    "project_name": projectName,
    "user_id": userId,
    "training_dated_on": "${trainingDatedOn!.year.toString().padLeft(4, '0')}-${trainingDatedOn!.month.toString().padLeft(2, '0')}-${trainingDatedOn!.day.toString().padLeft(2, '0')}",
    "topic_of_training": topicOfTraining,
    "tower_id": towerId,
    "tower_name": towerName,
    "trainer_name": trainerName,
    "training_start_time": trainingStartTime,
    "training_end_time": trainingEndTime,
    "total_duration": totalDuration,
    "total_manhours": totalManhours,
    "description": description,
    "location": location,
    "training_given_to": trainingGivenTo == null ? [] : List<dynamic>.from(trainingGivenTo!.map((x) => x.toJson())),
    "overall_images": overallImages == null ? [] : List<dynamic>.from(overallImages!.map((x) => x)),
  };
}

class TrainingGivenTo {
  String? name;
  String? tag;

  TrainingGivenTo({
    this.name,
    this.tag,
  });

  TrainingGivenTo copyWith({
    String? name,
    String? tag,
  }) =>
      TrainingGivenTo(
        name: name ?? this.name,
        tag: tag ?? this.tag,
      );

  factory TrainingGivenTo.fromJson(Map<String, dynamic> json) => TrainingGivenTo(
    name: json["name"],
    tag: json["tag"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "tag": tag,
  };
}




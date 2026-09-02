import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

MaterialInspectionPointsModel materialInspectionPointsModelFromJson(
        String str) =>
    MaterialInspectionPointsModel.fromJson(json.decode(str));

String materialInspectionPointsModelToJson(
        MaterialInspectionPointsModel data) =>
    json.encode(data.toJson());

class MaterialInspectionPointsModel {
  String? status;
  String? message;
  List<MiChecklist>? miChecklist;

  MaterialInspectionPointsModel({
    this.status,
    this.message,
    this.miChecklist,
  });

  factory MaterialInspectionPointsModel.fromJson(Map<String, dynamic> json) =>
      MaterialInspectionPointsModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
        miChecklist: json["mi_checklist"] == null ||
                json["mi_checklist"] == [] ||
                json["mi_checklist"].isEmpty
            ? []
            : List<MiChecklist>.from(
                json["mi_checklist"]!.map((x) => MiChecklist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "mi_checklist": miChecklist == null
            ? []
            : List<dynamic>.from(miChecklist!.map((x) => x.toJson())),
      };
}

class MiChecklist {
  int? id;
  String? name;
  TextEditingController controller;
  String isPass;
  int? checklistId;

  MiChecklist(
      {this.id,
      this.name,
      required this.controller,
      required this.isPass,
      this.checklistId});

  factory MiChecklist.fromJson(Map<String, dynamic> json) => MiChecklist(
        id: json["id"] ?? 0,
        name: json["name"].toString(),
        controller: json["controller"] ?? TextEditingController(),
        isPass: json["isPass"] ?? "yes",
        checklistId: json["checklist_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "controller": controller,
        "isPass": isPass,
        "checklist_id": checklistId
      };
}

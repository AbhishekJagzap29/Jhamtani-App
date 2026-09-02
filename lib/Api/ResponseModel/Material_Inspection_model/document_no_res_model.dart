import 'dart:convert';

import 'package:flutter/services.dart';

DocumnetNumberResponseModel documnetNumberResponseModelFromJson(String str) =>
    DocumnetNumberResponseModel.fromJson(json.decode(str));

String documnetNumberResponseModelResponseModelToJson(DocumnetNumberResponseModel data) =>
    json.encode(data.toJson());

class DocumnetNumberResponseModel {
  String? status;
  String? message;
  final List<DocumentNumber> poData;

  DocumnetNumberResponseModel({
    this.status,
    this.message,
    required this.poData,
  });

  factory DocumnetNumberResponseModel.fromJson(Map<String, dynamic> json) {
    return DocumnetNumberResponseModel(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      poData: json["po_data"] != null
          ? List<DocumentNumber>.from(
              json["po_data"].map((x) => DocumentNumber.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "po_data": poData.map((x) => x.toJson()).toList(),
      };
}

class DocumentNumber {
  int poId; 
  String? docNo;

  DocumentNumber({
    required this.poId, 
    this.docNo,
  });

  factory DocumentNumber.fromJson(Map<String, dynamic> json) => DocumentNumber(
      poId: json["po_id"] ,
      docNo: json["doc_no"] ,

    );

  Map<String, dynamic> toJson() => {
        "po_id": poId,
        "doc_no": docNo,
      };
}
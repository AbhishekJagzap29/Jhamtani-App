import 'dart:convert';

UomCodeResponseModel uomCodeResponseModelFromJson(String str) =>
    UomCodeResponseModel.fromJson(json.decode(str));

String uomCodeResponseModelToJson(UomCodeResponseModel data) =>
    json.encode(data.toJson());

class UomCodeResponseModel {
  String? status;
  String? message;
  final List<UomCode> polineData;

  UomCodeResponseModel({
    this.status,
    this.message,
    required this.polineData,
  });

  factory UomCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return UomCodeResponseModel(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      polineData: json["poline_data"] != null
          ? List<UomCode>.from(
              json["poline_data"].map((x) => UomCode.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "poline_data": polineData.map((x) => x.toJson()).toList(),
      };
}

class UomCode {
  int? lineId;
  int? poId;
  String? uomCode; 
  
  UomCode({
    this.lineId,
    this.poId,
    this.uomCode,
  });

  factory UomCode.fromJson(Map<String, dynamic> json) {
    return UomCode(
      lineId: json["line_id"],
      poId: json["po_id"],
      uomCode: json["uom_code"], 
    );
  }

  Map<String, dynamic> toJson() => {
        "line_id": lineId,
        "po_id": poId,
        "uom_code": uomCode, 
      };
}

import 'dart:convert';

MaterialDescriptionResponseModel materialDescriptionResponseModelFromJson(String str) =>
    MaterialDescriptionResponseModel.fromJson(json.decode(str));

String materialDescriptionResponseModelToJson(MaterialDescriptionResponseModel data) =>
    json.encode(data.toJson());

class MaterialDescriptionResponseModel {
  String? status;
  String? message;
  final List<MaterialDescription> polineData;

  MaterialDescriptionResponseModel({
    this.status,
    this.message,
    required this.polineData,
  });

  factory MaterialDescriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return MaterialDescriptionResponseModel(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      polineData: json["poline_data"] != null
          ? List<MaterialDescription>.from(
              json["poline_data"].map((x) => MaterialDescription.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "poline_data": polineData.map((x) => x.toJson()).toList(),
      };
}

class MaterialDescription {
  String? description;
  String? ledgerDescription;
  double? quantity;
  String? uomCode;
  int? lineId;
  int? amendmentItemsId;
  double? pendingQuantity;

  MaterialDescription({
    this.description,
    this.ledgerDescription,
    this.quantity,
    this.uomCode,
    this.lineId,
    this.amendmentItemsId,
    this.pendingQuantity,
  });

  factory MaterialDescription.fromJson(Map<String, dynamic> json) {
    return MaterialDescription(
      description: json["description"] ?? "",
      ledgerDescription: json["ledger_description"] ?? "",
      quantity: json["quantity"] != null ? (json["quantity"] as num).toDouble() : null,
      uomCode: json["uom_code"]?.toString(),

     // uomCode: json["uom_code"] != null ? (json["uom_code"] as num).toDouble() : null,
      lineId: json["line_id"],
      amendmentItemsId: json["amendment_items_id"],
      pendingQuantity: json["pending_qty"] != null ? (json["pending_qty"] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "ledger_description": ledgerDescription,
        "quantity": quantity,
        "uom_code": uomCode,
        "line_id": lineId,
        "amendment_items_id": amendmentItemsId,
        "pending_qty":pendingQuantity,
      };
}

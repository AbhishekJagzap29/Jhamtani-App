import 'dart:convert';

LedgerDescriptionResponseModel ledgerDescriptionResponseModelFromJson(String str) =>
    LedgerDescriptionResponseModel.fromJson(json.decode(str));

String ledgerDescriptionResponseModelToJson(LedgerDescriptionResponseModel data) =>
    json.encode(data.toJson());

class LedgerDescriptionResponseModel {
  String? status;
  String? message;
  final List<LedgerDescription> poData;

  LedgerDescriptionResponseModel({
    this.status,
    this.message,
    required this.poData,
  });

  factory LedgerDescriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return LedgerDescriptionResponseModel(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      poData: json["po_data"] != null
          ? List<LedgerDescription>.from(
              json["po_data"].map((x) => LedgerDescription.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "po_data": poData.map((x) => x.toJson()).toList(),
      };
}

class LedgerDescription {
  List<int> poId;
  String? name;
  int ledgerId;

  LedgerDescription({
    required this.poId,
    this.name,
    required this.ledgerId,
  });

  factory LedgerDescription.fromJson(Map<String, dynamic> json) {
    return LedgerDescription(
      poId: json["po_ids"] != null ? List<int>.from(json["po_ids"]) : [],
      name: json["supplier_name"],
      ledgerId: json["ledger_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "po_ids": poId,
        "supplier_name": name,
        "ledger_id": ledgerId,
      };
}

import 'dart:convert';

MaterialCountResModel materialCountResModelFromJson(String str) =>
    MaterialCountResModel.fromJson(json.decode(str));

String materialCountResModelToJson(MaterialCountResModel data) =>
    json.encode(data.toJson());

class MaterialCountResModel {
  String? jsonrpc;
  dynamic id;
  CountData? result;

  MaterialCountResModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory MaterialCountResModel.fromJson(Map<String, dynamic> json) =>
      MaterialCountResModel(
        jsonrpc: json["jsonrpc"]?.toString(),
        id: json["id"],
        result:
            json["result"] == null ? null : CountData.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result?.toJson(),
      };
}

class CountData {
  int makerPending;
  int makerCompleted;
  int checkerPending;
  int checkerCompleted;
  int approverPending;
  int approverCompleted;

  CountData({
    required this.makerPending,
    required this.makerCompleted,
    required this.checkerPending,
    required this.checkerCompleted,
    required this.approverPending,
    required this.approverCompleted,
  });

  factory CountData.fromJson(Map<String, dynamic> json) => CountData(
        makerPending: json["maker_pending"] ?? 0,
        makerCompleted: json["maker_completed"] ?? 0,
        checkerPending: json["checker_pending"] ?? 0,
        checkerCompleted: json["checker_completed"] ?? 0,
        approverPending: json["approver_pending"] ?? 0,
        approverCompleted: json["approver_completed"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "maker_pending": makerPending,
        "maker_completed": makerCompleted,
        "checker_pending": checkerPending,
        "checker_completed": checkerCompleted,
        "approver_pending": approverPending,
        "approver_completed": approverCompleted,
      };
}

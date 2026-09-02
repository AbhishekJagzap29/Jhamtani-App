//VJ Material Inspection Response Model=================================================================

// // To parse this JSON data, do
// //
// //     final materialInspectionResponseModel = materialInspectionResponseModelFromJson(jsonString);

// import 'dart:convert';

// MaterialInspectionResponseModel materialInspectionResponseModelFromJson(String str) =>
//     MaterialInspectionResponseModel.fromJson(json.decode(str));

// String materialInspectionResponseModelToJson(MaterialInspectionResponseModel data) => json.encode(data.toJson());

// class MaterialInspectionResponseModel {
//   String? status;
//   String? message;
//   MiData? miData;

//   MaterialInspectionResponseModel({
//     this.status,
//     this.message,
//     this.miData,
//   });

//   factory MaterialInspectionResponseModel.fromJson(Map<String, dynamic> json) => MaterialInspectionResponseModel(
//         status: json["status"],
//         message: json["message"],
//         miData: json["mi_data"] == null ? null : MiData.fromJson(json["mi_data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "mi_data": miData?.toJson(),
//       };
// }

// class MiData {
//   List<MaterialInspection>? materialInspection;

//   MiData({
//     this.materialInspection,
//   });

//   factory MiData.fromJson(Map<String, dynamic> json) => MiData(
//         materialInspection: json["material_inspection"] == null
//             ? []
//             : List<MaterialInspection>.from(json["material_inspection"]!.map((x) => MaterialInspection.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "material_inspection":
//             materialInspection == null ? [] : List<dynamic>.from(materialInspection!.map((x) => x.toJson())),
//       };
// }

// class MaterialInspection {
//   int? id;
//   int? projectInfoId;
//   String? seqNo;
//   String? title;
//   String? companyName;
//   int? towerId;
//   String? mirNo;
//   String? supplierName;
//   String? materialDesc;
//   String? projectName;
//   String? invoiceNo;
//   String? qualityAsPerChallanInv;
//   double? enterQuantity;
//   String? pendingQuantity;
//   String? batchNo;
//   String? vehicleNo;
//   String? dateOfInsp;
//   String? dateOfMaterial;
//   String? remark;
//   String? image;
//   int? checkedBy;
//   String? status;
//   List<LineData>? lineData;
//   List<String>? imageUrlData;
//  String? selectedUomCode;
//  String? docNo;

//   MaterialInspection({
//     this.id,
//     this.projectInfoId,
//     this.seqNo,
//     this.title,
//     this.companyName,
//     this.towerId,
//     this.mirNo,
//     this.supplierName,
//     this.materialDesc,
//     this.projectName,
//     this.invoiceNo,
//     this.qualityAsPerChallanInv,
//     this.enterQuantity,
//     this.pendingQuantity,
//     this.batchNo,
//     this.vehicleNo,
//     this.dateOfInsp,
//     this.dateOfMaterial,
//     this.remark,
//     this.checkedBy,
//     this.image,
//     this.lineData,
//     this.status,
//     this.imageUrlData,
//     this.selectedUomCode,
//     this.docNo,
//   });

//   factory MaterialInspection.fromJson(Map<String, dynamic> json) => MaterialInspection(
//     id: json["id"],
//     projectInfoId: json["project_info_id"],
//     seqNo: json["seq_no"],
//     title: json["title"] is String ? json["title"] : "",
//     companyName: json["company_name"],
//     towerId: json["tower_id"],
//     mirNo: json["mir_no"],
//     supplierName: json["supplier_name"],
//     materialDesc: json["material_desc"],
//     projectName: json["project_name"],
//     invoiceNo: json["invoice_no"],
//     selectedUomCode: json["uom_code"] is String ? json["uom_code"] : null,
//     docNo: json["doc_no"],
//     qualityAsPerChallanInv: json["quality_as_per_challan_inv"],
//     enterQuantity: (json['submitted_qty'] as num?)!.toDouble(),
//     pendingQuantity: json["pending_qty"] is String ? json["pending_qty"] : json["pending_qty"].toString(),
//     batchNo: json["batch_no"],
//     vehicleNo: json["vehicle_no"],
//     dateOfInsp: json["date_of_insp"],
//     dateOfMaterial: json["date_of_material"],
//     remark: json["remark"],
//     checkedBy: json["checked_by"] == "" ? 0 : json["checked_by"],
//     image: json["image"] ?? "",
//     status: json["status"] ?? "",
//     lineData: json["line_data"] == null ? [] : List<LineData>.from(json["line_data"]!.map((x) => LineData.fromJson(x))),
//     imageUrlData: json["image_url_data"] == null ? [] : List<String>.from(json["image_url_data"]!.map((x) => x)),
// );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "": projectInfoId,
//         "seq_no": seqNo,
//         "title": title,
//         "company_name": companyName,
//         "tower_id": towerId,
//         "mir_no": mirNo,
//         "supplier_name": supplierName,
//         "material_desc": materialDesc,
//         "project_name": projectName,
//         "invoice_no": invoiceNo,
//         "uom_code": selectedUomCode,
//         "doc_no": docNo,
//         "quality_as_per_challan_inv": qualityAsPerChallanInv,
//         "submitted_qty" : enterQuantity,
//         "batch_no": batchNo,
//         "vehicle_no": vehicleNo,
//         "date_of_insp": dateOfInsp,
//         "date_of_material": dateOfMaterial,
//         "remark": remark,
//         "checked_by": checkedBy,
//         "image": image,
//         "status": status,
//         "line_data": lineData == null ? [] : List<dynamic>.from(lineData!.map((x) => x.toJson())),
//         "image_url_data": imageUrlData == null ? [] : List<dynamic>.from(imageUrlData!.map((x) => x)),
//       };
// }

// class LineData {
//   int? checklistId;
//   String? observation;
//   String? remark;
//   int? id;
//   LineData({
//     this.checklistId,
//     this.observation,
//     this.remark,
//     this.id,
//   });

//   factory LineData.fromJson(Map<String, dynamic> json) => LineData(
//         checklistId: json["checklist_id"],
//         observation: json["observation"],
//         remark: json["remark"],
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "checklist_id": checklistId,
//         "observation": observation,
//         "remark": remark,
//         "id": id,
//       };
// }

/// VB Material Inspection Response Model============================================================
// To parse this JSON data, do
//
//     final materialInspectionResponseModel = materialInspectionResponseModelFromJson(jsonString);
import 'dart:convert';

MaterialInspectionResponseModel materialInspectionResponseModelFromJson(
        String str) =>
    MaterialInspectionResponseModel.fromJson(json.decode(str));

String materialInspectionResponseModelToJson(
        MaterialInspectionResponseModel data) =>
    json.encode(data.toJson());

class MaterialInspectionResponseModel {
  String? status;
  String? message;
  MiData? miData;

  MaterialInspectionResponseModel({
    this.status,
    this.message,
    this.miData,
  });

  factory MaterialInspectionResponseModel.fromJson(Map<String, dynamic> json) =>
      MaterialInspectionResponseModel(
        status: json["status"],
        message: json["message"],
        miData:
            json["mi_data"] == null ? null : MiData.fromJson(json["mi_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "mi_data": miData?.toJson(),
      };
}

class MiData {
  List<MaterialInspection>? materialInspection;

  MiData({
    this.materialInspection,
  });

  factory MiData.fromJson(Map<String, dynamic> json) => MiData(
        materialInspection: json["material_inspection"] == null
            ? []
            : List<MaterialInspection>.from(json["material_inspection"]!
                .map((x) => MaterialInspection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "material_inspection": materialInspection == null
            ? []
            : List<dynamic>.from(materialInspection!.map((x) => x.toJson())),
      };
}

class MaterialInspection {
  int? id;
  int? projectInfoId;
  String? seqNo;
  String? title;
  String? companyName;
  int? towerId;
  String? mirNo;
  String? supplierName;
  String? materialDesc;
  String? projectName;
  String? invoiceNo;
  String? qualityAsPerChallanInv;
  String? batchNo;
  String? vehicleNo;
  String? dateOfInsp;
  String? dateOfMaterial;
  String? remark;
  String? image;
  int? checkedBy;
  String? status;
  String? miStatus;
  List<LineData>? lineData;
  List<String>? imageUrlData;

  MaterialInspection({
    this.id,
    this.projectInfoId,
    this.seqNo,
    this.title,
    this.companyName,
    this.towerId,
    this.mirNo,
    this.supplierName,
    this.materialDesc,
    this.projectName,
    this.invoiceNo,
    this.qualityAsPerChallanInv,
    this.batchNo,
    this.vehicleNo,
    this.dateOfInsp,
    this.dateOfMaterial,
    this.remark,
    this.checkedBy,
    this.image,
    this.lineData,
    this.status,
    this.miStatus,
    this.imageUrlData,
  });

  factory MaterialInspection.fromJson(Map<String, dynamic> json) =>
      MaterialInspection(
        id: json["id"],
        projectInfoId: json["project_info_id"],

        ///
        seqNo: json["seq_no"],
        title: json["title"] == false ? "" : json["title"],
        companyName: json["company_name"],
        towerId: json["tower_id"],
        mirNo: json["mir_no"],
        supplierName: json["supplier_name"],
        materialDesc: json["material_desc"],
        projectName: json["project_name"],
        invoiceNo: json["invoice_no"],
        qualityAsPerChallanInv: json["quality_as_per_challan_inv"],
        batchNo: json["batch_no"],
        vehicleNo: json["vehicle_no"],
        dateOfInsp: json["date_of_insp"],
        dateOfMaterial: json["date_of_material"],
        remark: json["remark"],
        checkedBy: json["checked_by"] == "" ? 0 : json["checked_by"],
        image: json["image"] ?? "",
        status: json["status"] ?? "",
        miStatus: json["mi_status"] ?? "",
        lineData: json["line_data"] == null
            ? []
            : List<LineData>.from(
                json["line_data"]!.map((x) => LineData.fromJson(x))),
        imageUrlData: json["image_url_data"] == null
            ? []
            : List<String>.from(json["image_url_data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_info_id": projectInfoId,
        "seq_no": seqNo,
        "title": title,
        "company_name": companyName,
        "tower_id": towerId,
        "mir_no": mirNo,
        "supplier_name": supplierName,
        "material_desc": materialDesc,
        "project_name": projectName,
        "invoice_no": invoiceNo,
        "quality_as_per_challan_inv": qualityAsPerChallanInv,
        "batch_no": batchNo,
        "vehicle_no": vehicleNo,
        "date_of_insp": dateOfInsp,
        "date_of_material": dateOfMaterial,
        "remark": remark,
        "checked_by": checkedBy,
        "image": image,
        "status": status,
        "mi_status": miStatus,
        "line_data": lineData == null
            ? []
            : List<dynamic>.from(lineData!.map((x) => x.toJson())),
        "image_url_data": imageUrlData == null
            ? []
            : List<dynamic>.from(imageUrlData!.map((x) => x)),
      };
}

class LineData {
  int? checklistId;
  String? observation;
  String? remark;
  int? id;
  LineData({
    this.checklistId,
    this.observation,
    this.remark,
    this.id,
  });

  factory LineData.fromJson(Map<String, dynamic> json) => LineData(
        checklistId: json["checklist_id"],
        observation: json["observation"],
        remark: json["remark"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "checklist_id": checklistId,
        "observation": observation,
        "remark": remark,
        "id": id,
      };
}

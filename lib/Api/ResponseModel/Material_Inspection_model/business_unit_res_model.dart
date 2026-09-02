// import 'dart:convert';

// BusinessUnitResponseModel businessUnitResponseModelFromJson(String str) =>
//     BusinessUnitResponseModel.fromJson(json.decode(str));

// String businessUnitResponseModelToJson(BusinessUnitResponseModel data) =>
//     json.encode(data.toJson());

// class BusinessUnitResponseModel {
//   String? status;
//   String? message;
//   final List<BusinessUnit> buData;

//   BusinessUnitResponseModel({
//     this.status,
//     this.message,
//     required this.buData,
//   });

//   factory BusinessUnitResponseModel.fromJson(Map<String, dynamic> json) =>
//       BusinessUnitResponseModel(
//         status: json["status"]?.toString(),
//         message: json["message"]?.toString(),
//         buData: json["bu_data"] != null
//             ? List<BusinessUnit>.from(
//                 json["bu_data"].map((x) => BusinessUnit.fromJson(x)))
//             : [],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "bu_data": buData?.map((x) => x.toJson()).toList(),
//       };
// }

// class BusinessUnit {
//   int? buId;
//   int? poId;
//   String? buDescription;

//   BusinessUnit({
//     this.buId,
//     this.poId,
//     this.buDescription,
//   });

//   factory BusinessUnit.fromJson(Map<String, dynamic> json) => BusinessUnit(
//         buId: json["bu_id"],
//         poId: json["po_id"],
//         buDescription: json["bu_descrption"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "bu_id": buId,
//         "po_id": poId,
//         "bu_descrption": buDescription,
//       };
// }

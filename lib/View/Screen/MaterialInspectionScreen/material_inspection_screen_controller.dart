import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/document_no_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/material_count_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/material_description_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/Material_Inspection_model/supplier_name_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_material_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/material_inspection_response_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/image_capture_screen.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';

/// VJ Material Inspection  ==========================================================
// class MaterialInspectionScreenController extends GetxController {
//   List<MaterialInspection> searchMaterialInspectionResponseModel = [];
//   MaterialInspectionResponseModel? materialInspectionResponseModel;
//   MaterialInspectionPointsModel? getMaterialInspectionCheckListResponseModel;
//   List<LedgerDescription> ledgerList = [];
//   List<DocumentNumber> documentNumberList = [];
//   List<MaterialDescription> materialList = [];
//   MaterialInspection? selectedReport;
//   List<MiChecklist> selectedReportCheckListData = [];

//   MaterialCountResModel? materialCountRes;

//   var towerId = Get.arguments["towerId"];
//   var towerName = Get.arguments["towerName"];

//   var projectId = Get.arguments["projectId"];
//   var projectName = Get.arguments["projectName"];
//   var miId = Get.arguments["id"];
//   var screen = Get.arguments["screen"];

//   CountData? miCountData;

//   int buId = int.tryParse(Get.arguments["buId"].toString()) ?? 0;
//   int poId = int.tryParse(Get.arguments["poId"].toString()) ?? 0;
//   int lineId = int.tryParse(Get.arguments["lineId"].toString()) ?? 0;
//   int poIds = int.tryParse(Get.arguments["poIds"].toString()) ?? 0;
//   int ledgerId =
//       int.tryParse(Get.arguments["ledgerId"]?.toString() ?? '0') ?? 0;

//   List<TextEditingController> textControllerList = [];

//   int userId = int.parse(preferences.getString(SharedPreference.userId) ?? "0");

//   DateTime inspectionDate = DateTime.now();
//   DateTime dateOfMaterialRecive = DateTime.now();
//   bool isEdit = false;
//   String status = '';
//   bool isLoading = false;
//   String? imgFile;
//   List<String>? overAllImagesList = [];

//   int? selectedProjectId;

// // Controllers
//   TextEditingController inspectionDateController = TextEditingController(
//       text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
//   TextEditingController dateOfMaterialReciveController = TextEditingController(
//       text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
//   TextEditingController mirNoController = TextEditingController();
//   TextEditingController projectNameController = TextEditingController();
//   TextEditingController supplierNameController = TextEditingController();
//   TextEditingController materialDiscController = TextEditingController();
//   TextEditingController invoiceNoController = TextEditingController();
//   TextEditingController quantityPerInvoiceController = TextEditingController();
//   TextEditingController vehicleNoController = TextEditingController();
//   TextEditingController lotNoController = TextEditingController();
//   TextEditingController overAllRemarkController = TextEditingController();
//   TextEditingController uomCodeController = TextEditingController();
//   TextEditingController docNumberController = TextEditingController();
//   TextEditingController enterQuantityController = TextEditingController();
//   TextEditingController pendingQuantityController = TextEditingController();
//   TextEditingController lineIdController = TextEditingController();

//   String? selectedBusinessUnit;
//   String? selectedLedgerDescription;
//   String? selectedMaterialDescription;
//   String? selectedMaterialQuantity;
//   String? selectedUomCode;

//   String image = "";
//   String seqNo = "";

//   @override
//   void onInit() {
//     super.onInit();
//     if (screen != "notification") {
//       getMaterialInspection();
//       getMaterialInspectionCounts();
//     }

//     projectNameController = TextEditingController(text: projectName.toString());
//   }

//   updateSelectedReport(MaterialInspection report) {
//     selectedReport = report;

//     status = selectedReport?.status == "draft"
//         ? 'maker'
//         : selectedReport?.status == "submit"
//             ? 'checker'
//             : 'approver';
//     // if (selectedReport?.status == "approve") {
//     //   isEdit = false;
//     // } else if (preferences.getString(SharedPreference.userType) == status) {
//     //   isEdit = true;
//     // } else {
//     //   isEdit = false;
//     // }

//       if (selectedReport?.status == "approve") {
//     isEdit = false;
//   } else if ((preferences.getString(SharedPreference.userType)?.contains(status) ?? false)) {
//     isEdit = true;
//   } else {
//     isEdit = false;
//   }
//     update();
//   }

//   // Overall Image Capture
//   captureOverallImage({required BuildContext context, String? screen}) async {
//     final ImagePicker picker = ImagePicker();
//     XFile? image = await picker
//         .pickImage(imageQuality: 15, source: ImageSource.camera)
//         .then(
//       (value) async {
//         if (value != null) {
//           Uint8List imageBytes = await value.readAsBytes();
//           img.Image? image = img.decodeImage(imageBytes);
//           img.Image resizedImage = img.copyResize(image!, width: 800);
//           List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
//           File compressedFile = File(value.path)
//             ..writeAsBytesSync(compressedBytes);

//           return Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ImageCaptureScreen(
//                   image: File(compressedFile.path.toString()),
//                   title: screen == "CreateMaterialInspectionScreen"
//                       ? "Test Project"
//                       : (selectedReport?.seqNo ?? "").toString()),
//             ),
//           ).then(
//             (value1) {
//               if (value1 != true) {
//                 imgFile = value1["image"];

//                 log('imgFile==========>>>>>> ${imgFile}');
//                 screen == "CreateMaterialInspectionScreen"
//                     ? overAllImagesList?.add(imgFile!)
//                     : selectedReport?.imageUrlData?.add(imgFile!);
//               }
//               return;
//             },
//           );
//         } else {
//           return value;
//         }
//       },
//     );

//     update();
//   }

//   removeOverallImage(int id, String? screen) {
//     screen == "CreateMaterialInspectionScreen"
//         ? overAllImagesList?.removeAt(id)
//         : selectedReport?.imageUrlData?.removeAt(id);
//     update();
//   }

//   ApiResponse _getMaterialInspectionResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getMaterialInspectionResponse =>
//       _getMaterialInspectionResponse;

//   Future<void> getMaterialInspection({bool? towerIds, String? miIds}) async {
//     _getMaterialInspectionResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       materialInspectionResponseModel = await ProjectRepo()
//           .getMaterialInspection(
//               body: {"tower_id": towerIds ?? towerId, "mi_id": miIds ?? false});
//       searchMaterialInspectionResponseModel =
//           materialInspectionResponseModel?.miData?.materialInspection ?? [];
//       log('materialInspectionResponseModel::::::::::::::::${materialInspectionResponseModel?.toJson()}');

//       // materialInspectionResponseModel?.miData?.materialInspection?.sort(
//       //   (a, b) => "${b.mirNo}".compareTo("${a.mirNo}"),
//       // );

//       materialInspectionResponseModel?.miData?.materialInspection?.sort((a, b) {
//         String getMonth(String mirNo) {
//           final RegExp monthRegex = RegExp(r'MI Report/([A-Za-z]+)');
//           final match = monthRegex.firstMatch(mirNo);
//           return match?.group(1) ?? '';
//         }

//         int monthToNumber(String month) {
//           const monthMap = {
//             'Jan': 1,
//             'Feb': 2,
//             'Mar': 3,
//             'Apr': 4,
//             'May': 5,
//             'Jun': 6,
//             'Jul': 7,
//             'Aug': 8,
//             'Sep': 9,
//             'Oct': 10,
//             'Nov': 11,
//             'Dec': 12,
//           };
//           return monthMap[month.substring(0, 3)] ?? 0;
//         }

//         final String monthA = getMonth(a.mirNo ?? '');
//         final String monthB = getMonth(b.mirNo ?? '');

//         final int monthNumA = monthToNumber(monthA);
//         final int monthNumB = monthToNumber(monthB);

//         // sort month descending
//         int monthCompare = monthNumB.compareTo(monthNumA);
//         if (monthCompare != 0) return monthCompare;

//         // sort mir_no number descending
//         final RegExp numRegex = RegExp(r'/(\d{4})$');
//         int extractNumber(String? mirNo) {
//           final match = numRegex.firstMatch(mirNo ?? '');
//           return int.tryParse(match?.group(1) ?? '0') ?? 0;
//         }

//         return extractNumber(b.mirNo).compareTo(extractNumber(a.mirNo));
//       });

//       _getMaterialInspectionResponse =
//           ApiResponse.complete(materialInspectionResponseModel);
//     } catch (e) {
//       _getMaterialInspectionResponse = ApiResponse.error(message: e.toString());
//       log("mIResponsesdfsdf=ERROR=>$e");
//     }
//     update();
//   }

//   ApiResponse _getMaterialInspectionCheckListResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getMaterialInspectionCheckListResponse =>
//       _getMaterialInspectionCheckListResponse;

//   Future<void> getMaterialInspectionCheckPoints() async {
//     _getMaterialInspectionCheckListResponse =
//         ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       getMaterialInspectionCheckListResponseModel =
//           await ProjectRepo().getMaterialInspectionCheckList();

//       _getMaterialInspectionCheckListResponse =
//           ApiResponse.complete(getMaterialInspectionCheckListResponseModel);
//     } catch (e) {
//       _getMaterialInspectionCheckListResponse =
//           ApiResponse.error(message: e.toString());
//       log("mIResponse=ERROR=>$e");
//     }
//     update();
//   }

//   ApiResponse _ledgerDescriptionResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get ledgerDescriptionResponse => _ledgerDescriptionResponse;

//   Future<void> getLedgerDescription({required int buId}) async {
//     _ledgerDescriptionResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       LedgerDescriptionResponseModel response =
//           await ProjectRepo().getLedgerDescriptionRepo(body: {"bu_id": buId});

//       if (response.poData != null && response.poData!.isNotEmpty) {
//         ledgerList = response.poData!;
//         _ledgerDescriptionResponse = ApiResponse.complete(response);

//         ledgerList.sort(
//           (a, b) => "${a.name}".compareTo("${b.name}"),
//         );
//       } else {
//         ledgerList = [];
//         _ledgerDescriptionResponse =
//             ApiResponse.error(message: 'No suppliers found');
//       }
//     } catch (e, stacktrace) {
//       _ledgerDescriptionResponse = ApiResponse.error(message: e.toString());
//     }

//     update();
//   }

// ///////document number

//   ApiResponse _documentNumberResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get documentNumberResponse => _documentNumberResponse;

//   Future<void> getDocumentNumber({required List<int> poId}) async {
//     _documentNumberResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       print("Fetching document numbers for PO IDs: $poId...");

//       DocumnetNumberResponseModel response =
//           await ProjectRepo().getDocumentNumberRepo(body: {"po_ids": poId});

//       print("API Response: ${response.poData}");

//       if (response.poData != null && response.poData!.isNotEmpty) {
//         documentNumberList = response.poData!;
//         _documentNumberResponse = ApiResponse.complete(response);

//         documentNumberList.sort(
//           (a, b) => "${a.docNo}".compareTo("${b.docNo}"),
//         );
//       } else {
//         documentNumberList = [];
//         _documentNumberResponse =
//             ApiResponse.error(message: 'No document numbers found');
//       }
//     } catch (e, stacktrace) {
//       print("Error occurred: $e");
//       print("Stacktrace: $stacktrace");
//       _documentNumberResponse = ApiResponse.error(message: e.toString());
//     }
//     update();
//   }

//   // Material description
//   ApiResponse _materialDescriptionResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get materialDescriptionResponse => _materialDescriptionResponse;

//   Future<void> getMaterialDescription(
//       {required List<int> poId, required int ledgerId}) async {
//     _materialDescriptionResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       print("Fetching material descriptions for PO ID and  : $poId... ");

//       MaterialDescriptionResponseModel response = await ProjectRepo()
//           .getMaterialDescriptionRepo(
//               body: {"po_ids": poId, "ledger_id": ledgerId});

//       if (response.polineData != null && response.polineData!.isNotEmpty) {
//         materialList = response.polineData!;
//         _materialDescriptionResponse = ApiResponse.complete(response);

//         materialList.sort(
//           (a, b) => "${a.description}".compareTo("${b.description}"),
//         );
//       } else {
//         materialList = [];
//         _materialDescriptionResponse =
//             ApiResponse.error(message: 'No materials found');
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       _materialDescriptionResponse = ApiResponse.error(message: e.toString());
//     }
//     update();
//   }

// ////////////////////// MI count api

//   ApiResponse _materialCountApiResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get materialCountApiResponse => _materialCountApiResponse;
//   Future<void> getMaterialInspectionCounts() async {
//     _materialCountApiResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       final body = {
//         "project_id": projectId,
//         "tower_id": towerId,
//       };

//       final response = await ProjectRepo().getmaterialcountRepo(body: body);

//       if (response.result != null) {
//         miCountData = response.result;
//         _materialCountApiResponse = ApiResponse.complete(response);
//       } else {
//         _materialCountApiResponse =
//             ApiResponse.error(message: 'No data received');
//       }
//     } catch (e) {
//       _materialCountApiResponse = ApiResponse.error(message: e.toString());
//     }

//     update();
//   }

//   // Create Material Inspection
//   ApiResponse _createMiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get createMiResponse => _createMiResponse;

//   Future<void> createMaterialInspection({required String isDraft}) async {
//     update();
//     log(' requestBody(isDraft: isDraft)----------- ${requestBody(isDraft: isDraft)}');

//     // if (mirNoController.text.isEmpty) {
//     //  errorSnackBar("Required Field", 'Please enter Mir no');
//     // } else
//     if (supplierNameController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter Supplier Name');
//     } else if (materialDiscController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter Material Description');
//     }

// // else if (selectedMaterialDescription == null || selectedMaterialDescription == "No Data Available") {
// //   errorSnackBar("Required Field", 'Please select a valid Supplier');
// // }

//     else if (uomCodeController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter Uom Code');
//     } else if (invoiceNoController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter Invoice No');
//     } else if (quantityPerInvoiceController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter Quantity as Per Challan');
//     } else if (enterQuantityController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter Quantity');
//     } else if (double.tryParse(enterQuantityController.text.trim()) == null ||
//         double.tryParse(pendingQuantityController.text.trim()) == null ||
//         double.tryParse(quantityPerInvoiceController.text.trim()) == null) {
//       errorSnackBar("Invalid Input", "Please enter valid numeric quantities.");
//     } else if (double.parse(enterQuantityController.text.trim()) >
//         double.parse(pendingQuantityController.text.trim())) {
//       errorSnackBar("Invalid Quantity",
//           "Entered quantity should be less than or equal to pending quantity.");
//     } else if (pendingQuantityController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter Pending Quantity');
//     } else if (vehicleNoController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter vehicle no');
//     } else if (lotNoController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter batch no');
//     } else if (overAllRemarkController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter overall remark');
//     } else if (docNumberController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter document number');
//     } else if (getMaterialInspectionCheckListResponseModel!.miChecklist!
//         .any((element) => element.controller.text.isEmpty)) {
//       errorSnackBar("Required Field", 'Please enter Comment/Remark');
//     } else if ((overAllImagesList ?? []).isEmpty) {
//       errorSnackBar("Required Field", 'Please Select Overall Image');
//     } else {
//       _createMiResponse = ApiResponse.loading(message: 'Loading');
//       try {
//         SuccessDataResponseModel successDataResponseModel = await ProjectRepo()
//             .createMaterialInspection(body: requestBody(isDraft: isDraft));
//         if (successDataResponseModel.status == "SUCCESS") {
//           Get.back();
//           successSnackBar("Success", "Material Inspection Created");
//           getMaterialInspection();
//         } else {
//           log('successDataResponseModel.message----------- ${successDataResponseModel.message}');

//           errorSnackBar(
//               "Something Went Wrong", successDataResponseModel.message ?? "");
//         }
//         _createMiResponse = ApiResponse.complete(successDataResponseModel);
//       } catch (e) {
//         _createMiResponse = ApiResponse.error(message: e.toString());
//         log("Create Mi Response Error=>$e");
//       }
//     }
//     update();
//   }

//   // Update Material Inspection
//   ApiResponse _updateMiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get updateMiResponse => _updateMiResponse;

//   Future<void> updateMi({required String isDraft}) async {
//     if (selectedReportCheckListData.any(
//             (element) => (element.isPass == "No" || element.isPass == "no")) ==
//         true) {
//       errorSnackBar("Alert !",
//           'You can not Submit this checklist because You Selected "No" checkpoints');
//     } else if (selectedReportCheckListData
//             .any((element) => element.controller.text.isEmpty) ==
//         true) {
//       errorSnackBar("Required Field", "Please enter description");
//     } else {
//       _updateMiResponse = ApiResponse.loading(message: 'Loading');
//       update();

//       try {
//         log('requestUpdateBody----------- ${jsonEncode(requestUpdateBody(isDraft: isDraft))}');

//         SuccessDataResponseModel successDataResponseModel = await ProjectRepo()
//             .updateMaterialRepo(body: requestUpdateBody(isDraft: isDraft));
//         log('successDataResponseModel----------- ${successDataResponseModel.toJson()}');

//         if (successDataResponseModel.status == "SUCCESS" ||
//             successDataResponseModel.status == "success") {
//           Get.back();
//           successSnackBar("Success", "Material Inspection Updated");
//           if (screen == 'notification') {
//             getMaterialInspection(towerIds: false, miIds: miId);
//           } else {
//             getMaterialInspection();
//           }
//         } else {
//           errorSnackBar(
//               "Something Went Wrong", successDataResponseModel.message ?? "");
//         }
//         _updateMiResponse = ApiResponse.complete(successDataResponseModel);
//       } catch (e) {
//         _updateMiResponse = ApiResponse.error(message: e.toString());
//         log("Update Mi Response Error=>$e");
//       }
//       update();
//     }
//   }

//   // Reject Material Inspection
//   ApiResponse _rejectMiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get rejectMiResponse => _rejectMiResponse;

//   Future<void> rejectMi({required String isDraft}) async {
//     int? con = selectedReportCheckListData
//         .indexWhere((element) => (element.isPass.toLowerCase() == "no"));

//     if (con < 0) {
//       errorSnackBar("Alert !",
//           'You can not reject or sent back this checklist because not any points select as "No"');
//       return;
//     }

//     if (selectedReportCheckListData.any((element) =>
//             element.controller.text.isEmpty &&
//             (element.isPass == "No" || element.isPass == "no")) ==
//         true) {
//       errorSnackBar("Required Field",
//           "Please enter description for 'No' selected checkpoints");
//       log('Hello description validation');
//     } else if (selectedReportCheckListData
//             .any((element) => element.controller.text.isEmpty) ==
//         true) {
//       errorSnackBar("Required Field", "Please enter description");
//     } else {
//       log("SUBMITTED");
//       List<Map<String, dynamic>> checkListResponse = [];
//       for (var element in selectedReportCheckListData) {
//         checkListResponse.add({
//           "mi_checklist_id": element.checklistId,
//           "is_pass": element.isPass.toLowerCase() == "yes"
//               ? 'yes'
//               : element.isPass.toLowerCase() == "no"
//                   ? 'no'
//                   : 'na',
//           "remark": element.controller.text.trim(),
//           "line_id": element.id
//         });
//       }
//       String base64String = "";

//       if (!image.contains("http://") && image.isNotEmpty) {
//         File path = File(image);
//         List<int> fileBytes = path.readAsBytesSync();
//         base64String = base64Encode(fileBytes);
//       }

//       /// Overall Image add
//       List overallImageListData = [];
//       selectedReport?.imageUrlData?.forEach((element) {
//         if (!element.contains('http://')) {
//           String base64String = '';
//           File path = File(element);
//           if (path.existsSync()) {
//             List<int> fileBytes = path.readAsBytesSync();
//             base64String = base64Encode(fileBytes);
//           }
//           overallImageListData.add(base64String);
//           update();
//         }
//       });

//       Map<String, dynamic> body = {
//         "mi_id": selectedReport?.id,
//         "user_id": int.parse(
//             preferences.getString(SharedPreference.userId).toString()),
//         "is_draft": isDraft,
//         "mir_no": mirNoController.text.trim(),
//         "tower_id": int.parse(towerId ?? "${selectedReport?.towerId}"),
//         "project_info_id":
//             int.parse(projectId ?? "${selectedReport?.projectInfoId}"),
//         "supplier_name": supplierNameController.text.trim(),
//         "project_name": projectNameController.text.trim(),
//         "material_description": materialDiscController.text.trim(),
//         "invoice_no": invoiceNoController.text.trim(),
//         "quantity_as_invoice": quantityPerInvoiceController.text.trim(),
//         "submitted_qty": enterQuantityController.text.trim(),
//         "pending_qty": pendingQuantityController.text.trim(),
//         "uom_code": uomCodeController.text.trim(),
//         "doc_no": docNumberController.text.trim(),
//         "line_id": lineIdController.text.trim(),
//         "vehicle_no": vehicleNoController.text.trim(),
//         "date_of_inspection": DateFormat("yyyy-MM-dd").format(inspectionDate),
//         "date_of_material_received":
//             DateFormat("yyyy-MM-dd").format(dateOfMaterialRecive),
//         "batch_no": lotNoController.text.trim(),
//         "checklist_line": checkListResponse,
//         "overall_remark": overAllRemarkController.text.trim(),
//         "image": "", // base64String.isEmpty ? image : base64String

//         if (overallImageListData.isNotEmpty) "image_data": overallImageListData,
//       };
//       log('body-------REJECT MI---- ${body}');

//       _rejectMiResponse = ApiResponse.loading(message: 'Loading');
//       update();
//       try {
//         SuccessDataResponseModel successDataResponseModel =
//             await ProjectRepo().rejectMakerRepo(body: body);
//         if (successDataResponseModel.status == "SUCCESS") {
//           Get.back();
//           successSnackBar("Success", "Material Inspection Rejected");
//           if (screen == 'notification') {
//             getMaterialInspection(towerIds: false, miIds: miId);
//           } else {
//             getMaterialInspection();
//           }
//         } else {
//           errorSnackBar(
//               "Something Went Wrong", successDataResponseModel.message ?? "");
//         }
//         _rejectMiResponse = ApiResponse.complete(successDataResponseModel);
//       } catch (e) {
//         _rejectMiResponse = ApiResponse.error(message: e.toString());
//         log("Reject Mi Response Error=>$e");
//       }
//       update();
//     }
//   }

//   changeDropDownValue(
//     int index,
//     String newValue,
//   ) {
//     getMaterialInspectionCheckListResponseModel?.miChecklist?[index].isPass =
//         newValue;

//     update();
//   }

//   changeUpdateDropDownValue(
//     int index,
//     String newValue,
//   ) {
//     selectedReportCheckListData[index].isPass = newValue;
//     update();
//   }

//   search(String query) {
//     searchMaterialInspectionResponseModel = [];
//     if (query.trim().isEmpty) {
//       searchMaterialInspectionResponseModel =
//           materialInspectionResponseModel?.miData?.materialInspection ?? [];
//     } else {
//       materialInspectionResponseModel?.miData?.materialInspection
//           ?.forEach((element) {
//         if (element.seqNo!.toLowerCase().contains(query.toLowerCase())) {
//           searchMaterialInspectionResponseModel.add(element);
//         }
//       });
//     }
//     update();
//   }

//   setData({String? screen, String? miId}) async {
//     selectedReportCheckListData = [];
//     if (screen == 'notification') {
//       isLoading = true;
//       update();
//       await getMaterialInspection(towerIds: false, miIds: miId).then((value) {
//         updateSelectedReport(searchMaterialInspectionResponseModel.first);
//       });
//       isLoading = false;
//       update();
//     }

//     final selectedReport = this.selectedReport;
//     if (selectedReport != null) {
//       seqNo = selectedReport?.seqNo ?? "";
//       mirNoController.text = selectedReport?.mirNo ?? "";
//       projectNameController.text = selectedReport?.projectName ?? "";
//       supplierNameController.text = selectedReport?.supplierName ?? "";
//       materialDiscController.text = selectedReport?.materialDesc ?? "";
//       invoiceNoController.text = selectedReport?.invoiceNo ?? "";
//       quantityPerInvoiceController.text =
//           selectedReport?.qualityAsPerChallanInv ?? "";
//       enterQuantityController.text =
//           selectedReport?.enterQuantity?.toString() ?? "";

//       pendingQuantityController.text = selectedReport?.pendingQuantity ?? "";
//       uomCodeController.text =
//           (selectedReport?.selectedUomCode ?? "").toString();
//       docNumberController.text = selectedReport?.docNo ?? "";
//       vehicleNoController.text = selectedReport?.vehicleNo ?? "";
//       lotNoController.text = selectedReport?.batchNo ?? "";
//       overAllRemarkController.text = selectedReport?.remark ?? "";
//       image = selectedReport?.image ?? "";
//       inspectionDate = DateTime.parse(selectedReport?.dateOfInsp ?? "");
//       inspectionDateController.text =
//           DateFormat("dd-MM-yyyy").format(inspectionDate);
//       dateOfMaterialRecive =
//           DateTime.parse(selectedReport?.dateOfMaterial ?? "");
//       dateOfMaterialReciveController.text =
//           DateFormat("dd-MM-yyyy").format(dateOfMaterialRecive);
//       selectedReport?.lineData?.forEach((element1) {
//         getMaterialInspectionCheckListResponseModel?.miChecklist
//             ?.forEach((element) {
//           if (element.id == element1.checklistId) {
//             selectedReportCheckListData.add(MiChecklist(
//                 id: element1.id,
//                 name: element.name,
//                 checklistId: element1.checklistId,
//                 controller: TextEditingController.fromValue(
//                     TextEditingValue(text: element1.remark ?? "")),
//                 //  TextEditingValue(text: element1.remark?.toString() ?? "")),
//                 isPass: element1.observation ?? ""));
//           }
//         });
//       });
//       log('selectedReportCheckListData==========>>>>>> ${selectedReportCheckListData.length}');
//       log('selectedReportCheckListData==========>>>>>> ${selectedReport.imageUrlData?.length}');
//       update();
//     }
//   }

//   requestBody({required String isDraft}) {
//     List<Map<String, dynamic>> checkListResponse = [];
//     getMaterialInspectionCheckListResponseModel?.miChecklist
//         ?.forEach((element) {
//       checkListResponse.add({
//         "mi_checklist_id": element.id,
//         "is_pass": element.isPass.toLowerCase() == "yes"
//             ? 'yes'
//             : element.isPass.toLowerCase() == "no"
//                 ? 'no'
//                 : 'na',
//         "remark": element.controller.text.trim()
//       });
//     });

//     String base64String = "";

//     if (image.isNotEmpty) {
//       File path = File(image);
//       List<int> fileBytes = path.readAsBytesSync();
//       base64String = base64Encode(fileBytes);
//     }

//     /// Overall Image add
//     List overallImageListData = [];
//     overAllImagesList?.forEach((element) {
//       if (!element.contains('http://')) {
//         String base64String = '';
//         File path = File(element);
//         if (path.existsSync()) {
//           List<int> fileBytes = path.readAsBytesSync();
//           base64String = base64Encode(fileBytes);
//         }
//         overallImageListData.add(base64String);
//         update();
//       }
//     });

//     Map<String, dynamic> body = {
//       "is_draft": isDraft,
//       "mir_no": mirNoController.text.trim(),
//       "tower_id": int.parse(towerId.toString()),
//       "project_info_id":
//           int.parse(projectId ?? "${selectedReport?.projectInfoId}"),
//       "supplier_name": supplierNameController.text.trim(),
//       "project_name": projectNameController.text.trim(),
//       "material_description": materialDiscController.text.trim(),
//       "invoice_no": invoiceNoController.text.trim(),
//       "uom_code": uomCodeController.text.trim(),
//       "doc_no": docNumberController.text.trim(),
//       "line_id": lineIdController.text.trim(),
//       "quantity_as_invoice":
//           double.tryParse(quantityPerInvoiceController.text.trim()) ?? 0,
//       "submitted_qty":
//           double.tryParse(enterQuantityController.text.trim()) ?? 0,
//       "pending_qty":
//           double.tryParse(pendingQuantityController.text.trim()) ?? 0,
//       "vehicle_no": vehicleNoController.text.trim(),
//       "date_of_inspection": DateFormat("yyyy-MM-dd").format(inspectionDate),
//       "date_of_material_received":
//           DateFormat("yyyy-MM-dd").format(dateOfMaterialRecive),
//       "batch_no": lotNoController.text.trim(),
//       "checklist_data": checkListResponse,
//       "overall_remark": overAllRemarkController.text.trim(),
//       "check_by":
//           int.parse(preferences.getString(SharedPreference.userId).toString()),
//       "image": "",
//       if (overallImageListData.isNotEmpty) "image_data": overallImageListData,
//     };
//     log('body----------- ${body}');

//     return body;
//   }

//   requestUpdateBody({required String isDraft}) {
//     List<Map<String, dynamic>> checkListResponse = [];
//     for (var element in selectedReportCheckListData) {
//       checkListResponse.add({
//         "mi_checklist_id": element.checklistId,
//         "is_pass": element.isPass.toLowerCase() == "yes"
//             ? 'yes'
//             : element.isPass.toLowerCase() == "no"
//                 ? 'no'
//                 : 'na',
//         "remark": element.controller.text.trim(),
//         "line_id": element.id
//       });
//     }
//     String base64String = "";

//     if (!image.contains("http://") && image.isNotEmpty) {
//       File path = File(image);
//       List<int> fileBytes = path.readAsBytesSync();
//       base64String = base64Encode(fileBytes);
//     }

//     /// Overall Image add
//     List overallImageListData = [];
//     selectedReport?.imageUrlData?.forEach((element) {
//       if (!element.contains('http://')) {
//         String base64String = '';
//         File path = File(element);
//         if (path.existsSync()) {
//           List<int> fileBytes = path.readAsBytesSync();
//           base64String = base64Encode(fileBytes);
//         }
//         overallImageListData.add(base64String);
//         update();
//       }
//     });

//     Map<String, dynamic> body = {
//       "mi_id": selectedReport?.id,
//       "user_id":
//           int.parse(preferences.getString(SharedPreference.userId).toString()),
//       "is_draft": isDraft,
//       "mir_no": mirNoController.text.trim(),
//       "tower_id": int.parse(towerId ?? "${selectedReport?.towerId}"),
//       "project_info_id":
//           int.parse(projectId ?? "${selectedReport?.projectInfoId}"),
//       "supplier_name": supplierNameController.text.trim(),
//       "project_name": projectNameController.text.trim(),
//       "material_description": materialDiscController.text.trim(),
//       "uom_code": uomCodeController.text.trim(),
//       "doc_no": docNumberController.text.trim(),
//       "line_id": lineIdController.text.trim(),
//       "invoice_no": invoiceNoController.text.trim(),
//       "quantity_as_invoice": quantityPerInvoiceController.text.trim(),
//       "submitted_qty": enterQuantityController.text.trim(),
//       "pending_qty": pendingQuantityController.text.trim(),
//       "vehicle_no": vehicleNoController.text.trim(),
//       "date_of_inspection": DateFormat("yyyy-MM-dd").format(inspectionDate),
//       "date_of_material_received":
//           DateFormat("yyyy-MM-dd").format(dateOfMaterialRecive),
//       "batch_no": lotNoController.text.trim(),
//       "checklist_line": checkListResponse,
//       "overall_remark": overAllRemarkController.text.trim(),
//       "image": "", // base64String.isEmpty ? image : base64String

//       if (overallImageListData.isNotEmpty) "image_data": overallImageListData,
//     };
//     log('body----------- ${body}');

//     return body;
//   }

//   void disposeForm() {
//     mirNoController.clear();
//     projectNameController.clear();
//     supplierNameController.clear();
//     materialDiscController.clear();
//     invoiceNoController.clear();
//     quantityPerInvoiceController.clear();
//     enterQuantityController.clear();
//     pendingQuantityController.clear();
//     vehicleNoController.clear();
//     lotNoController.clear();
//     uomCodeController.clear();
//     docNumberController.clear();
//     selectedReport = null;
//     selectedReportCheckListData.clear();
//     overAllRemarkController.clear();
//     image = "";
//     dateOfMaterialRecive = DateTime.now();
//     dateOfMaterialReciveController.text =
//         DateFormat("dd-MM-yyyy").format(DateTime.now());
//     inspectionDate = DateTime.now();
//     inspectionDateController.text =
//         DateFormat("dd-MM-yyyy").format(DateTime.now());
//     overAllImagesList = [];
//   }

//   updateImage(String image) {
//     this.image = image;
//     update();
//   }

//   /// Delete Material Inspection
//   ApiResponse _deleteMi = ApiResponse.initial(message: 'Initialization');

//   ApiResponse get deleteMi => _deleteMi;

//   Future<void> deleteMaterialInspection(String id) async {
//     _deleteMi = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       SuccessDataResponseModel successDataResponseModel =
//           await ProjectRepo().deleteMaterialInspection(body: {"mi_id": id});
//       if (successDataResponseModel.status == "SUCCESS") {
//         successSnackBar("Success", "Material Inspection Deleted");
//         getMaterialInspection();
//       } else {
//         errorSnackBar(
//             "Something Went Wrong", successDataResponseModel.message ?? "");
//       }
//       _deleteMi = ApiResponse.complete(successDataResponseModel);
//     } catch (e) {
//       _deleteMi = ApiResponse.error(message: e.toString());
//       log("Delete Mi Response Error=>$e");
//     }
//     update();
//   }

//   /// Replicate Material Inspection
//   ApiResponse _replicateMi = ApiResponse.initial(message: 'Initialization');

//   ApiResponse get replicateMi => _replicateMi;

//   Future<void> replicateMaterialInspection(String id) async {
//     _replicateMi = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       SuccessDataResponseModel successDataResponseModel =
//           await ProjectRepo().replicateMaterialInspection(body: {"mi_id": id});
//       if (successDataResponseModel.status == "SUCCESS") {
//         successSnackBar("Success", "Material Inspection Replicated");
//         getMaterialInspection();
//       } else {
//         errorSnackBar(
//             "Something Went Wrong", successDataResponseModel.message ?? "");
//       }
//       _replicateMi = ApiResponse.complete(successDataResponseModel);
//     } catch (e) {
//       _replicateMi = ApiResponse.error(message: e.toString());
//       log("Replicate Mi Response Error =>$e");
//       if (e.toString() == "Error During Communication:Internal Server Error") {
//         errorSnackBar("Internal Server Error", "Something Went Wrong");
//       }
//     }
//     update();
//   }

//   /// Capture Image
//   capturePhoto({required BuildContext context}) async {
//     final ImagePicker picker = ImagePicker();
//     XFile? image = await picker
//         .pickImage(imageQuality: 15, source: ImageSource.camera)
//         .then(
//       (value) async {
//         if (value != null) {
//           Uint8List imageBytes = await value.readAsBytes();
//           img.Image? image = img.decodeImage(imageBytes);
//           img.Image resizedImage = img.copyResize(image!, width: 800);
//           List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
//           File compressedFile = File(value.path)
//             ..writeAsBytesSync(compressedBytes);
//           return Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ImageCaptureScreen(
//                 image: File(compressedFile.path.toString()),
//                 title: seqNo,
//               ),
//             ),
//           ).then(
//             (value1) {
//               if (value1 != true) {
//                 this.image = value1['image'];
//                 update();
//               }
//               return;
//             },
//           );
//         } else {
//           return value;
//         }
//       },
//     );
//     update();
//   }
// }


/// VB Material Inspection  ==========================================================
class MaterialInspectionScreenController extends GetxController {
  List<MaterialInspection> searchMaterialInspectionResponseModel = [];
  MaterialInspectionResponseModel? materialInspectionResponseModel;
  MaterialInspectionPointsModel? getMaterialInspectionCheckListResponseModel;

  ///-----

  ///
  MaterialInspection? selectedReport;
  List<MiChecklist> selectedReportCheckListData = [];
  var towerId = Get.arguments["towerId"];
  var projectId = Get.arguments["projectId"];
  var projectName = Get.arguments["projectName"];
  var miId = Get.arguments["id"];
  var screen = Get.arguments["screen"];

  List<TextEditingController> textControllerList = [];

  int userId = int.parse(preferences.getString(SharedPreference.userId) ?? "0");

  DateTime inspectionDate = DateTime.now();
  DateTime dateOfMaterialRecive = DateTime.now();
  bool isEdit = false;
  String status = '';
  bool isLoading = false;
  String? imgFile;
  List<String>? overAllImagesList = [];

  /// Controllers

  TextEditingController inspectionDateController = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
  TextEditingController dateOfMaterialReciveController = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
  TextEditingController mirNoController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController materialDiscController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController quantityPerInvoiceController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController lotNoController = TextEditingController();
  TextEditingController overAllRemarkController = TextEditingController();

  String image = "";
  String seqNo = "";

  @override
  void onInit() {
    super.onInit();
    if (screen != "notification") {
      getMaterialInspection();
    }
    projectNameController = TextEditingController(text: projectName.toString());
  }

  updateSelectedReport(MaterialInspection report) {
    selectedReport = report;

    status = selectedReport?.status == "draft"
        ? 'maker'
        : selectedReport?.status == "submit"
            ? 'checker'
            : 'approver';
    if (selectedReport?.status == "approve") {
      isEdit = false;
    } else if (preferences.getString(SharedPreference.userType) == status) {
      isEdit = true;
    } else {
      isEdit = false;
    }
    update();
  }

  /// Overall Image Capture
  captureOverallImage({required BuildContext context, String? screen}) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then(
      (value) async {
        if (value != null) {
          Uint8List imageBytes = await value.readAsBytes();
          img.Image? image = img.decodeImage(imageBytes);
          img.Image resizedImage = img.copyResize(image!, width: 800);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
          File compressedFile = File(value.path)
            ..writeAsBytesSync(compressedBytes);

          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageCaptureScreen(
                  image: File(compressedFile.path.toString()),
                  title: screen == "CreateMaterialInspectionScreen"
                      ? "Test Project"
                      : (selectedReport?.seqNo ?? "").toString()),
            ),
          ).then(
            (value1) {
              if (value1 != true) {
                imgFile = value1["image"];

                log('imgFile==========>>>>>> ${imgFile}');
                screen == "CreateMaterialInspectionScreen"
                    ? overAllImagesList?.add(imgFile!)
                    : selectedReport?.imageUrlData?.add(imgFile!);
              }
              return;
            },
          );
        } else {
          return value;
        }
      },
    );

    update();
  }

  removeOverallImage(int id, String? screen) {
    screen == "CreateMaterialInspectionScreen"
        ? overAllImagesList?.removeAt(id)
        : selectedReport?.imageUrlData?.removeAt(id);
    update();
  }

  ApiResponse _getMaterialInspectionResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getMaterialInspectionResponse =>
      _getMaterialInspectionResponse;

  Future<void> getMaterialInspection({bool? towerIds, String? miIds}) async {
    _getMaterialInspectionResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      materialInspectionResponseModel = await ProjectRepo()
          .getMaterialInspection(
              body: {"tower_id": towerIds ?? towerId, "mi_id": miIds ?? false});
      searchMaterialInspectionResponseModel =
          materialInspectionResponseModel?.miData?.materialInspection ?? [];

      _getMaterialInspectionResponse =
          ApiResponse.complete(materialInspectionResponseModel);
    } catch (e) {
      _getMaterialInspectionResponse = ApiResponse.error(message: e.toString());
      log("mIResponsesdfsdf=ERROR=>$e");
    }
    update();
  }

  ApiResponse _getMaterialInspectionCheckListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getMaterialInspectionCheckListResponse =>
      _getMaterialInspectionCheckListResponse;

  Future<void> getMaterialInspectionCheckPoints() async {
    _getMaterialInspectionCheckListResponse =
        ApiResponse.loading(message: 'Loading');
    update();
    try {
      getMaterialInspectionCheckListResponseModel =
          await ProjectRepo().getMaterialInspectionCheckList();

      _getMaterialInspectionCheckListResponse =
          ApiResponse.complete(getMaterialInspectionCheckListResponseModel);
    } catch (e) {
      _getMaterialInspectionCheckListResponse =
          ApiResponse.error(message: e.toString());
      log("mIResponse=ERROR=>$e");
    }
    update();
  }

  /// Create Material Inspection
  ApiResponse _createMiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get createMiResponse => _createMiResponse;

  Future<void> createMaterialInspection({required String isDraft}) async {
    update();
    log(' requestBody(isDraft: isDraft)----------- ${requestBody(isDraft: isDraft)}');

    // if(getMaterialInspectionCheckListResponseModel?.miChecklist?.any((element) => element.isPass.toLowerCase() == "no" && element.))
    if (mirNoController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter Mir no');
    } else if (companyNameController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter Company Name');
    } else if (supplierNameController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter Supplier Name');
    } else if (materialDiscController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter Material Discription');
    } else if (invoiceNoController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter Invoice No');
    } else if (quantityPerInvoiceController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter Quantity as Per Challan');
    } else if (vehicleNoController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter vehicle no');
    } else if (lotNoController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter batch no');
    } else if (overAllRemarkController.text.isEmpty) {
      errorSnackBar("Required Field", 'Please enter overall remark');
    } else if (getMaterialInspectionCheckListResponseModel!.miChecklist!
        .any((element) => element.controller.text.isEmpty)) {
      errorSnackBar("Required Field", 'Please enter Comment/Remark');
    } else if ((overAllImagesList ?? []).isEmpty) {
      errorSnackBar("Required Field", 'Please Select Overall Image');
    } else {
      _createMiResponse = ApiResponse.loading(message: 'Loading');
      try {
        SuccessDataResponseModel successDataResponseModel = await ProjectRepo()
            .createMaterialInspection(body: requestBody(isDraft: isDraft));
        if (successDataResponseModel.status == "SUCCESS") {
          Get.back();
          successSnackBar("Success", "Material Inspection Created");
          getMaterialInspection();
        } else {
          log('successDataResponseModel.message----------- ${successDataResponseModel.message}');

          errorSnackBar(
              "Something Went Wrong", successDataResponseModel.message ?? "");
        }
        _createMiResponse = ApiResponse.complete(successDataResponseModel);
      } catch (e) {
        _createMiResponse = ApiResponse.error(message: e.toString());
        log("Create Mi Response Erorr=>$e");
      }
    }
    update();
  }

  /// Update Material Inspection
  ApiResponse _updateMiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get updateMiResponse => _updateMiResponse;

  Future<void> updateMi({required String isDraft}) async {
    if (selectedReportCheckListData.any(
            (element) => (element.isPass == "No" || element.isPass == "no")) ==
        true) {
      errorSnackBar("Alert !",
          // 'You can not Submit this checklist because You Selected "No" checkpoints');
          'You cannot submit the checklist unless checkpoint value is marked as "Yes"');

    } else if (selectedReportCheckListData
            .any((element) => element.controller.text.isEmpty) ==
        true) {
      errorSnackBar("Required Field", "Please enter description");
    } else {
      _updateMiResponse = ApiResponse.loading(message: 'Loading');
      update();

      try {
        log('requestUpdateBody----------- ${jsonEncode(requestUpdateBody(isDraft: isDraft))}');

        SuccessDataResponseModel successDataResponseModel = await ProjectRepo()
            .updateMaterialRepo(body: requestUpdateBody(isDraft: isDraft));
        log('successDataResponseModel----------- ${successDataResponseModel.toJson()}');

        if (successDataResponseModel.status == "SUCCESS" ||
            successDataResponseModel.status == "success") {
          Get.back();
          successSnackBar("Success", "Material Inspection Updated");
          if (screen == 'notification') {
            getMaterialInspection(towerIds: false, miIds: miId);
          } else {
            getMaterialInspection();
          }
        } else {
          errorSnackBar(
              "Something Went Wrong", successDataResponseModel.message ?? "");
        }
        _updateMiResponse = ApiResponse.complete(successDataResponseModel);
      } catch (e) {
        _updateMiResponse = ApiResponse.error(message: e.toString());
        log("Update Mi Response Error=>$e");
      }
      update();
    }
  }

  /// Reject Material Inspection
  ApiResponse _rejectMiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get rejectMiResponse => _rejectMiResponse;

  Future<void> rejectMi({required String isDraft}) async {
    int? con = selectedReportCheckListData
        .indexWhere((element) => (element.isPass.toLowerCase() == "no"));

    if (con < 0) {
      errorSnackBar("Alert !",
          // 'You can not reject or sent back this checklist because not any points select as "No"');
        'You cannot reject or send back the checklist unless checkpoint is marked as "No"');

      return;
    }

    if (selectedReportCheckListData.any((element) =>
            element.controller.text.isEmpty &&
            (element.isPass == "No" || element.isPass == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter description for 'No' selected checkpoints");
      log('Hello description validation');
    } else if (selectedReportCheckListData
            .any((element) => element.controller.text.isEmpty) ==
        true) {
      errorSnackBar("Required Field", "Please enter description");
    } else {
      log("SUBMITTED");
      List<Map<String, dynamic>> checkListResponse = [];
      for (var element in selectedReportCheckListData) {
        checkListResponse.add({
          "mi_checklist_id": element.checklistId,
          "is_pass": element.isPass.toLowerCase() == "yes"
              ? 'yes'
              : element.isPass.toLowerCase() == "no"
                  ? 'no'
                  : 'na',
          "remark": element.controller.text.trim(),
          "line_id": element.id
        });
      }
      String base64String = "";

      if (!image.contains("http://") && image.isNotEmpty) {
        File path = File(image);
        List<int> fileBytes = path.readAsBytesSync();
        base64String = base64Encode(fileBytes);
      }

      /// Overall Image add
      List overallImageListData = [];
      selectedReport?.imageUrlData?.forEach((element) {
        if (!element.contains('http://')) {
          String base64String = '';
          File path = File(element);
          if (path.existsSync()) {
            List<int> fileBytes = path.readAsBytesSync();
            base64String = base64Encode(fileBytes);
          }
          overallImageListData.add(base64String);
          update();
        }
      });

      Map<String, dynamic> body = {
        "mi_id": selectedReport?.id,
        "user_id": int.parse(
            preferences.getString(SharedPreference.userId).toString()),
        "is_draft": isDraft,
        "company_name": companyNameController.text.trim(),
        "mir_no": mirNoController.text.trim(),
        "tower_id": int.parse(towerId ?? "${selectedReport?.towerId}"),
        "project_info_id":
            int.parse(projectId ?? "${selectedReport?.projectInfoId}"),
        "supplier_name": supplierNameController.text.trim(),
        "project_name": projectNameController.text.trim(),
        "material_description": materialDiscController.text.trim(),
        "invoice_no": invoiceNoController.text.trim(),
        "quantity_as_invoice": quantityPerInvoiceController.text.trim(),
        "vehicle_no": vehicleNoController.text.trim(),
        "date_of_inspection": DateFormat("yyyy-MM-dd").format(inspectionDate),
        "date_of_material_received":
            DateFormat("yyyy-MM-dd").format(dateOfMaterialRecive),
        "batch_no": lotNoController.text.trim(),
        "checklist_line": checkListResponse,
        "overall_remark": overAllRemarkController.text.trim(),
        "image": "", // base64String.isEmpty ? image : base64String

        if (overallImageListData.isNotEmpty) "image_data": overallImageListData,
      };
      log('body-------REJECT MI---- ${body}');

      _rejectMiResponse = ApiResponse.loading(message: 'Loading');
      update();
      try {
        SuccessDataResponseModel successDataResponseModel =
            await ProjectRepo().rejectMakerRepo(body: body);
        if (successDataResponseModel.status == "SUCCESS") {
          Get.back();
          successSnackBar("Success", "Material Inspection Rejected");
          if (screen == 'notification') {
            getMaterialInspection(towerIds: false, miIds: miId);
          } else {
            getMaterialInspection();
          }
        } else {
          errorSnackBar(
              "Something Went Wrong", successDataResponseModel.message ?? "");
        }
        _rejectMiResponse = ApiResponse.complete(successDataResponseModel);
      } catch (e) {
        _rejectMiResponse = ApiResponse.error(message: e.toString());
        log("Reject Mi Response Error=>$e");
      }
      update();
    }
  }
  // Future<void> rejectMi({required String isDraft}) async {
  //   _rejectMiResponse = ApiResponse.loading(message: 'Loading');
  //   update();
  //   try {
  //     SuccessDataResponseModel successDataResponseModel =
  //         await ProjectRepo().rejectMakerRepo(body: requestUpdateBody(isDraft: isDraft));
  //     if (successDataResponseModel.status == "SUCCESS") {
  //       Get.back();
  //       successSnackBar("Success", "Material Inspection Rejected");
  //       if (screen == 'notification') {
  //         getMaterialInspection(towerIds: false, miIds: miId);
  //       } else {
  //         getMaterialInspection();
  //       }
  //     } else {
  //       errorSnackBar("Something Went Wrong", successDataResponseModel.message ?? "");
  //     }
  //     _rejectMiResponse = ApiResponse.complete(successDataResponseModel);
  //   } catch (e) {
  //     _rejectMiResponse = ApiResponse.error(message: e.toString());
  //     log("Reject Mi Response Error=>$e");
  //   }
  //   update();
  // }

  changeDropDownValue(
    int index,
    String newValue,
  ) {
    getMaterialInspectionCheckListResponseModel?.miChecklist?[index].isPass =
        newValue;

    update();
  }

  changeUpdateDropDownValue(
    int index,
    String newValue,
  ) {
    selectedReportCheckListData[index].isPass = newValue;
    update();
  }

  search(String query) {
    searchMaterialInspectionResponseModel = [];
    if (query.trim().isEmpty) {
      searchMaterialInspectionResponseModel =
          materialInspectionResponseModel?.miData?.materialInspection ?? [];
    } else {
      materialInspectionResponseModel?.miData?.materialInspection
          ?.forEach((element) {
        if (element.seqNo!.toLowerCase().contains(query.toLowerCase())) {
          searchMaterialInspectionResponseModel.add(element);
        }
      });
    }
    update();
  }

  setData({String? screen, String? miId}) async {
    selectedReportCheckListData = [];
    if (screen == 'notification') {
      isLoading = true;
      update();
      await getMaterialInspection(towerIds: false, miIds: miId).then((value) {
        updateSelectedReport(searchMaterialInspectionResponseModel.first);
      });
      isLoading = false;
      update();
    }

    final selectedReport = this.selectedReport;
    if (selectedReport != null) {
      // titleController.text = selectedReport?.title ?? "";
      seqNo = selectedReport?.seqNo ?? "";
      mirNoController.text = selectedReport?.mirNo ?? "";
      projectNameController.text = selectedReport?.projectName ?? "";
      companyNameController.text = selectedReport?.companyName ?? "";
      supplierNameController.text = selectedReport?.supplierName ?? "";
      materialDiscController.text = selectedReport?.materialDesc ?? "";
      invoiceNoController.text = selectedReport?.invoiceNo ?? "";
      quantityPerInvoiceController.text =
          selectedReport?.qualityAsPerChallanInv ?? "";
      vehicleNoController.text = selectedReport?.vehicleNo ?? "";
      lotNoController.text = selectedReport?.batchNo ?? "";
      overAllRemarkController.text = selectedReport?.remark ?? "";
      image = selectedReport?.image ?? "";
      inspectionDate = DateTime.parse(selectedReport?.dateOfInsp ?? "");
      inspectionDateController.text =
          DateFormat("dd-MM-yyyy").format(inspectionDate);
      dateOfMaterialRecive =
          DateTime.parse(selectedReport?.dateOfMaterial ?? "");
      dateOfMaterialReciveController.text =
          DateFormat("dd-MM-yyyy").format(dateOfMaterialRecive);
      selectedReport?.lineData?.forEach((element1) {
        getMaterialInspectionCheckListResponseModel?.miChecklist
            ?.forEach((element) {
          if (element.id == element1.checklistId) {
            selectedReportCheckListData.add(MiChecklist(
                id: element1.id,
                name: element.name,
                checklistId: element1.checklistId,
                controller: TextEditingController.fromValue(
                    TextEditingValue(text: element1.remark ?? "")),
                isPass: element1.observation ?? ""));
          }
        });
      });
      log('selectedReportCheckListData==========>>>>>> ${selectedReportCheckListData.length}');
      log('selectedReportCheckListData==========>>>>>> ${selectedReport.imageUrlData?.length}');

      update();
    }
  }

  requestBody({required String isDraft}) {
    List<Map<String, dynamic>> checkListResponse = [];
    getMaterialInspectionCheckListResponseModel?.miChecklist
        ?.forEach((element) {
      checkListResponse.add({
        "mi_checklist_id": element.id,
        "is_pass": element.isPass.toLowerCase() == "yes"
            ? 'yes'
            : element.isPass.toLowerCase() == "no"
                ? 'no'
                : 'na',
        "remark": element.controller.text.trim()
      });
    });

    String base64String = "";

    if (image.isNotEmpty) {
      File path = File(image);
      List<int> fileBytes = path.readAsBytesSync();
      base64String = base64Encode(fileBytes);
    }

    /// Overall Image add
    List overallImageListData = [];
    overAllImagesList?.forEach((element) {
      if (!element.contains('http://')) {
        String base64String = '';
        File path = File(element);
        if (path.existsSync()) {
          List<int> fileBytes = path.readAsBytesSync();
          base64String = base64Encode(fileBytes);
        }
        overallImageListData.add(base64String);
        update();
      }
    });

    Map<String, dynamic> body = {
      "isDraft": isDraft,
      "company_name": companyNameController.text.trim(),
      "mir_no": mirNoController.text.trim(),
      "tower_id": int.parse(towerId.toString()),
      "project_info_id": int.parse(projectId.toString()),
      "supplier_name": supplierNameController.text.trim(),
      "project_name": projectNameController.text.trim(),
      "material_description": materialDiscController.text.trim(),
      "invoice_no": invoiceNoController.text.trim(),
      "quantity_as_invoice": quantityPerInvoiceController.text.trim(),
      "vehicle_no": vehicleNoController.text.trim(),
      "date_of_inspection": DateFormat("yyyy-MM-dd").format(inspectionDate),
      "date_of_material_received":
          DateFormat("yyyy-MM-dd").format(dateOfMaterialRecive),
      "batch_no": lotNoController.text.trim(),
      "checklist_data": checkListResponse,
      "overall_remark": overAllRemarkController.text.trim(),
      "check_by":
          int.parse(preferences.getString(SharedPreference.userId).toString()),
      "image": "", // base64String.isEmpty ? image : base64String
      if (overallImageListData.isNotEmpty) "image_data": overallImageListData,
    };
    log('body----------- ${body}');

    return body;
  }

  requestUpdateBody({required String isDraft}) {
    List<Map<String, dynamic>> checkListResponse = [];
    for (var element in selectedReportCheckListData) {
      checkListResponse.add({
        "mi_checklist_id": element.checklistId,
        "is_pass": element.isPass.toLowerCase() == "yes"
            ? 'yes'
            : element.isPass.toLowerCase() == "no"
                ? 'no'
                : 'na',
        "remark": element.controller.text.trim(),
        "line_id": element.id
      });
    }
    String base64String = "";

    if (!image.contains("http://") && image.isNotEmpty) {
      File path = File(image);
      List<int> fileBytes = path.readAsBytesSync();
      base64String = base64Encode(fileBytes);
    }

    /// Overall Image add
    List overallImageListData = [];
    selectedReport?.imageUrlData?.forEach((element) {
      if (!element.contains('http://')) {
        String base64String = '';
        File path = File(element);
        if (path.existsSync()) {
          List<int> fileBytes = path.readAsBytesSync();
          base64String = base64Encode(fileBytes);
        }
        overallImageListData.add(base64String);
        update();
      }
    });

    Map<String, dynamic> body = {
      "mi_id": selectedReport?.id,
      "user_id":
          int.parse(preferences.getString(SharedPreference.userId).toString()),
      "is_draft": isDraft,
      "company_name": companyNameController.text.trim(),
      "mir_no": mirNoController.text.trim(),
      "tower_id": int.parse(towerId ?? "${selectedReport?.towerId}"),
      "project_info_id":
          int.parse(projectId ?? "${selectedReport?.projectInfoId}"),
      "supplier_name": supplierNameController.text.trim(),
      "project_name": projectNameController.text.trim(),
      "material_description": materialDiscController.text.trim(),
      "invoice_no": invoiceNoController.text.trim(),
      "quantity_as_invoice": quantityPerInvoiceController.text.trim(),
      "vehicle_no": vehicleNoController.text.trim(),
      "date_of_inspection": DateFormat("yyyy-MM-dd").format(inspectionDate),
      "date_of_material_received":
          DateFormat("yyyy-MM-dd").format(dateOfMaterialRecive),
      "batch_no": lotNoController.text.trim(),
      "checklist_line": checkListResponse,
      "overall_remark": overAllRemarkController.text.trim(),
      "image": "", // base64String.isEmpty ? image : base64String

      if (overallImageListData.isNotEmpty) "image_data": overallImageListData,
    };
    log('body----------- ${body}');

    return body;
  }

  // requestUpdateBody({required String isDraft}) {
  //   List<Map<String, dynamic>> checkListResponse = [];
  //   for (var element in selectedReportCheckListData) {
  //     checkListResponse.add({
  //       "mi_checklist_id": element.checklistId,
  //       "is_pass": element.isPass.toLowerCase() == "yes"
  //           ? 'yes'
  //           : element.isPass.toLowerCase() == "no"
  //               ? 'no'
  //               : 'na',
  //       "remark": element.controller.text.trim(),
  //       "id": element.id
  //     });
  //   }
  //   String base64String = "";
  //
  //   if (!image.contains("http://")) {
  //     File path = File(image);
  //     List<int> fileBytes = path.readAsBytesSync();
  //     base64String = base64Encode(fileBytes);
  //   }
  //
  //   Map<String, dynamic> body = {
  //     "mi_id": selectedReport?.id,
  //     "user_id":
  //         int.parse(preferences.getString(SharedPreference.userId).toString()),
  //     "isDraft": isDraft,
  //     "checklist_line": {
  //       "check_by": int.parse(
  //           preferences.getString(SharedPreference.userId).toString()),
  //       "company_name": companyNameController.text.trim(),
  //       "mir_no": mirNoController.text.trim(),
  //       "tower_id": int.parse(towerId),
  //       "project_info_id": int.parse(projectId),
  //       "supplier_name": supplierNameController.text.trim(),
  //       "project_name": projectNameController.text.trim(),
  //       "material_description": materialDiscController.text.trim(),
  //       "invoice_no": invoiceNoController.text.trim(),
  //       "quantity_as_invoice": quantityPerInvoiceController.text.trim(),
  //       "vehicle_no": vehicleNoController.text.trim(),
  //       "date_of_inspection": DateFormat("yyyy-MM-dd").format(inspectionDate),
  //       "date_of_material_received":
  //           DateFormat("yyyy-MM-dd").format(dateOfMaterialRecive),
  //       "batch_no": lotNoController.text.trim(),
  //       "checklist_data": checkListResponse,
  //     },
  //     "overall_remark": overAllRemarkController.text.trim(),
  //     "image": base64String.isEmpty ? image : base64String
  //   };
  //
  //   return body;
  // }

  void disposeForm() {
    // titleController.clear();
    mirNoController.clear();
    projectNameController.clear();
    companyNameController.clear();
    supplierNameController.clear();
    materialDiscController.clear();
    invoiceNoController.clear();
    quantityPerInvoiceController.clear();
    vehicleNoController.clear();
    lotNoController.clear();
    selectedReport = null;
    selectedReportCheckListData.clear();
    overAllRemarkController.clear();
    image = "";
    dateOfMaterialRecive = DateTime.now();
    dateOfMaterialReciveController.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now());
    inspectionDate = DateTime.now();
    inspectionDateController.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now());
  }

  updateImage(String image) {
    this.image = image;
    update();
  }

  /// Delete Material Inspection
  ApiResponse _deleteMi = ApiResponse.initial(message: 'Initialization');

  ApiResponse get deleteMi => _deleteMi;

  Future<void> deleteMaterialInspection(String id) async {
    _deleteMi = ApiResponse.loading(message: 'Loading');
    update();
    try {
      SuccessDataResponseModel successDataResponseModel =
          await ProjectRepo().deleteMaterialInspection(body: {"mi_id": id});
      if (successDataResponseModel.status == "SUCCESS") {
        successSnackBar("Success", "Material Inspection Deleted");
        getMaterialInspection();
      } else {
        errorSnackBar(
            "Something Went Wrong", successDataResponseModel.message ?? "");
      }
      _deleteMi = ApiResponse.complete(successDataResponseModel);
    } catch (e) {
      _deleteMi = ApiResponse.error(message: e.toString());
      log("Delete Mi Response Error=>$e");
    }
    update();
  }

  /// Replicate Material Inspection
  ApiResponse _replicateMi = ApiResponse.initial(message: 'Initialization');

  ApiResponse get replicateMi => _replicateMi;

  Future<void> replicateMaterialInspection(String id) async {
    _replicateMi = ApiResponse.loading(message: 'Loading');
    update();
    try {
      SuccessDataResponseModel successDataResponseModel =
          await ProjectRepo().replicateMaterialInspection(body: {"mi_id": id});
      if (successDataResponseModel.status == "SUCCESS") {
        successSnackBar("Success", "Material Inspection Replicated");
        getMaterialInspection();
      } else {
        errorSnackBar(
            "Something Went Wrong", successDataResponseModel.message ?? "");
      }
      _replicateMi = ApiResponse.complete(successDataResponseModel);
    } catch (e) {
      _replicateMi = ApiResponse.error(message: e.toString());
      log("Replicate Mi Response Error =>$e");
      if (e.toString() == "Error During Communication:Internal Server Error") {
        errorSnackBar("Internal Server Error", "Something Went Wrong");
      }
    }
    update();
  }

  /// Capture Image
  capturePhoto({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then(
      (value) async {
        if (value != null) {
          Uint8List imageBytes = await value.readAsBytes();
          img.Image? image = img.decodeImage(imageBytes);
          img.Image resizedImage = img.copyResize(image!, width: 800);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
          File compressedFile = File(value.path)
            ..writeAsBytesSync(compressedBytes);
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageCaptureScreen(
                image: File(compressedFile.path.toString()),
                title: seqNo,
              ),
            ),
          ).then(
            (value1) {
              if (value1 != true) {
                this.image = value1['image'];
                update();
              }
              return;
            },
          );
        } else {
          return value;
        }
      },
    );

    update();
  }
/*
  ///------------------------

  /// UPLOAD DATA

  ApiResponse _uploadDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get uploadDataApiResponse => _uploadDataApiResponse;

  Future<dynamic> uploadMakerController({required String isDraft}) async {
    // if (selectedReport?.lineData?.any((element) =>
    //         element.controller.text.isEmpty &&
    //         (element.value == "No" || element.value == "no")) ==
    //     true) {
    //   errorSnackBar("Required Field",
    //       "Please enter description for 'No' selected checkpoints");
    //   log('Hello description validation');
    // } else if (selectedReport?.lineData?.any((element) =>
    //         element.imageList.isEmpty &&
    //         (element.value == "No" || element.value == "no")) ==
    //     true) {
    //   errorSnackBar("Required Field",
    //       "Please enter at least one image for 'No' selected checkpoints");
    // } else {
    //   _uploadDataApiResponse = ApiResponse.loading(message: 'Loading');
    //   update();
    //   List<Map<String, dynamic>> checkListData = [];
    //
    //   selectedReport?.lineData?.forEach((element) {
    //     element.imageData = [];
    //     for (var element1 in element.imageList) {
    //       if (!element1.contains('http://')) {
    //         String base64String = '';
    //         File path = File(element1);
    //         if (path.existsSync()) {
    //           List<int> fileBytes = path.readAsBytesSync();
    //           base64String = base64Encode(fileBytes);
    //         }
    //         element.imageData.add(base64String);
    //       }
    //     }
    //
    //     checkListData.add(
    //       {
    //         "line_id": element.lineId,
    //         "is_pass": element.value.toLowerCase() == "yes"
    //             ? 'yes'
    //             : element.value.toLowerCase() == "no"
    //                 ? 'no'
    //                 : 'nop',
    //         if (element.value.toLowerCase() == "no")
    //           "reason": element.controller.text,
    //         if (element.value.toLowerCase() == "yes" &&
    //             element.controller.text.isNotEmpty)
    //           "reason": element.controller.text,
    //         if (element.value.toLowerCase() == "no")
    //           "image_data": element.imageData,
    //         if (element.value.toLowerCase() == "yes" &&
    //             element.imageData.isNotEmpty)
    //           "image_data": element.imageData,
    //       },
    //     );
    //   });
    Map<String, dynamic> body = {
      "user_id": userId,
      "is_draft": isDraft,
      "mi_id": selectedReport?.mirNo,
      "checklist_line": checkListData,
      "overall_remarks": activityData?.controller.text.toString().trim(),
    };

    try {
      SuccessDataResponseModel response =
          await ProjectRepo().updateMaterialRepo(body: body);
      _uploadDataApiResponse = ApiResponse.complete(response);

      if (response.status == "SUCCESS" || response.status == "Maker") {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 500));
        successSnackBar(
            "Success",
            isDraft == "yes"
                ? 'Checklist data saved successfully'
                : 'Checklist data updated successfully');
      }
      log("_makerUploadDataApiResponse==>$response");
    } catch (e) {
      _uploadDataApiResponse = ApiResponse.error(message: e.toString());
      log("_makerUploadDataApiResponse=ERROR=>$e");
    }
    update();
  }*/
}

///
//}

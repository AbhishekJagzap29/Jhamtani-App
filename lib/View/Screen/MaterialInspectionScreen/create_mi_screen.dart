import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/material_inspection_response_model.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/MaterialInspectionScreen/material_inspection_screen_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';

// // VJ Material Inspection Screen ===========================================================
// class CreateMaterialInspectionScreen extends StatefulWidget {
//   const CreateMaterialInspectionScreen({super.key});

//   @override
//   State<CreateMaterialInspectionScreen> createState() =>
//       _CreateMaterialInspectionScreenState();
// }

// class _CreateMaterialInspectionScreenState
//     extends State<CreateMaterialInspectionScreen> {
//   MaterialInspectionScreenController materialInspectionScreenController =
//       Get.find();
//   final formKey = GlobalKey<FormState>();

//   String? selectedBusinessUnit;
//   String? selectedLedgerDescription;
//   String? selectedMaterialDescription;
//   String? selectedMaterialQuantity;
//   String? selectedUomCode;
//   String? selectedDocumentNumber;
//   String? selectedPendingQuantity;
//   String? selectedFinalQuantity;

//   TextEditingController inspectionDateController = TextEditingController(
//       text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
//   TextEditingController dateOfMaterialReciveController = TextEditingController(
//       text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
//   TextEditingController mirNoController = TextEditingController();
//   TextEditingController projectNameController = TextEditingController();
//   TextEditingController companyNameController = TextEditingController();
//   TextEditingController supplierNameController = TextEditingController();
//   TextEditingController materialDiscController = TextEditingController();
//   TextEditingController invoiceNoController = TextEditingController();
//   TextEditingController quantityPerInvoiceController = TextEditingController();
//   TextEditingController vehicleNoController = TextEditingController();
//   TextEditingController lotNoController = TextEditingController();
//   TextEditingController overAllRemarkController = TextEditingController();
//   TextEditingController pendingQuantityController = TextEditingController();
//   TextEditingController enterQuantityController = TextEditingController();
//   TextEditingController lineIdController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       loadData();
//     });
//   }

//   @override
//   void dispose() {
//     materialInspectionScreenController.disposeForm();
//     super.dispose();
//   }

//   loadData() async {
//     await materialInspectionScreenController.getMaterialInspectionCheckPoints();
//     materialInspectionScreenController.projectNameController.text =
//         materialInspectionScreenController.projectName;
//     await materialInspectionScreenController.getLedgerDescription(
//         buId: materialInspectionScreenController.buId);
//   }

//   Future<void> refreshPage() async {
//     setState(() {
//       selectedBusinessUnit = null;
//       selectedLedgerDescription = null;
//       selectedMaterialDescription = null;
//       selectedMaterialQuantity = null;
//       selectedUomCode = null;
//       selectedDocumentNumber = null;
//       selectedPendingQuantity = null;
//       selectedFinalQuantity = null;

//       inspectionDateController.text =
//           DateFormat("dd-MM-yyyy").format(DateTime.now());
//       dateOfMaterialReciveController.text =
//           DateFormat("dd-MM-yyyy").format(DateTime.now());
//       mirNoController.clear();
//       projectNameController.clear();
//       companyNameController.clear();
//       supplierNameController.clear();
//       materialDiscController.clear();
//       invoiceNoController.clear();
//       quantityPerInvoiceController.clear();
//       vehicleNoController.clear();
//       lotNoController.clear();
//       overAllRemarkController.clear();
//       pendingQuantityController.clear();
//       enterQuantityController.clear();
//       lineIdController.clear();

//       materialInspectionScreenController.mirNoController.clear();
//       materialInspectionScreenController.projectNameController.clear();
//       materialInspectionScreenController.supplierNameController.clear();
//       materialInspectionScreenController.materialDiscController.clear();
//       materialInspectionScreenController.invoiceNoController.clear();
//       materialInspectionScreenController.quantityPerInvoiceController.clear();
//       materialInspectionScreenController.vehicleNoController.clear();
//       materialInspectionScreenController.lotNoController.clear();
//       materialInspectionScreenController.overAllRemarkController.clear();
//       materialInspectionScreenController.pendingQuantityController.clear();
//       materialInspectionScreenController.enterQuantityController.clear();
//       materialInspectionScreenController.lineIdController.clear();

//       materialInspectionScreenController.selectedReport = null;
//       materialInspectionScreenController.seqNo = '';
//       materialInspectionScreenController.docNumberController.clear();
//       materialInspectionScreenController.uomCodeController.clear();
//       materialInspectionScreenController.inspectionDateController.text =
//           DateFormat("dd-MM-yyyy").format(DateTime.now());
//       materialInspectionScreenController.dateOfMaterialReciveController.text =
//           DateFormat("dd-MM-yyyy").format(DateTime.now());

//       materialInspectionScreenController.ledgerList.clear();
//       materialInspectionScreenController.documentNumberList.clear();
//       materialInspectionScreenController.materialList.clear();
//     });

//     await loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;

//     return Form(
//       key: formKey,
//       child: Scaffold(
//         appBar: AppBarWidget(
//             title: AppString.materialInspectionReport
//                 .boldRobotoTextStyle(fontSize: 20)),
//         body: SafeArea(
//           child: GetBuilder<MaterialInspectionScreenController>(
//               builder: (controller) {
//             if (controller.getMaterialInspectionCheckListResponse.status ==
//                 Status.LOADING) {
//               return showCircular();
//             } else if (controller
//                     .getMaterialInspectionCheckListResponse.status ==
//                 Status.COMPLETE) {
//               return Stack(
//                 children: [
//                   Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                       child: RefreshIndicator(
//                         onRefresh: refreshPage,
//                         child: SingleChildScrollView(
//                           physics: const BouncingScrollPhysics(),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               (h * 0.01).addHSpace(),
//                               controller.selectedReport != null
//                                   ? Padding(
//                                       padding: EdgeInsets.only(top: h * 0.02),
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: h * 0.035,
//                                             horizontal: w * 0.05),
//                                         decoration: BoxDecoration(
//                                           color: containerColor,
//                                           border: Border.all(
//                                             color: const Color(0xffE6E6E6),
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                         ),
//                                         child: Center(
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               "Sequence Number"
//                                                   .toString()
//                                                   .semiBoldBarlowTextStyle(
//                                                       fontSize: 18),
//                                               SizedBox(width: w * 0.025),
//                                               SizedBox(
//                                                 width: w * 0.34,
//                                                 //   color: Colors.red,
//                                                 child: controller.seqNo
//                                                     .semiBoldBarlowTextStyle(
//                                                         fontSize: 17),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox(),

//                               (h * 0.02).addHSpace(),

//                               inputTextField(w, h,
//                                   controller: controller.mirNoController,
//                                   hintText: "Enter MIR No",
//                                   isReadOnly: true
//                                   //validationText: 'Please Enter MIR No'
//                                   ),
//                               (h * 0.02).addHSpace(),

//                               inputTextField(w, h,
//                                   controller: controller.projectNameController,
//                                   hintText: "Enter Project Name",
//                                   validationText: "Please Enter Project Name"),

//                               (h * 0.02).addHSpace(),

//                               dropdownField(w, h,
//                                   label: "Enter Supplier Name",
//                                   hintText: "Select Supplier",
//                                   value: selectedLedgerDescription,
//                                   items: controller.ledgerList.isNotEmpty
//                                       ? controller.ledgerList
//                                           .map((e) =>
//                                               e.name ?? "No Supplier Data")
//                                           .toSet()
//                                           .toList()
//                                       : ["No Data Available"],
//                                   displayText: (item) => item.toString(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedLedgerDescription = value;

//                                       final selectedLedger =
//                                           controller.ledgerList.firstWhere(
//                                         (e) => e.name == value,
//                                       );

//                                       if (selectedLedger != null) {
//                                         controller.ledgerId =
//                                             selectedLedger.ledgerId;
//                                         controller.supplierNameController.text =
//                                             selectedLedger.name ?? "";

//                                         controller.getDocumentNumber(
//                                           poId: selectedLedger.poId,
//                                         );
//                                         selectedDocumentNumber = null;
//                                       } else {
//                                         controller.buId = 0;
//                                         controller.supplierNameController.text =
//                                             "";
//                                       }
//                                     });
//                                   }),

//                               (h * 0.02).addHSpace(),

//                               dropdownField(
//                                 w,
//                                 h,
//                                 label: "Enter Document Number",
//                                 hintText: "Select Document Number",
//                                 value: selectedDocumentNumber,
//                                 items: controller.documentNumberList.isNotEmpty
//                                     ? controller.documentNumberList
//                                         .map((e) =>
//                                             e.docNo ?? "No Document Data")
//                                         .toSet()
//                                         .toList()
//                                     : ["No Data Available"],
//                                 displayText: (item) => item.toString(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedDocumentNumber = value;

//                                     final selectedDocument = controller
//                                         .documentNumberList
//                                         .firstWhere(
//                                       (e) => e.docNo == value,
//                                     );

//                                     if (selectedDocument != null) {
//                                       controller.docNumberController.text =
//                                           selectedDocument.docNo.toString();

//                                       controller.getMaterialDescription(
//                                         poId: [selectedDocument.poId],
//                                         ledgerId: controller.buId,
//                                       );
//                                       selectedMaterialDescription = null;
//                                     } else {
//                                       controller.docNumberController.text = "";
//                                     }
//                                   });
//                                 },
//                               ),

//                               (h * 0.02).addHSpace(),

//                               inputTextField(
//                                 w,
//                                 h,
//                                 controller: controller.inspectionDateController,
//                                 hintText: "Enter Inspection Date",
//                                 isReadOnly: true,
//                                 validationText: "Please Enter Inspection Date",
//                                 suffixIcon: Icon(
//                                   Icons.calendar_today,
//                                   color: blackColor,
//                                 ),
//                                 onTap: () async {
//                                   DateTime? selectedDate = await showDatePicker(
//                                     context: context,
//                                     firstDate: DateTime(2000),
//                                     lastDate: DateTime(3000),
//                                     initialDate: DateTime.now(),
//                                     currentDate: DateTime.now(),
//                                     builder: (context, child) {
//                                       return Theme(
//                                           data: Theme.of(context).copyWith(
//                                             colorScheme: ColorScheme.light(
//                                               primary:
//                                                   blackColor.withOpacity(0.9),
//                                               onPrimary: Colors.white,
//                                               onSurface:
//                                                   blackColor.withOpacity(0.9),
//                                             ),
//                                             textButtonTheme:
//                                                 TextButtonThemeData(
//                                               style: TextButton.styleFrom(
//                                                 foregroundColor: Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                           child: child!);
//                                     },
//                                   );
//                                   if (selectedDate != null) {
//                                     controller.inspectionDate = selectedDate;
//                                   }

//                                   controller.inspectionDateController.text =
//                                       DateFormat("dd-MM-yyyy")
//                                           .format(controller.inspectionDate);
//                                 },
//                               ),
//                               (h * 0.02).addHSpace(),

//                               _dropdownField(
//                                 w,
//                                 h,
//                                 label: "Enter Material Description",
//                                 hintText: "Select Material",
//                                 value: selectedMaterialDescription,
//                                 items: controller.materialList.isNotEmpty
//                                     ? controller.materialList
//                                         .map((e) =>
//                                             e.description ?? "No Material Data")
//                                         .toSet()
//                                         .toList()
//                                     : ["No Data Available"],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedMaterialDescription = value;

//                                     final selectedMaterial =
//                                         controller.materialList.firstWhere(
//                                       (e) => e.description == value,
//                                     );

//                                     controller.lineIdController.text =
//                                         selectedMaterial.lineId?.toString() ??
//                                             "";

//                                     controller.materialDiscController.text =
//                                         selectedMaterial.description ?? "";

//                                     controller
//                                             .quantityPerInvoiceController.text =
//                                         selectedMaterial.quantity?.toString() ??
//                                             "";
//                                     controller.uomCodeController.text =
//                                         selectedMaterial.uomCode?.toString() ??
//                                             "";

//                                     controller.pendingQuantityController.text =
//                                         selectedMaterial.pendingQuantity
//                                                 ?.toString() ??
//                                             "";
//                                     selectedMaterialQuantity = null;
//                                   });
//                                 },
//                               ),

//                               (h * 0.02).addHSpace(),

//                               // dropdownField(
//                               //   w,
//                               //   h,
//                               //   label: "Enter UomCode",
//                               //   hintText: "Select Uom Code",
//                               //   value: selectedUomCode,
//                               //   items: controller.materialList.isNotEmpty
//                               //       ? controller.materialList
//                               //           .map((e) => e.uomCode ?? "Unknown code")
//                               //           .toSet()
//                               //           .toList()
//                               //       : ["Loading..."],
//                               //   onChanged: (value) {
//                               //     setState(() {
//                               //       selectedUomCode = value;

//                               //       final selectedMaterial =
//                               //           controller.materialList.firstWhere(
//                               //         (e) => e.uomCode == value,
//                               //       );
//                               //       if (selectedMaterial != null) {
//                               //         controller.lineId =
//                               //             selectedMaterial.lineId ?? 0;
//                               //         controller.uomCodeController.text =
//                               //             (selectedMaterial.uomCode ?? "")
//                               //                 .toString();
//                               //       } else {
//                               //         controller.lineId = 0;
//                               //         controller.uomCodeController.text = "";
//                               //       }
//                               //     });
//                               //   },
//                               // ),

//                               inputTextField(w, h,
//                                   controller: controller.uomCodeController,
//                                   hintText: "Enter UomCode",
//                                   isReadOnly: true,
//                                   validationText: "Please Enter UomCode"),

//                               (h * 0.02).addHSpace(),
//                               inputTextField(w, h,
//                                   controller: controller.invoiceNoController,
//                                   hintText: "Enter Challan / Invoice No",
//                                   validationText:
//                                       "Please Enter Challan / Invoice No"),
//                               (h * 0.02).addHSpace(),

//                               // dropdownField(
//                               //   w,
//                               //   h,
//                               //   label: "Total Quantity as per Challan/Invoice",
//                               //   hintText: "Select Quantity",
//                               //   value: selectedMaterialQuantity,
//                               //   items: controller.materialList.isNotEmpty
//                               //       ? controller.materialList
//                               //           .map(
//                               //               (e) => e.quantity ?? "Unknown quantity")
//                               //           .toSet()
//                               //           .toList()
//                               //       : ["No Data Available"],
//                               //   onChanged: (value) {
//                               //     setState(() {
//                               //       selectedMaterialQuantity = value;

//                               //       final selectedMaterial =
//                               //           controller.materialList.firstWhere(
//                               //         (e) => e.quantity == value,
//                               //       );

//                               //       if (selectedMaterial != null) {
//                               //         controller.quantityPerInvoiceController.text =
//                               //             selectedMaterial.quantity! as String;
//                               //       } else {
//                               //         controller.quantityPerInvoiceController.text =
//                               //             "";
//                               //       }
//                               //     });
//                               //   },
//                               // ),

//                               inputTextField(w, h,
//                                   controller:
//                                       controller.quantityPerInvoiceController,
//                                   hintText:
//                                       "Total Quantity as per Challan/Invoice",
//                                   isReadOnly: true,
//                                   validationText: "Please Enter Quantity."),

//                               (h * 0.02).addHSpace(),

//                               inputTextField(w, h,
//                                   controller:
//                                       controller.pendingQuantityController,
//                                   hintText:
//                                       "Pending Quantity as per Challan/Invoice",
//                                   isReadOnly: true,
//                                   validationText:
//                                       "Please Enter Pending Quantity."),
//                               (h * 0.02).addHSpace(),

//                               inputTextField(w, h,
//                                   controller:
//                                       controller.enterQuantityController,
//                                   hintText: "Enter Quantity",
//                                   validationText: "Please Enter Quantity."),
//                               (h * 0.02).addHSpace(),

//                               inputTextField(w, h,
//                                   controller: controller.vehicleNoController,
//                                   hintText: "Enter Vehicle No.",
//                                   validationText: "Please Enter Vehicle No."),
//                               (h * 0.02).addHSpace(),
//                               inputTextField(
//                                 w,
//                                 h,
//                                 controller:
//                                     controller.dateOfMaterialReciveController,
//                                 hintText: "Enter Date of Material Received",
//                                 isReadOnly: true,
//                                 validationText:
//                                     "Please Enter Date of Material Received",
//                                 suffixIcon: Icon(
//                                   Icons.calendar_today,
//                                   color: blackColor,
//                                 ),
//                                 onTap: () async {
//                                   DateTime? selectedDate = await showDatePicker(
//                                     context: context,
//                                     firstDate: DateTime(2000),
//                                     lastDate: DateTime(3000),
//                                     initialDate: DateTime.now(),
//                                     currentDate: DateTime.now(),
//                                     builder: (context, child) {
//                                       return Theme(
//                                           data: Theme.of(context).copyWith(
//                                             colorScheme: ColorScheme.light(
//                                                 primary:
//                                                     blackColor.withOpacity(0.9),
//                                                 onPrimary: Colors.white,
//                                                 onSurface: blackColor
//                                                     .withOpacity(0.9)),
//                                             textButtonTheme:
//                                                 TextButtonThemeData(
//                                               style: TextButton.styleFrom(
//                                                 foregroundColor: Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                           child: child!);
//                                     },
//                                   );
//                                   if (selectedDate != null) {
//                                     controller.dateOfMaterialRecive =
//                                         selectedDate;
//                                   }
//                                   controller
//                                           .dateOfMaterialReciveController.text =
//                                       DateFormat("dd-MM-yyyy").format(
//                                           controller.dateOfMaterialRecive);
//                                 },
//                               ),

//                               (h * 0.02).addHSpace(),

//                               inputTextField(w, h,
//                                   controller: controller.lotNoController,
//                                   hintText: "Enter Batch No/Week No/Lot No.",
//                                   validationText: "Please Enter Lot No."),
//                               (h * 0.04).addHSpace(),

//                               (controller.getMaterialInspectionCheckListResponseModel
//                                           ?.miChecklist?.isEmpty ??
//                                       false)
//                                   ? const SizedBox()
//                                   : Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.blueGrey.shade100,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         children: [
//                                           (h * 0.02).addHSpace(),
//                                           "ACTION"
//                                               .boldRobotoTextStyle(fontSize: 18)
//                                               .paddingOnly(bottom: h * 0.01),
//                                           1.0.appDivider(color: Colors.grey),
//                                           ListView.separated(
//                                               itemBuilder: (context, index) {
//                                                 final data = controller
//                                                     .getMaterialInspectionCheckListResponseModel
//                                                     ?.miChecklist?[index];
//                                                 return Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: h * 0.005,
//                                                       horizontal: w * 0.02),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 top: h * 0.012),
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Row(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 const Icon(CupertinoIcons
//                                                                         .arrow_right_square_fill)
//                                                                     .paddingOnly(
//                                                                         top: h *
//                                                                             0.002),
//                                                                 (w * 0.01)
//                                                                     .addWSpace(),
//                                                                 Expanded(
//                                                                   child: "${data?.name}"
//                                                                       .capitalizeFirst
//                                                                       .toString()
//                                                                       .regularBarlowTextStyle(
//                                                                           fontSize:
//                                                                               16,
//                                                                           maxLine:
//                                                                               10,
//                                                                           textOverflow:
//                                                                               TextOverflow.ellipsis),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             (w * 0.02)
//                                                                 .addWSpace(),
//                                                             Padding(
//                                                               padding: EdgeInsets
//                                                                   .symmetric(
//                                                                       horizontal:
//                                                                           w * 0.05),
//                                                               child: Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   Row(
//                                                                     children: [
//                                                                       SizedBox(
//                                                                         width: w *
//                                                                             0.08,
//                                                                         child:
//                                                                             Radio(
//                                                                           activeColor:
//                                                                               appColor,
//                                                                           value:
//                                                                               "yes",
//                                                                           groupValue: data
//                                                                               ?.isPass
//                                                                               .toLowerCase(),
//                                                                           onChanged:
//                                                                               (value) {
//                                                                             controller.changeDropDownValue(index,
//                                                                                 value.toString());
//                                                                           },
//                                                                         ),
//                                                                       ),
//                                                                       (w * 0.02)
//                                                                           .addWSpace(),
//                                                                       const Text(
//                                                                           "Yes")
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       SizedBox(
//                                                                         width: w *
//                                                                             0.08,
//                                                                         child:
//                                                                             Radio(
//                                                                           activeColor:
//                                                                               appColor,
//                                                                           value:
//                                                                               "no",
//                                                                           groupValue: data
//                                                                               ?.isPass
//                                                                               .toLowerCase(),
//                                                                           onChanged:
//                                                                               (value) {
//                                                                             controller.changeDropDownValue(index,
//                                                                                 value.toString());
//                                                                           },
//                                                                         ),
//                                                                       ),
//                                                                       (w * 0.02)
//                                                                           .addWSpace(),
//                                                                       const Text(
//                                                                           "No")
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       SizedBox(
//                                                                         width: w *
//                                                                             0.08,
//                                                                         child:
//                                                                             Radio(
//                                                                           activeColor:
//                                                                               appColor,
//                                                                           value:
//                                                                               "na",
//                                                                           groupValue: data
//                                                                               ?.isPass
//                                                                               .toString(),
//                                                                           onChanged:
//                                                                               (value) {
//                                                                             controller.changeDropDownValue(
//                                                                               index,
//                                                                               value.toString(),
//                                                                             );
//                                                                           },
//                                                                         ),
//                                                                       ),
//                                                                       (w * 0.02)
//                                                                           .addWSpace(),
//                                                                       const Text(
//                                                                           "NA")
//                                                                     ],
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       commentRemarkText(
//                                                           controller, index, h),
//                                                       commentTextField(
//                                                           data!, w, h),
//                                                     ],
//                                                   ),
//                                                 );
//                                               },
//                                               separatorBuilder:
//                                                   (context, index) {
//                                                 return 1.0.appDivider(
//                                                     color: Colors.grey);
//                                               },
//                                               padding: EdgeInsets.only(
//                                                   bottom: h * 0.02),
//                                               physics:
//                                                   const BouncingScrollPhysics(),
//                                               shrinkWrap: true,
//                                               itemCount: controller
//                                                       .getMaterialInspectionCheckListResponseModel
//                                                       ?.miChecklist
//                                                       ?.length ??
//                                                   0),
//                                         ],
//                                       ),
//                                     ),
//                               (h * 0.02).addHSpace(),

//                               /// OVERALL REMARK TEXT

//                               AppString.overAllRemark
//                                   .boldRobotoTextStyle(fontSize: 18)
//                                   .paddingOnly(bottom: h * 0.01),

//                               /// OVERALL REMARK TEXTFIELD
//                               overAllRemark(
//                                   controller.overAllRemarkController, w, h),

//                               (h * 0.02).addHSpace(),
//                               AppString.overAllImage
//                                   .boldRobotoTextStyle(fontSize: 18)
//                                   .paddingOnly(bottom: h * 0.01),
//                               Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.blueGrey.shade100,
//                                     borderRadius: BorderRadius.circular(10)),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: h * 0.02, horizontal: w * 0.02),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     /// OVERALL IMAGE GRID VIEW

//                                     if (controller.overAllImagesList !=
//                                         null) ...[
//                                       overallImageGridView(
//                                           controller, h, context, w)
//                                     ],

//                                     /// CAPTURE IMAGE BUTTON
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                               horizontal: w * 0.18)
//                                           .copyWith(top: h * 0.03),
//                                       child: MaterialButton(
//                                         onPressed: () {
//                                           controller.captureOverallImage(
//                                               context: context,
//                                               screen:
//                                                   "CreateMaterialInspectionScreen");
//                                         },
//                                         color: Colors.black,
//                                         height: Responsive.isDesktop(context)
//                                             ? h * 0.078
//                                             : h * 0.058,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   right: w * 0.04),
//                                               child: assetImage(
//                                                   AppAssets.cameraIcon,
//                                                   scale: 2),
//                                             ),
//                                             AppString.capturePhoto
//                                                 .boldRobotoTextStyle(
//                                                     fontSize: 16,
//                                                     fontColor: backGroundColor),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               (h * 0.03).addHSpace(),
//                               // ],

//                               Column(
//                                 children: [
//                                   /// SAVE AS DRAFT
//                                   saveAsDraftButton(h, controller, context),

//                                   /// REJECT AND SUBMIT
//                                   Row(
//                                     children: [
//                                       /// REJECT (SENT BACK)
//                                       if (preferences.getString(
//                                               SharedPreference.userType) !=
//                                           "maker") ...[
//                                         rejectButton(controller, h, context),
//                                         (w * 0.03).addWSpace()
//                                       ],

//                                       /// SUBMIT
//                                       preferences.getString(SharedPreference
//                                                       .userType) ==
//                                                   "maker" &&
//                                               controller
//                                                       .selectedReport?.lineData!
//                                                       .any((element) =>
//                                                           element.observation
//                                                               ?.toLowerCase()
//                                                               .toString() ==
//                                                           "no") ==
//                                                   true
//                                           ? (0.0).addHSpace()
//                                           : submitButton(controller, h, context)
//                                     ],
//                                   ),
//                                 ],
//                               ),

//                               (h * 0.05).addHSpace(),
//                             ],
//                           ),
//                         ),
//                       )),
//                   controller.createMiResponse.status == Status.LOADING ||
//                           controller.updateMiResponse.status == Status.LOADING
//                       ? Container(
//                           color: blackColor.withOpacity(0.2),
//                           child: Center(
//                             child: CircularProgressIndicator(color: blackColor),
//                           ),
//                         )
//                       : const SizedBox()
//                 ],
//               );
//             } else if (controller
//                     .getMaterialInspectionCheckListResponse.status ==
//                 Status.ERROR) {
//               return const Center(child: Text('Server Error'));
//             } else {
//               return const Center(child: Text('Something went wrong'));
//             }
//           }),
//         ),
//       ),
//     );
//   }

//   /// SAVE AS DRAFT

//   Widget saveAsDraftButton(double h,
//       MaterialInspectionScreenController controller, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: h * 0.025),
//       child: MaterialButton(
//         onPressed: () async {
//           await controller.createMaterialInspection(isDraft: "yes");
//         },
//         color: appColor,
//         height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Center(
//           child: AppString.saveAsDraft
//               .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
//         ),
//       ),
//     );
//   }

//   /// REJECT BUTTON

//   Widget rejectButton(MaterialInspectionScreenController controller, double h,
//       BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
//         child: MaterialButton(
//           onPressed: () async {
//             // await controller.rejectCheckListController();
//           },
//           color: redColor,
//           height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: Center(
//             child: AppString.reject
//                 .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
//           ),
//         ),
//       ),
//     );
//   }

//   commentRemarkField(double w, double h,
//       {required TextEditingController controller}) {
//     return TextFormField(
//       controller: controller,
//       style: textFieldTextStyle,
//       cursorWidth: 2,
//       minLines: 1,
//       maxLines: 5,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: containerColor,
//         hintText: AppString.writeHere,
//         hintStyle: textFieldHintTextStyle,
//         contentPadding:
//             EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: Colors.grey.shade600,
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ),
//     );
//   }

//   inputTextField(double w, double h,
//       {bool isReadOnly = false,
//       required TextEditingController controller,
//       String? validationText,
//       String? hintText,
//       String? title,
//       Widget? suffixIcon,
//       int? maxLine,
//       String? Function(String?)? validation,
//       VoidCallback? onTap}) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ((title ?? hintText) ?? "").semiBoldBarlowTextStyle(fontSize: 14),
//         (h * 0.008).addHSpace(),
//         TextFormField(
//           readOnly: isReadOnly,
//           controller: controller,
//           style: textFieldTextStyle,
//           cursorWidth: 2,
//           onTap: onTap,
//           validator: validation ??
//               (value) {
//                 if (value!.trim().isEmpty) {
//                   return validationText;
//                 }
//                 return null;
//               },
//           maxLines: maxLine ?? 1,
//           decoration: InputDecoration(
//             filled: true,
//             suffixIcon: suffixIcon,
//             fillColor: containerColor,
//             contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045)
//                 .copyWith(top: h * 0.03),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: Colors.red.shade600,
//               ),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget dropdownField(
//     double w,
//     double h, {
//     required String label,
//     required dynamic value,
//     required List<dynamic> items,
//     required ValueChanged<dynamic> onChanged,
//     required String Function(dynamic) displayText,
//     required String hintText,
//   }) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         label.semiBoldBarlowTextStyle(fontSize: 14),
//         (h * 0.008).addHSpace(),
//         DropdownSearch<dynamic>(
//           selectedItem: value,
//           items: items,
//           popupProps: PopupProps.menu(
//             showSearchBox: true,
//             searchFieldProps: TextFieldProps(
//               decoration: InputDecoration(
//                 hintText: 'Search...',
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             itemBuilder: (context, item, isSelected) => Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 displayText(item),
//                 style: textFieldTextStyle,
//               ),
//             ),
//           ),
//           dropdownBuilder: (context, selectedItem) => selectedItem != null
//               ? Text(
//                   displayText(selectedItem),
//                   style: textFieldTextStyle,
//                 )
//               : Text(
//                   hintText,
//                   style: textFieldTextStyle,
//                 ),
//           dropdownDecoratorProps: DropDownDecoratorProps(
//             dropdownSearchDecoration: InputDecoration(
//               hintText: hintText,
//               filled: true,
//               fillColor: containerColor,
//               contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045)
//                   .copyWith(top: h * 0.03),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: Colors.red.shade600,
//                 ),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ),
//           ),
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }

// /////dropdown
//   Widget _dropdownField(double w, double h,
//       {required String label,
//       required dynamic value,
//       required List<dynamic> items,
//       required ValueChanged<dynamic> onChanged,
//       String Function(dynamic)? displayText,
//       required String hintText}) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         label.semiBoldBarlowTextStyle(fontSize: 14),
//         (h * 0.008).addHSpace(),
//         DropdownButtonFormField<dynamic>(
//           value: value,
//           items: items.map((item) {
//             return DropdownMenuItem<dynamic>(
//               value: item,
//               child: Text(
//                   displayText != null ? displayText(item) : item.toString(),
//                   style: textFieldTextStyle),
//             );
//           }).toList(),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: containerColor,
//             contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045)
//                 .copyWith(top: h * 0.03),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: Colors.red.shade600,
//               ),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }

//   /// COMMENT TEXTFIELD

//   Widget commentTextField(MiChecklist data, double w, double h) {
//     return TextFormField(
//       controller: data.controller,
//       style: textFieldTextStyle,
//       cursorWidth: 2,
//       minLines: 2,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "Please Enter Details";
//         }
//         return null;
//       },
//       maxLines: 5,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: containerColor,
//         // hintText: AppString.writeHere,
//         // hintStyle: textFieldHintTextStyle,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         contentPadding:
//             EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: Colors.grey.shade600,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: Colors.red.shade600,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ),
//     );
//   }

//   /// COMMENT TEXT

//   Widget commentRemarkText(
//       MaterialInspectionScreenController controller, int index, double h) {
//     return Row(
//       children: [
//         AppString.cmtAndRemark.boldRobotoTextStyle(fontSize: 16),
//       ],
//     ).paddingOnly(bottom: h * 0.01);
//   }

//   Widget overAllRemark(TextEditingController controller, double w, double h) {
//     return TextFormField(
//       controller: controller,
//       style: textFieldTextStyle,
//       cursorWidth: 2,
//       minLines: 5,
//       maxLines: 5,
//       validator: (value) {
//         if (value!.trim().isEmpty) {
//           return "Please Enter Overall Remark";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: containerColor,
//         // hintText: AppString.writeHere,
//         // hintStyle: textFieldHintTextStyle,
//         contentPadding:
//             EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xffE6E6E6),
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: Colors.red.shade600,
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xffE6E6E6),
//           ),
//         ),
//       ),
//     );
//   }

//   /// SUBMIT BUTTON

//   Widget submitButton(MaterialInspectionScreenController controller, double h,
//       BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
//         child: MaterialButton(
//           onPressed: () async {
//             await controller.createMaterialInspection(isDraft: "no");
//           },
//           color: Colors.black,
//           height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: AppString.submit
//                 .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
//           ),
//         ),
//       ),
//     );
//   }

//   /// ALREADY SUBMITTED TEXT

//   Widget alreadySubmitted(double h, double w) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: h * 0.02),
//       margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.035),
//       decoration: const BoxDecoration(color: appColor),
//       alignment: Alignment.center,
//       child: Center(
//         child: AppString.submitted
//             .boldRobotoTextStyle(fontSize: 15, fontColor: backGroundColor),
//       ),
//     );
//   }

//   showImageDialog(double h, double w,
//       {required String image, bool? isNetwork = false}) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(15.0),
//             ),
//           ),
//           backgroundColor: Colors.white,
//           child: Container(
//             height: h * 0.52,
//             width: Responsive.isDesktop(context) ? w * 0.5 : w,
//             decoration: BoxDecoration(
//               border: Border.all(color: blackColor, width: 1.2),
//               borderRadius: BorderRadius.circular(15),
//               image: DecorationImage(
//                 image: isNetwork == true
//                     ? NetworkImage(image)
//                     : FileImage(File(image)) as ImageProvider,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             child: Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Container(
//                   height: h * 0.052,
//                   width: h * 0.052,
//                   margin: const EdgeInsets.all(10),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: blackColor),
//                   ),
//                   child: const Icon(Icons.close, color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// /// OVERALL IMAGE GRIDVIEW

// Widget overallImageGridView(MaterialInspectionScreenController controller,
//     double h, BuildContext context, double w) {
//   final data = controller.overAllImagesList ?? [];
//   return GridView.builder(
//     itemCount: controller.overAllImagesList?.length ?? 0,
//     physics: const NeverScrollableScrollPhysics(),
//     padding: const EdgeInsets.symmetric(horizontal: 2).copyWith(top: h * 0.015),
//     shrinkWrap: true,
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
//         crossAxisSpacing: w * 0.04,
//         mainAxisSpacing: h * 0.018,
//         childAspectRatio: 1.2),
//     itemBuilder: (context, index1) {
//       return Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: blackColor, width: 1.2),
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                   image: FileImage(
//                     File(controller.overAllImagesList?[index1] ?? ""),
//                   ) as ImageProvider,
//                   fit: BoxFit.fill),
//             ),
//           ),
//           Positioned(
//             bottom: 1,
//             left: 1.1,
//             right: 1.1,
//             child: GestureDetector(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return Dialog(
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(15.0),
//                         ),
//                       ),
//                       backgroundColor: Colors.white,
//                       child: Container(
//                         height: h * 0.52,
//                         width: Responsive.isDesktop(context) ? w * 0.5 : w,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: blackColor, width: 1.2),
//                           borderRadius: BorderRadius.circular(15),
//                           image: DecorationImage(
//                             image: FileImage(
//                               File(controller.overAllImagesList?[index1] ?? ""),
//                             ) as ImageProvider,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         child: Align(
//                           alignment: Alignment.topRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: Container(
//                               height: h * 0.052,
//                               width: h * 0.052,
//                               margin: const EdgeInsets.all(10),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: blackColor),
//                               ),
//                               child:
//                                   const Icon(Icons.close, color: Colors.black),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: appColor,
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(10),
//                     bottomLeft: Radius.circular(10),
//                   ),
//                 ),
//                 child: Icon(Icons.remove_red_eye,
//                     size: Responsive.isDesktop(context) ? h * 0.037 : h * 0.025,
//                     color: Colors.white),
//               ),
//             ),
//           ),

//           /// remove image

//           Positioned(
//             right: Responsive.isDesktop(context) ? -w * 0.010 : -w * 0.015,
//             top: -h * 0.008,
//             child: GestureDetector(
//               onTap: () {
//                 controller.removeOverallImage(
//                     index1, "CreateMaterialInspectionScreen");
//               },
//               child: Center(
//                   child: assetImage(AppAssets.closeIcon, height: h * 0.035)),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

// // VJ Material Inspection Screen ===========================================================


class CreateMaterialInspectionScreen extends StatefulWidget {
  const CreateMaterialInspectionScreen({super.key});

  @override
  State<CreateMaterialInspectionScreen> createState() => _CreateMaterialInspectionScreenState();
}

class _CreateMaterialInspectionScreenState extends State<CreateMaterialInspectionScreen> {
  MaterialInspectionScreenController materialInspectionScreenController = Get.find();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  @override
  void dispose() {
    materialInspectionScreenController.disposeForm();
    super.dispose();
  }

  loadData() async {
    await materialInspectionScreenController.getMaterialInspectionCheckPoints();
    materialInspectionScreenController.projectNameController.text = materialInspectionScreenController.projectName;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBarWidget(       backGroundColor:  const Color(0xFF3498DB),
title: AppString.materialInspectionReport.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white)),
        body: SafeArea(
          child: GetBuilder<MaterialInspectionScreenController>(builder: (controller) {
            if (controller.getMaterialInspectionCheckListResponse.status == Status.LOADING) {
              return showCircular();
            } else if (controller.getMaterialInspectionCheckListResponse.status == Status.COMPLETE) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (h * 0.01).addHSpace(),
                          controller.selectedReport != null
                              ? Padding(
                                  padding: EdgeInsets.only(top: h * 0.02),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: h * 0.035, horizontal: w * 0.05),
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      border: Border.all(
                                        color: const Color(0xffE6E6E6),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          "Sequence Number".toString().semiBoldBarlowTextStyle(fontSize: 18),
                                          SizedBox(width: w * 0.025),
                                          SizedBox(
                                            width: w * 0.34,
                                            //   color: Colors.red,
                                            child: controller.seqNo.semiBoldBarlowTextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),

                          (h * 0.02).addHSpace(),

                          inputTextField(w, h,
                              controller: controller.mirNoController,
                              hintText: "Enter MIR No",
                              validationText: 'Please Enter MIR No'),
                          (h * 0.02).addHSpace(),
                          inputTextField(w, h,
                              controller: controller.projectNameController,
                              hintText: "Enter Project Name",
                              validationText: "Please Enter Project Name"),
                          (h * 0.02).addHSpace(),
                          inputTextField(w, h,
                              controller: controller.companyNameController,
                              hintText: "Enter Company Name",
                              validationText: "Please Enter Company Name"),
                          (h * 0.02).addHSpace(),
                          inputTextField(w, h,
                              controller: controller.supplierNameController,
                              hintText: "Enter Supplier Name",
                              validationText: "Please Enter Supplier Name"),
                          (h * 0.02).addHSpace(),
                          inputTextField(
                            w,
                            h,
                            controller: controller.inspectionDateController,
                            hintText: "Enter Inspection Date",
                            isReadOnly: true,
                            validationText: "Please Enter Inspection Date",
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: blackColor,
                            ),
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                                initialDate: DateTime.now(),
                                currentDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: blackColor.withOpacity(0.9), // header background color
                                          onPrimary: Colors.white, // header text color
                                          onSurface: blackColor.withOpacity(0.9), // body text color
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black, // button text color
                                          ),
                                        ),
                                      ),
                                      child: child!);
                                },
                              );
                              if (selectedDate != null) {
                                controller.inspectionDate = selectedDate;
                              }

                              controller.inspectionDateController.text =
                                  DateFormat("dd-MM-yyyy").format(controller.inspectionDate);
                            },
                          ),
                          (h * 0.02).addHSpace(),
                          inputTextField(w, h,
                              controller: controller.materialDiscController,
                              maxLine: 1,
                              hintText: "Enter Material Description",
                              validationText: "Please Enter Material Description"),
                          (h * 0.02).addHSpace(),
                          inputTextField(w, h,
                              controller: controller.invoiceNoController,
                              hintText: "Enter Challan / Invoice No",
                              validationText: "Please Enter Challan / Invoice No"),
                          (h * 0.02).addHSpace(),
                          inputTextField(w, h,
                              controller: controller.quantityPerInvoiceController,
                              hintText: "Enter Quantity as per Challan",
                              validationText: "Please Enter Quantity as per Challan"),
                          (h * 0.02).addHSpace(),
                          inputTextField(w, h,
                              controller: controller.vehicleNoController,
                              hintText: "Enter Vehicle No.",
                              validationText: "Please Enter Vehicle No."),
                          (h * 0.02).addHSpace(),
                          inputTextField(
                            w,
                            h,
                            controller: controller.dateOfMaterialReciveController,
                            hintText: "Enter Date of Material Received",
                            isReadOnly: true,
                            validationText: "Please Enter Date of Material Received",
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: blackColor,
                            ),
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                                initialDate: DateTime.now(),
                                currentDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                            primary: blackColor.withOpacity(0.9),
                                            onPrimary: Colors.white,
                                            onSurface: blackColor.withOpacity(0.9)),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      child: child!);
                                },
                              );
                              if (selectedDate != null) {
                                controller.dateOfMaterialRecive = selectedDate;
                              }
                              controller.dateOfMaterialReciveController.text =
                                  DateFormat("dd-MM-yyyy").format(controller.dateOfMaterialRecive);
                            },
                          ),

                          (h * 0.02).addHSpace(),

                          inputTextField(w, h,
                              controller: controller.lotNoController,
                              hintText: "Enter Batch No/Week No/Lot No.",
                              validationText: "Please Enter Lot No."),
                          (h * 0.04).addHSpace(),

                          (controller.getMaterialInspectionCheckListResponseModel?.miChecklist?.isEmpty ?? false)
                              ? const SizedBox()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      (h * 0.02).addHSpace(),
                                      "ACTION".boldRobotoTextStyle(fontSize: 18).paddingOnly(bottom: h * 0.01),
                                      1.0.appDivider(color: Colors.grey),
                                      ListView.separated(
                                          itemBuilder: (context, index) {
                                            final data = controller
                                                .getMaterialInspectionCheckListResponseModel?.miChecklist?[index];
                                            return Container(
                                              padding: EdgeInsets.symmetric(vertical: h * 0.005, horizontal: w * 0.02),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: h * 0.012),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Icon(CupertinoIcons.arrow_right_square_fill)
                                                                .paddingOnly(top: h * 0.002),
                                                            (w * 0.01).addWSpace(),
                                                            Expanded(
                                                              child: "${data?.name}"
                                                                  .capitalizeFirst
                                                                  .toString()
                                                                  .regularBarlowTextStyle(
                                                                      fontSize: 16,
                                                                      maxLine: 10,
                                                                      textOverflow: TextOverflow.ellipsis),
                                                            ),
                                                          ],
                                                        ),
                                                        (w * 0.02).addWSpace(),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: w * 0.08,
                                                                    child: Radio(
                                                                      activeColor: appColor,
                                                                      value: "yes",
                                                                      groupValue: data?.isPass.toLowerCase(),
                                                                      onChanged: (value) {
                                                                        controller.changeDropDownValue(
                                                                            index, value.toString());
                                                                      },
                                                                    ),
                                                                  ),
                                                                  (w * 0.02).addWSpace(),
                                                                  const Text("Yes")
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: w * 0.08,
                                                                    child: Radio(
                                                                      activeColor: appColor,
                                                                      value: "no",
                                                                      groupValue: data?.isPass.toLowerCase(),
                                                                      onChanged: (value) {
                                                                        controller.changeDropDownValue(
                                                                            index, value.toString());
                                                                      },
                                                                    ),
                                                                  ),
                                                                  (w * 0.02).addWSpace(),
                                                                  const Text("No")
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: w * 0.08,
                                                                    child: Radio(
                                                                      activeColor: appColor,
                                                                      value: "na",
                                                                      groupValue: data?.isPass.toString(),
                                                                      onChanged: (value) {
                                                                        controller.changeDropDownValue(
                                                                          index,
                                                                          value.toString(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  (w * 0.02).addWSpace(),
                                                                  const Text("NA")
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  commentRemarkText(controller, index, h),
                                                  commentTextField(data!, w, h),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return 1.0.appDivider(color: Colors.grey);
                                          },
                                          padding: EdgeInsets.only(bottom: h * 0.02),
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller
                                                  .getMaterialInspectionCheckListResponseModel?.miChecklist?.length ??
                                              0),
                                    ],
                                  ),
                                ),
                          (h * 0.02).addHSpace(),

                          /// OVERALL REMARK TEXT

                          AppString.overAllRemark.boldRobotoTextStyle(fontSize: 18).paddingOnly(bottom: h * 0.01),

                          /// OVERALL REMARK TEXTFIELD
                          overAllRemark(controller.overAllRemarkController, w, h),

                          /// IMAGE SELECT
                          // inputTextField(
                          //   w,
                          //   h,
                          //   controller: TextEditingController(
                          //       text: controller.image.isEmpty ? "Select Image" : "Image Selected"),
                          //   isReadOnly: true,
                          //   validation: (p0) {
                          //     if (controller.image.isEmpty) {
                          //       return "Please Select Image";
                          //     }
                          //     return null;
                          //   },
                          //   suffixIcon: controller.image.isEmpty
                          //       ? IconButton(
                          //           onPressed: () async {
                          //             await controller.capturePhoto(context: context);
                          //           },
                          //           icon: Icon(
                          //             Icons.add_a_photo,
                          //             color: blackColor,
                          //           ))
                          //       : Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                 showImageDialog(h, w,
                          //                     image: controller.image, isNetwork: controller.image.contains("http://"));
                          //               },
                          //               child: Icon(
                          //                 Icons.visibility,
                          //                 color: blackColor,
                          //               ),
                          //             ),
                          //             (w * 0.02).addWSpace(),
                          //             GestureDetector(
                          //               onTap: () {
                          //                 controller.updateImage("");
                          //               },
                          //               child: Icon(
                          //                 Icons.close,
                          //                 color: blackColor,
                          //               ),
                          //             ),
                          //             (w * 0.02).addWSpace(),
                          //           ],
                          //         ),
                          // ),
                          // (h * 0.03).addHSpace(),

                          /// Overall Images
                          // if (controller.selectedReport?.imageUrlData!.isNotEmpty ?? false) ...[
                          (h * 0.02).addHSpace(),
                          AppString.overAllImage.boldRobotoTextStyle(fontSize: 18).paddingOnly(bottom: h * 0.01),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.blueGrey.shade100, borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// OVERALL IMAGE GRID VIEW

                                if (controller.overAllImagesList != null) ...[
                                  overallImageGridView(controller, h, context, w)
                                ],

                                /// CAPTURE IMAGE BUTTON
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: w * 0.18).copyWith(top: h * 0.03),
                                  child: MaterialButton(
                                    onPressed: () {
                                      controller.captureOverallImage(
                                          context: context, screen: "CreateMaterialInspectionScreen");
                                    },
                                    color: Colors.black,
                                    height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: w * 0.04),
                                          child: assetImage(AppAssets.cameraIcon, scale: 2),
                                        ),
                                        AppString.capturePhoto
                                            .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (h * 0.03).addHSpace(),
                          // ],

                          Column(
                            children: [
                              /// SAVE AS DRAFT
                              saveAsDraftButton(h, controller, context),

                              /// REJECT AND SUBMIT
                              Row(
                                children: [
                                  /// REJECT (SENT BACK)
                                  if (preferences.getString(SharedPreference.userType) != "maker") ...[
                                    rejectButton(controller, h, context),
                                    (w * 0.03).addWSpace()
                                  ],

                                  /// SUBMIT
                                  preferences.getString(SharedPreference.userType) == "maker" &&
                                          controller.selectedReport?.lineData!.any(
                                                  (element) => element.observation?.toLowerCase().toString() == "no") ==
                                              true
                                      ? (0.0).addHSpace()
                                      : submitButton(controller, h, context)
                                ],
                              ),
                            ],
                          ),

                          (h * 0.05).addHSpace(),
                        ],
                      ),
                    ),
                  ),
                  controller.createMiResponse.status == Status.LOADING ||
                          controller.updateMiResponse.status == Status.LOADING
                      ? Container(
                          color: blackColor.withOpacity(0.2),
                          child: Center(
                            child: CircularProgressIndicator(color: blackColor),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            } else if (controller.getMaterialInspectionCheckListResponse.status == Status.ERROR) {
              return const Center(child: Text('Server Error'));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          }),
        ),
      ),
    );
  }

  /// SAVE AS DRAFT

  Widget saveAsDraftButton(double h, MaterialInspectionScreenController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: h * 0.025),
      child: MaterialButton(
        onPressed: () async {
          await controller.createMaterialInspection(isDraft: "yes");
        },
        color: appColor,
        height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: AppString.saveAsDraft.boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
        ),
      ),
    );
  }

  /// REJECT BUTTON

  Widget rejectButton(MaterialInspectionScreenController controller, double h, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
        child: MaterialButton(
          onPressed: () async {
            // await controller.rejectCheckListController();
          },
          color: redColor,
          height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: AppString.reject.boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
          ),
        ),
      ),
    );
  }

  commentRemarkField(double w, double h, {required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      style: textFieldTextStyle,
      cursorWidth: 2,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        filled: true,
        fillColor: containerColor,
        hintText: AppString.writeHere,
        hintStyle: textFieldHintTextStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade600,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  inputTextField(double w, double h,
      {bool isReadOnly = false,
      required TextEditingController controller,
      String? validationText,
      String? hintText,
      String? title,
      Widget? suffixIcon,
      int? maxLine,
      String? Function(String?)? validation,
      VoidCallback? onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ((title ?? hintText) ?? "").semiBoldBarlowTextStyle(fontSize: 14),
        (h * 0.008).addHSpace(),
        TextFormField(
          readOnly: isReadOnly,
          controller: controller,
          style: textFieldTextStyle,
          cursorWidth: 2,
          onTap: onTap,
          validator: validation ??
              (value) {
                if (value!.trim().isEmpty) {
                  return validationText;
                }
                return null;
              },
          maxLines: maxLine ?? 1,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: suffixIcon,
            fillColor: containerColor,
            // hintText: isReadOnly ? "" : hintText ?? AppString.writeHere,
            // hintStyle: textFieldHintTextStyle,
            contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade600,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red.shade600,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// COMMENT TEXTFIELD

  Widget commentTextField(MiChecklist data, double w, double h) {
    return TextFormField(
      controller: data.controller,
      style: textFieldTextStyle,
      cursorWidth: 2,
      minLines: 2,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Details";
        }
        return null;
      },
      maxLines: 5,
      decoration: InputDecoration(
        filled: true,
        fillColor: containerColor,
        // hintText: AppString.writeHere,
        // hintStyle: textFieldHintTextStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade600,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red.shade600,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  /// COMMENT TEXT

  Widget commentRemarkText(MaterialInspectionScreenController controller, int index, double h) {
    return Row(
      children: [
        AppString.cmtAndRemark.boldRobotoTextStyle(fontSize: 16),
      ],
    ).paddingOnly(bottom: h * 0.01);
  }

  Widget overAllRemark(TextEditingController controller, double w, double h) {
    return TextFormField(
      controller: controller,
      style: textFieldTextStyle,
      cursorWidth: 2,
      minLines: 5,
      maxLines: 5,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "Please Enter Overall Remark";
        }
        return null;
      },

      decoration: InputDecoration(
        filled: true,
        fillColor: containerColor,
        // hintText: AppString.writeHere,
        // hintStyle: textFieldHintTextStyle,

      hintText: "Write here..",
      hintStyle: textFieldHintTextStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE6E6E6),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red.shade600,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE6E6E6),
          ),
        ),
      ),
    );
  }

  /// SUBMIT BUTTON

  Widget submitButton(MaterialInspectionScreenController controller, double h, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
        child: MaterialButton(
          onPressed: () async {
            await controller.createMaterialInspection(isDraft: "no");
          },
          color: Colors.black,
          height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: AppString.submit.boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
          ),
        ),
      ),
    );
  }

  /// ALREADY SUBMITTED TEXT

  Widget alreadySubmitted(double h, double w) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: h * 0.02),
      margin: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.035),
      decoration: const BoxDecoration(color: appColor),
      alignment: Alignment.center,
      child: Center(
        child: AppString.submitted.boldRobotoTextStyle(fontSize: 15, fontColor: backGroundColor),
      ),
    );
  }

  showImageDialog(double h, double w, {required String image, bool? isNetwork = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          backgroundColor: Colors.white,
          child: Container(
            height: h * 0.52,
            width: Responsive.isDesktop(context) ? w * 0.5 : w,
            decoration: BoxDecoration(
              border: Border.all(color: blackColor, width: 1.2),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: isNetwork == true ? NetworkImage(image) : FileImage(File(image)) as ImageProvider,
                fit: BoxFit.fill,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: h * 0.052,
                  width: h * 0.052,
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: blackColor),
                  ),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// OVERALL IMAGE GRIDVIEW

Widget overallImageGridView(MaterialInspectionScreenController controller, double h, BuildContext context, double w) {
  final data = controller.overAllImagesList ?? [];
  return GridView.builder(
    itemCount: controller.overAllImagesList?.length ?? 0,
    // (controller.isNetwork.isNotEmpty &&
    //         controller.savedLineData.isNotEmpty)
    //     ? data?.imageData.length
    //     : data?.imageList.length,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 2).copyWith(top: h * 0.015),
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
        crossAxisSpacing: w * 0.04,
        mainAxisSpacing: h * 0.018,
        childAspectRatio: 1.2),
    itemBuilder: (context, index1) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: blackColor, width: 1.2),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: FileImage(
                    File(controller.overAllImagesList?[index1] ?? ""),
                  ) as ImageProvider,
                  fit: BoxFit.fill),
            ),
          ),
          Positioned(
            bottom: 1,
            left: 1.1,
            right: 1.1,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      child: Container(
                        height: h * 0.52,
                        width: Responsive.isDesktop(context) ? w * 0.5 : w,
                        decoration: BoxDecoration(
                          border: Border.all(color: blackColor, width: 1.2),
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: FileImage(
                              File(controller.overAllImagesList?[index1] ?? ""),
                            ) as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: h * 0.052,
                              width: h * 0.052,
                              margin: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: blackColor),
                              ),
                              child: const Icon(Icons.close, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Icon(Icons.remove_red_eye,
                    size: Responsive.isDesktop(context) ? h * 0.037 : h * 0.025, color: Colors.white),
              ),
            ),
          ),

          /// remove image

          Positioned(
            right: Responsive.isDesktop(context) ? -w * 0.010 : -w * 0.015,
            top: -h * 0.008,
            child: GestureDetector(
              onTap: () {
                controller.removeOverallImage(index1, "CreateMaterialInspectionScreen");
              },
              child: Center(child: assetImage(AppAssets.closeIcon, height: h * 0.035)),
            ),
          ),
        ],
      );
    },
  );
}

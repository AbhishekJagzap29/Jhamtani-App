//Updated Code 22/12
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_close_state_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/nc_routing_through_notification_res_model.dart';
import 'package:jhamtani_app/Api/Services/base_service.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_details_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/nc_image_capture_screen.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_painter/image_painter.dart';


import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


import '../../../../../Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';

class GenerateNcCompleteDetailsScreen extends StatefulWidget {
  final String? projectId;
  final String? towerId;
  final String? floorId;
  final String? flatId;
  final String? projectResponsible;
  final String? flagCategory;
  final String? activityId;
  final String? activityTypeId;
  final String? checklistLineId;
  final String? initialDescription;
  final List<dynamic>? rectifiedImage;
  final DateTime? projectCreateDate;
  int? ncId;
  final String? customChecklistItem;
  final String? overallRemarks;
  final List<dynamic>? closeImage;
  final List<dynamic>? images;
  final String? ncStatus; // <-- backend status
  final String? approverRemark;
  //11/12
  final List<dynamic>? approverImages;

  GenerateNcCompleteDetailsScreen({
    super.key,
    this.projectId,
    this.towerId,
    this.floorId,
    this.flatId,
    this.flagCategory,
    this.activityId,
    this.activityTypeId,
    this.checklistLineId,
    this.initialDescription,
    this.rectifiedImage,
    this.projectCreateDate,
    this.ncId,
    this.projectResponsible,
    this.customChecklistItem,
    this.overallRemarks,
    this.closeImage,
    this.images,
    this.ncStatus, // <-- backend status
    this.approverRemark,
    this.approverImages,
  });

  @override
  State<GenerateNcCompleteDetailsScreen> createState() =>
      _GenerateNcCompleteDetailsScreenState();
}

class _GenerateNcCompleteDetailsScreenState
    extends State<GenerateNcCompleteDetailsScreen> {
  //06/12
  NcRoutingThroughNotificationModel? routedData;
  bool fromNotification = false;

  String state = "open";
  bool isFormSubmitted = false;
  bool isLoading = false;
  String? userType; //27/11
  List<File> closeImages = [];
  String? overallRemark;
  String? _approverRemark;
  int? mergedNcId;
  List<File> approverImages = [];

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _approverRemarkController =
      TextEditingController(); //27/11
  final ImagePicker _picker = ImagePicker();
  int? ncId;

  @override
  void initState() {
    super.initState();
    var args = Get.arguments;
    if (args != null && args["screen"] == "notification") {
      fromNotification = true;
      routedData = args["ncRoutingData"];
    }
    mergedNcId = fromNotification ? routedData?.ncId : widget.ncId;

    if (fromNotification && routedData != null) {
      _approverRemark = routedData!.approverRemark;
    }
    _loadState();
    _loadUserRole();
    overallRemark = widget.overallRemarks;

    //  Pre-fill Maker images when NC is rejected
    if (fromNotification &&
        routedData?.status == "approver_reject" &&
        routedData?.closeImage != null) {
      // DO NOT overwrite existing picked images
      closeImages = [];
    }
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString(SharedPreference.userType);
    print("Loaded User Type => $userType");
    setState(() {});
  }

  Future<void> _loadState() async {
    if (widget.ncId == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String status = widget.ncStatus?.toLowerCase() ?? "open";

// backend decides form mode
      if (status == "close") {
        isFormSubmitted = true;
        state = "done";
      } else {
        isFormSubmitted = false;
        state = "open";
      }
    });

    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/close_image_${widget.ncId}.png';
    final File imageFile = File(path);
    if (await imageFile.exists()) {
      setState(() {
        closeImages = [imageFile];
      });
    }

    final savedRemark = prefs.getString('overall_remarks_${widget.ncId}');
    if (savedRemark != null && savedRemark.isNotEmpty) {
      setState(() {
        overallRemark = savedRemark;
      });
    }
  }

  Future<void> _saveState(String newState) async {
    if (widget.ncId == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nc_state_${widget.ncId}', newState);
  }

  void _showSnackbar(String message, {bool isSuccess = true}) {
    if (isSuccess) {
      successSnackBar("Success", message);
    } else {
      errorSnackBar("Error", message);
    }
  }

  //02/01/26
  Future<Uint8List> _compressImage(File file) async {
    return await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          quality: 60, //  reduce size
          minWidth: 1280,
          minHeight: 1280,
        ) ??
        await file.readAsBytes();
  }

//==============================
//08/01/26
  String buildImageUrl(String base, String path) {
    if (base.endsWith('/') && path.startsWith('/')) {
      return base + path.substring(1);
    }
    return base + path;
  }
//====================

  Future<void> _handleApproveReject(String action) async {
    if (_approverRemarkController.text.isEmpty) {
      _showSnackbar("Approver remarks required.", isSuccess: false);
      return;
    }
    //16/12
    if (approverImages.isEmpty) {
      _showSnackbar("Approver image is required.", isSuccess: false);
      return;
    }
    //==================
    setState(() {
      isLoading = true;
    });
    try {
      List<Map<String, dynamic>> encodedImages = [];
      for (File img in approverImages) {
        // Uint8List bytes = await img.readAsBytes();
        //03/01/26
        Uint8List bytes = await _compressImage(img);

        ///
        encodedImages.add({
          "approver_image": "data:image/jpeg;base64,${base64Encode(bytes)}",
        });
      }

      Map<String, dynamic> body = {
        "nc_id": mergedNcId,
        "approver_remark": _approverRemarkController.text,
        "close_images": encodedImages, // REQUIRED BY BACKEND
        "action": action,
      };

      var response = await ProjectRepo().approverRejectNcRepo(map: body);
      // if (response.status == "success") {

      if (response != null && response.status == "success") {
        if (response != null && response.status == "success") {
          _showSnackbar("NC $action successfully!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GenerateNcDetailsScreen(),
            ),
          );

          dynamic refreshed;
          if (fromNotification) {
            var res = await ProjectRepo()
                .getNotificationRoutingForNc(map: {"nc_id": mergedNcId});
            if (res != null && res.status == "success") {
              refreshed = res.nc;
              Navigator.pop(context, {
                "updatedApproverRemark": refreshed.approverRemark,
              });
              return;
            }
          } else {
            FetchAllNcDataResponseModel updatedList =
                await ProjectRepo().ncfetchalldataRepo(forceRefresh: true);
            refreshed = updatedList.fetchNcData.firstWhere(
              (e) => e.ncId == mergedNcId,
              orElse: () => FetchNcData(),
            );
          }
        }
      } else {
        _showSnackbar(response.message ?? "Failed", isSuccess: false);
      }
    } catch (e) {
      _showSnackbar("Error: $e", isSuccess: false);
    }
    //13/12
    finally {
      setState(() {
        isLoading = false; //
      });
    }
  }

  Future<void> _handleApproverClose() async {
    if (_approverRemarkController.text.isEmpty) {
      _showSnackbar("Approver remarks is required.", isSuccess: false);
      return;
    }
    //02/01/26
    // if (approverImages.isEmpty) {
    //   _showSnackbar("Approver image is required.", isSuccess: false);
    //   return;
    // }
    //==================

    setState(() {
      isLoading = true;
    });

    try {
      // STEP 1: Convert approver images to base64
      List<String> encodedImages = [];

      for (File img in approverImages) {
        // Uint8List bytes = await img.readAsBytes();
        //03/01/26
        Uint8List bytes = await _compressImage(img);
////
        encodedImages.add(
          "data:image/jpeg;base64,${base64Encode(bytes)}",
        );
      }

      // STEP 2: Prepare request body
      Map<String, dynamic> body = {
        "nc_id": mergedNcId,
        "approver_remark": _approverRemarkController.text,
        // "approver_image": encodedImages,
        //15/12
        "approver_close_images": encodedImages,
      };

      //  STEP 3: Call API
      var response = await ProjectRepo().approverCloseNcRepo(map: body);

      if (response != null && response.status == "success") {
        _showSnackbar("NC closed successfully!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GenerateNcDetailsScreen(),
          ),
        );

        if (fromNotification) {
          var res = await ProjectRepo()
              .getNotificationRoutingForNc(map: {"nc_id": mergedNcId});
          if (res != null && res.status == "success") {
            Navigator.pop(context, {
              "updatedApproverRemark": res.nc?.approverRemark,
            });
          }
        }
      } else {
        _showSnackbar("Failed to close NC", isSuccess: false);
      }
    } catch (e) {
      _showSnackbar("Error: $e", isSuccess: false);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (overallRemark == null || overallRemark!.isEmpty) {
      _showSnackbar("Maker Remark is required.", isSuccess: false);
      return;
    }
    if (closeImages.isEmpty) {
      _showSnackbar("Maker image is required.", isSuccess: false);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      List<String> encodedImages = [];
      for (File img in closeImages) {
        // Uint8List bytes = await img.readAsBytes();
        // encodedImages.add("data:image/jpeg;base64,${base64Encode(bytes)}");
        //02/01/26
        Uint8List bytes = await _compressImage(img);
        encodedImages.add("data:image/jpeg;base64,${base64Encode(bytes)}");
      }
      Map<String, dynamic> body = {
        // 'nc_id': widget.ncId,
        //08/12
        'nc_id': mergedNcId,
        'status': state,
        'overall_remarks': overallRemark,
        'image': encodedImages,
      };
      var response =
          await ProjectRepo().closencstateRepo(mergedNcId!, map: body);
      if (response is GenerateNcCloseStateResponseModel) {
        if (response.status == 'success') {
          _showSnackbar("NC closed successfully!");
          setState(() {
            state = "done";
            isFormSubmitted = true;
            isLoading = false;
          });
          _saveState("done");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              //'overall_remarks_${widget.ncId}', overallRemark!);
              //08/12
              'overall_remarks_$mergedNcId',
              overallRemark!);
          FetchAllNcDataResponseModel updatedNcList;
          try {
            updatedNcList =
                await ProjectRepo().ncfetchalldataRepo(forceRefresh: true);
          } catch (e) {
            updatedNcList = await ProjectRepo().ncfetchalldataRepo();
          }
          // Find the NC that was just updated
          var updatedNc = updatedNcList.fetchNcData.firstWhere(
              (e) => e.ncId == mergedNcId,
              orElse: () => FetchNcData());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const GenerateNcDetailsScreen(
          //       fromMaker: true,
          //     ),
          //   ),
          // );
          //05/01/26Morning
          if (!mounted) return;
          Navigator.pop(context, {"refresh": true});
//=========================
        } else {
          setState(() {
            isLoading = false;
          });
          _showSnackbar(response.message ?? "Failed to submit form.",
              isSuccess: false);
        }
      } else {
        // If API returned non-standard response but request still succeeded
        _showSnackbar("NC closed successfully!");
        setState(() {
          state = "done";
          isFormSubmitted = true;
          isLoading = false;
        });
        _saveState("done");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('overall_remarks_${widget.ncId}', overallRemark!);
        //08/12
        await prefs.setString('overall_remarks_$mergedNcId', overallRemark!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GenerateNcDetailsScreen(),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error in _submitForm: $e");
      if (e.toString().contains('Connection closed while receiving data') ||
          e.toString().contains('ClientException')) {
        _showSnackbar("NC closed successfully!");
        setState(() {
          state = "done";
          isFormSubmitted = true;
          isLoading = false;
        });
        _saveState("done");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('overall_remarks_$mergedNcId', overallRemark!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GenerateNcDetailsScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        _showSnackbar("Failed to submit form: ${e.toString()}",
            isSuccess: false);
      }
    }
  }

  void _toggleState() {
    if (state == "done") {
      _showSnackbar("Cannot change state after submission.", isSuccess: false);
      return;
    }

    setState(() {
      if (state == "open") {
        state = "close";
      } else if (state == "close") {
        state = "open";
      }
    });
    _saveState(state);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    //06/12
    final String? mergedStatus =
        fromNotification ? routedData?.status : widget.ncStatus;

    final List<dynamic>? mergedCloseImages =
        fromNotification ? routedData?.closeImage : widget.closeImage;

    final String? mergedOverallRemarks =
        fromNotification ? routedData?.overallRemarks : widget.overallRemarks;

    final String? mergedApproverRemark =
        fromNotification ? routedData?.approverRemark : widget.approverRemark;

    String backendStatus = mergedStatus?.toLowerCase() ?? "";
    //11/12

    List<dynamic> mergedApproverImages = [];

    if (fromNotification) {
      mergedApproverImages = routedData?.approverImages ?? [];
    } else {
      mergedApproverImages = widget.approverImages ?? [];
    }

    bool isMaker = userType?.toLowerCase() == "maker";

    bool backendClosed = backendStatus == "close";

    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
             backGroundColor: const Color(0xFF3498DB),
          title: Text(
  widget.flagCategory ?? '',
  style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  "Date",
                  fromNotification
                      ? (routedData?.projectCreateDate != null &&
                              routedData!.projectCreateDate.isNotEmpty
                          ? _formatDate(DateTime.tryParse(
                                  routedData!.projectCreateDate) ??
                              DateTime.now())
                          : "Not Provided")
                      : (widget.projectCreateDate != null
                          ? _formatDate(widget.projectCreateDate!)
                          : "Not Provided"),
                ),

                _buildDetailRow(
                  "Flag Category",
                  fromNotification
                      ? routedData?.flagCategory
                      : widget.flagCategory,
                ),

                _buildDetailRow(
                  "Project Responsible",
                  fromNotification
                      ? routedData?.projectResponsible
                      : widget.projectResponsible,
                ),

                _buildDetailRow(
                  "Project Name",
                  fromNotification
                      ? routedData?.projectInfoName
                      : widget.projectId,
                ),

                _buildDetailRow(
                  "Tower Name",
                  fromNotification
                      ? routedData?.projectTowerName
                      : widget.towerId,
                ),

                _buildDetailRow(
                  "Floor",
                  fromNotification
                      ? (routedData?.projectFloorName?.isNotEmpty == true
                          ? routedData?.projectFloorName
                          : "No Floor Data")
                      : (widget.floorId ?? "No Floor Data"),
                ),

                _buildDetailRow(
                  "Flat",
                  fromNotification
                      ? (routedData?.projectFlatsName?.isNotEmpty == true
                          ? routedData?.projectFlatsName
                          : "No Flat Data")
                      : (widget.flatId ?? "No Flat Data"),
                ),

                _buildDetailRow(
                  "Activity",
                  fromNotification
                      ? routedData?.projectActivityName
                      : widget.activityId,
                ),

                _buildDetailRow(
                  "Activity Type",
                  fromNotification
                      ? routedData?.projectActTypeName
                      : widget.activityTypeId,
                ),

                _buildDetailRow(
                  "Checklist Line",
                  fromNotification
                      ? routedData?.projectCheckLineName
                      : widget.checklistLineId,
                ),

                _buildDetailRow(
                  "Custom Checklist",
                  fromNotification
                      ? (routedData?.customChecklistItem?.isNotEmpty == true
                          ? routedData?.customChecklistItem
                          : "Not Provided")
                      : (widget.customChecklistItem ?? "Not Provided"),
                ),

                _buildDetailRow(
                  "Checker/Approver Remarks",
                  // AppString.checkerApproverRemarks,
                  fromNotification
                      ? (routedData?.description?.isNotEmpty == true
                          ? routedData?.description
                          : "Not Provided")
                      : (widget.initialDescription ?? "Not Provided"),
                ),

                (fromNotification
                        ? (routedData?.rectifiedImage != null &&
                            routedData!.rectifiedImage.isNotEmpty)
                        : (widget.rectifiedImage != null &&
                            widget.rectifiedImage!.isNotEmpty))
                    ? _buildRectifiedImages(fromNotification
                        ? routedData!.rectifiedImage
                        : widget.rectifiedImage!)
                    : _buildDetailRow("Image", null),

                //  SHOW previous Maker images when NC is rejected by Approver
                if (isMaker &&
                    backendStatus == "approver_reject" &&
                    mergedCloseImages != null &&
                    mergedCloseImages.isNotEmpty)
                  _buildBackendCloseImages(mergedCloseImages),

                // MAKER editable UI for open OR approver_reject
                if (isMaker &&
                    (backendStatus == "open" ||
                        backendStatus == "approver_reject")) ...[
                  // Maker can add remark images
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Maker Remarks",
                      // labelText: AppString.makerRemarks,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => overallRemark = value,
                  ),

                  const SizedBox(height: 20),
                  //Maker
                  NcImageCaptureWidget(
                    // title: "Rectified Images",
                    //17/12
                    title: "Maker Images",
                    // title: AppString.makerImages,
                    initialImages: closeImages,
                    onImagesUpdated: (updatedList) {
                      setState(() {
                        closeImages = updatedList;
                      });
                    },
                  ),
                ] else if (backendStatus == "close") ...[
                  // CLOSED VIEW ONLY

                  if (mergedCloseImages != null &&
                      mergedCloseImages!.isNotEmpty)
                    _buildBackendCloseImages(mergedCloseImages!),

                  if (mergedOverallRemarks != null &&
                      mergedOverallRemarks!.isNotEmpty)
                    _buildDetailRow(
                        "Maker Remarks",
                        // AppString.makerRemarks,
                        mergedOverallRemarks)
                ] else if (backendStatus == "submit") ...[
                  // MAKER cannot edit after submit
                  _buildDetailRow(
                      "Maker Remarks",
                      //  AppString.makerRemarks,
                      mergedOverallRemarks),

                  if (mergedCloseImages != null &&
                      mergedCloseImages!.isNotEmpty)
                    _buildBackendCloseImages(mergedCloseImages!),
                ],

                if ((mergedApproverRemark ?? _approverRemark)?.isNotEmpty ==
                    true)
                  _buildDetailRow(
                      "Approver Remarks",
                      // AppString.approverRemarks,
                      mergedApproverRemark ?? _approverRemark),

                if (mergedApproverImages.isNotEmpty)
                  _buildApproverImages(mergedApproverImages),

                if (userType?.toLowerCase() == "approver" &&
                    backendStatus == "submit") ...[
                  const SizedBox(height: 20),
                  TextField(
                    controller: _approverRemarkController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Approver Remarks",
                      //labelText: AppString.approverRemarks,
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),
                  ////Approver Image////
                  NcImageCaptureWidget(
                    title: "Approver Images",
                    //title: AppString.approverImages,
                    initialImages: approverImages,
                    onImagesUpdated: (updatedList) {
                      setState(() {
                        approverImages = updatedList;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleApproverClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Close"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleApproveReject("rejected"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Reject"),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          floatingActionButton: () {
            if (!isMaker) return null;

            if (backendStatus == "close") return null;
            if (backendStatus == "submit") return null;
            if (backendStatus == "open" || backendStatus == "approver_reject") {
              return FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(Icons.done),
                onPressed: () {
                  state = "close";
                  _submitForm();
                },
              );
            }
            return null;
          }(),
        ),
        if (isLoading)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 3,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Widget _buildBackendCloseImages(List<dynamic> closeImages) {
  //   // const String baseUrl = "http://157.245.102.113:8069";
  //   const String baseUrl = "http://159.65.147.103:8069";

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text("Maker Images",
  //           // AppString.makerImages,
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //       SizedBox(height: 10),
  //       Wrap(
  //         spacing: 12,
  //         runSpacing: 12,
  //         children: closeImages.map((img) {
  //           // CASE A: img is a Map and contains 'url' key (your terminal shows this)
  //           if (img is Map && img.containsKey("url")) {
  //             final urlPath = (img["url"] ?? '').toString();
  //             final fullUrl =
  //                 urlPath.startsWith("http") ? urlPath : "$baseUrl$urlPath";
  //             return _imageBox(fullUrl);
  //           }

  //           // CASE B: img is a String and starts with "/web/" or "http"
  //           if (img is String) {
  //             final s = img;
  //             if (s.startsWith("/web/")) {
  //               final fullUrl = "$baseUrl$s";
  //               return _imageBox(fullUrl);
  //             } else if (s.startsWith("http")) {
  //               return _imageBox(s);
  //             } else if (s.startsWith("data:image")) {
  //               try {
  //                 final base64Str = s.split(",").last;
  //                 final bytes = base64Decode(base64Str);
  //                 return _base64Box(bytes);
  //               } catch (e) {
  //                 return _invalidBox();
  //               }
  //             }
  //           }

  //           // Fallback: unknown format
  //           return _invalidBox();
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }
  
  Widget _buildBackendCloseImages(List<dynamic> closeImages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Maker Images",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: closeImages.map((img) {
            // CASE A: img is a Map and contains 'url'
            if (img is Map && img.containsKey("url")) {
              final urlPath = (img["url"] ?? '').toString();

              final fullUrl = urlPath.startsWith('http')
                  ? urlPath
                  : buildImageUrl(ApiRouts.base, urlPath);

              ///=================
              return _imageBox(fullUrl);
            }

            // CASE B: img is a String
            if (img is String) {
              final s = img;
              if (s.startsWith("/web/")) {
                final fullUrl = "${ApiRouts.base}$s";
                return _imageBox(fullUrl);
              } else if (s.startsWith("http")) {
                return _imageBox(s);
              } else if (s.startsWith("data:image")) {
                try {
                  final base64Str = s.split(",").last;
                  final bytes = base64Decode(base64Str);
                  return _base64Box(bytes);
                } catch (e) {
                  return _invalidBox();
                }
              }
            }

            // Fallback
            return _invalidBox();
          }).toList(),
        ),
      ],
    );
  }
/////==================

  Widget _imageBox(String fullUrl) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              InteractiveViewer(
                child: Center(
                  child: Image.network(
                    fullUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
              //21/02/26
              //  DOWNLOAD BUTTON (ADD THIS)
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _downloadNetworkImage(fullUrl);
                  },
                ),
              ),
              //========================

              //  CLOSE ICON (TOP RIGHT)
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(fullUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _base64Box(Uint8List imgBytes) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: MemoryImage(imgBytes),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _invalidBox() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image)),
    );
  }

//Checker image
  Widget _buildDetailRow(String label, String? value) {
    if (label == "Image" && value != null && value.isNotEmpty) {
      try {
        Uint8List decodedImage = base64Decode(value);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4.0),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    decodedImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      } catch (e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            "No image.",
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        );
      }
    } else if (label == "Maker Images"
        //AppString.makerImages
        &&
        value != null &&
        value.isNotEmpty) {
      try {
        Uint8List decodedImage = base64Decode(value);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4.0),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    decodedImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      } catch (e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            "Failed to load Maker images.",
            style: TextStyle(color: Colors.red, fontSize: 16.0),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            width: double.infinity,
            child: TextFormField(
              initialValue: value ?? "Not Provided",
              enabled: false,
              maxLines: null,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                hintText: "$label not available",
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRectifiedImages(List<dynamic> rectifiedImages) {
  //   //const String baseUrl = "http://157.245.102.113:8069";
  //   const String baseUrl = "http://159.65.147.103:8069";
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 12.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           //"Images",
  //           //17/12
  //           "Checker/Approver Images",
  //           // AppString.checkerApproverImages,
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 18.0,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: rectifiedImages.map((img) {
  //             final map = img as Map<String, dynamic>;
  //             final urlPath = (map['url'] ?? '').toString();
  //             final fullUrl =
  //                 urlPath.startsWith('http') ? urlPath : '$baseUrl$urlPath';

  //             return GestureDetector(
  //               onTap: () {
  //                 showDialog(
  //                   context: context,
  //                   builder: (_) => Dialog(
  //                     insetPadding: EdgeInsets.zero,
  //                     backgroundColor: Colors.black,
  //                     child: Stack(
  //                       children: [
  //                         InteractiveViewer(
  //                           child: Center(
  //                             child: Image.network(
  //                               fullUrl,
  //                               fit: BoxFit.contain,
  //                               loadingBuilder: (context, child, progress) {
  //                                 if (progress == null) return child;
  //                                 return const Center(
  //                                   child: CircularProgressIndicator(
  //                                       color: Colors.white),
  //                                 );
  //                               },
  //                               errorBuilder: (_, __, ___) => const Center(
  //                                 child: Icon(Icons.broken_image,
  //                                     color: Colors.white, size: 60),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Positioned(
  //                           top: 40,
  //                           right: 20,
  //                           child: IconButton(
  //                             icon: const Icon(Icons.close,
  //                                 color: Colors.white, size: 30),
  //                             onPressed: () => Navigator.pop(context),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 child: Image.network(
  //                   fullUrl,
  //                   height: 120,
  //                   width: 120,
  //                   fit: BoxFit.cover,
  //                   errorBuilder: (context, error, stackTrace) => Container(
  //                     height: 120,
  //                     width: 120,
  //                     color: Colors.grey[300],
  //                     child: const Icon(Icons.broken_image, color: Colors.grey),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  ///08/01/26 baseurl import to fetch img from server
  Widget _buildRectifiedImages(List<dynamic> rectifiedImages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Checker/Approver Images",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: rectifiedImages.map((img) {
              final map = img as Map<String, dynamic>;
              final urlPath = (map['url'] ?? '').toString();
              //08/01/26
              final fullUrl = urlPath.startsWith('http')
                  ? urlPath
                  : buildImageUrl(ApiRouts.base, urlPath);
//=================

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: Colors.black,
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: Center(
                              child: Image.network(
                                fullUrl,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  );
                                },
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.white, size: 60),
                                ),
                              ),
                            ),
                          ),

                          ///26
                          //  DOWNLOAD BUTTON (ADD THIS)

                          Positioned(
                            top: 40,
                            left: 20,
                            child: IconButton(
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                _downloadNetworkImage(fullUrl);
                              },
                            ),
                          ),

                          ///========================
                          Positioned(
                            top: 40,
                            right: 20,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    fullUrl,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  //Approver images updated 17/12 add close icon when view approver added image
  // Widget _buildApproverImages(List<dynamic> images) {
  //   // const String baseUrl = "http://157.245.102.113:8069";
  //   const String baseUrl = "http://159.65.147.103:8069";

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Approver Images",
  //         // AppString.approverImages,
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 18,
  //           color: Colors.black87,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Wrap(
  //         spacing: 10,
  //         children: images.map((img) {
  //           if (img is Map && img.containsKey("url")) {
  //             final urlPath = img["url"];
  //             final fullUrl =
  //                 urlPath.startsWith("http") ? urlPath : "$baseUrl$urlPath";

  //             return GestureDetector(
  //               onTap: () {
  //                 showDialog(
  //                   context: context,
  //                   builder: (_) => Dialog(
  //                     backgroundColor: Colors.black,
  //                     insetPadding: EdgeInsets.zero,
  //                     child: Stack(
  //                       children: [
  //                         InteractiveViewer(
  //                           child: Center(
  //                             child: Image.network(
  //                               fullUrl,
  //                               fit: BoxFit.contain,
  //                             ),
  //                           ),
  //                         ),

  //                         //  CLOSE ICON
  //                         Positioned(
  //                           top: 40,
  //                           right: 20,
  //                           child: IconButton(
  //                             icon: const Icon(
  //                               Icons.close,
  //                               color: Colors.white,
  //                               size: 30,
  //                             ),
  //                             onPressed: () => Navigator.pop(context),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 width: 120,
  //                 height: 120,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   image: DecorationImage(
  //                     image: NetworkImage(fullUrl),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }

  //           return _invalidBox();
  //         }).toList(),
  //       )
  //     ],
  //   );
  // }
  //08/01/26 baseurl import to fetch img from server
  Widget _buildApproverImages(List<dynamic> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Approver Images",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: images.map((img) {
            if (img is Map && img.containsKey("url")) {
              final urlPath = img["url"];
              final fullUrl = urlPath.startsWith('http')
                  ? urlPath
                  : buildImageUrl(ApiRouts.base, urlPath);

              ///=================

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.black,
                      insetPadding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: Center(
                              child: Image.network(
                                fullUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          //21/02/26
                          //  DOWNLOAD BUTTON (ADD THIS)
                          Positioned(
                            top: 40,
                            left: 20,
                            child: IconButton(
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                _downloadNetworkImage(fullUrl);
                              },
                            ),
                          ),
                          //==================
                          Positioned(
                            top: 40,
                            right: 20,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(fullUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
            return _invalidBox();
          }).toList(),
        )
      ],
    );
  }

  ///===========================

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  //
  //21/02/26 Approver and maker images save to gallery
  Future<void> _downloadNetworkImage(String imageUrl) async {
    await Permission.photos.request();
    await Permission.storage.request();

    try {
      var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      Uint8List bytes = Uint8List.fromList(response.data);

      await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: "NC_${DateTime.now().millisecondsSinceEpoch}",
      );

      successSnackBar("Success", "Image saved to gallery");
    } catch (e) {
      errorSnackBar("Error", "Failed to download image");
    }
  }
}

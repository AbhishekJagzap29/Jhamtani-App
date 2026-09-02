import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_report_response_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Report/report_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';

class EditReportScreen extends StatefulWidget {
  const EditReportScreen({super.key, required this.towerDatum});

  final TowerDatum towerDatum;

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final ReportController _reportController = Get.put(ReportController());

  @override
  void initState() {
    super.initState();
    setData();
  }

  bool isLoading = false;

  setData() {
    setState(() {
      isLoading = true;
    });
    _reportController.topicController.text =
        widget.towerDatum.topicOfTraining.toString();
    _reportController.locationController.text =
        widget.towerDatum.location.toString();
    _reportController.tNameController.text =
        widget.towerDatum.trainerName.toString();
    _reportController.trainingStartController.text =
        widget.towerDatum.trainingStartTime.toString();
    _reportController.trainingEndController.text =
        widget.towerDatum.trainingEndTime.toString();
    _reportController.difference = DateFormat('HH:mm')
        .parse(widget.towerDatum.trainingEndTime.toString())
        .difference(DateFormat('HH:mm')
            .parse(widget.towerDatum.trainingStartTime.toString()));
    _reportController.tDurationController.text =
        widget.towerDatum.totalDuration.toString();
    _reportController.tManHourController.text =
        widget.towerDatum.totalManhours.toString();
    _reportController.descriptionController.text =
        widget.towerDatum.description.toString();
    for (var i = 0; i < widget.towerDatum.trainingGivenTo!.length; i++) {
      _reportController.trainingValues.add(
          widget.towerDatum.trainingGivenTo?[i].tag.toString() == "contractor"
              ? "Contractor"
              : "jhamtaniApp");
      _reportController.trainingController.add(TextEditingController(
          text: widget.towerDatum.trainingGivenTo?[i].name));
      _reportController.focusNodes.add(FocusNode());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _reportController.trainingValues.clear();
    _reportController.trainingController.clear();
    _reportController.focusNodes.clear();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<ReportController>(builder: (controller) {
      return Scaffold(
          appBar: AppBarWidget(
            title: AppString.editReport.boldRobotoTextStyle(fontSize: 20),
          ),
          bottomNavigationBar:
              controller.updateReportResponse.status == Status.LOADING
                  ? showCircular()
                  : updateButton(
                      h,
                      w,
                      context,
                      controller,
                      widget.towerDatum.overallImages,
                      widget.towerDatum.trainingDatedOn ?? DateTime.now(),
                      widget.towerDatum.trainingReportId ?? 0,
                      int.parse(widget.towerDatum.projectInfoId.toString()),
                      int.parse(widget.towerDatum.towerId.toString())),
          body: isLoading
              ? Center(
                  child: showCircular(),
                )
              : controller.trainingValues.isEmpty ||
                      controller.trainingController.isEmpty
                  ? Center(
                      child: AppString.noTrainingDataFound
                          .boldRobotoTextStyle(fontSize: 20),
                    )
                  : SingleChildScrollView(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "${AppString.trainingGiven} :"
                                .semiBoldBarlowTextStyle(fontSize: 16),
                            (h * 0.03).addHSpace(),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.trainingValues.length ?? 0,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: h * 0.02),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: containerColor,
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                border: Border.all(
                                                    color: Colors.grey.shade200,
                                                    width: 2)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 17),
                                            child: "${index + 1}"
                                                .semiBoldBarlowTextStyle(
                                                    fontSize: 14),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: DropdownButtonFormField(
                                              value: controller
                                                  .trainingValues[index],
                                              validator: (value) {
                                                if (controller.trainingValues[
                                                        index] ==
                                                    null) {
                                                  return AppString
                                                      .pleaseEnterTrainingGivenTag;
                                                }
                                                return null;
                                              },
                                              items: controller
                                                  .trainingGivenList
                                                  .map((e) {
                                                return DropdownMenuItem(
                                                    value: e,
                                                    child: Text("$e"));
                                              }).toList(),
                                              onChanged: (value) {
                                                controller
                                                        .trainingValues[index] =
                                                    null;
                                                // if(value.toString()=='Contractor'){
                                                //   controller.trainingValues[index] ='contractor';
                                                // }else{
                                                //   controller.trainingValues[index] ='vjd';
                                                // }
                                                controller
                                                        .trainingValues[index] =
                                                    value.toString();
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: containerColor
                                                    .withOpacity(0.7),
                                                hintText: "Organization",
                                                hintStyle: textFieldTextStyle,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                            horizontal:
                                                                w * 0.045)
                                                        .copyWith(
                                                            top: h * 0.03),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 2),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.red.shade600,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      inputTextField(w, h,
                                          controller: controller
                                              .trainingController[index],
                                          focusNode:
                                              controller.focusNodes[index],
                                          onChanged: (p0) {
                                        controller.getNonEmptyTextFieldsCount();
                                      },
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              if (controller.trainingController
                                                      .length >
                                                  1) {
                                                controller.focusNodes
                                                    .removeAt(index);
                                                controller.trainingController
                                                    .removeAt(index);
                                                controller.trainingValues
                                                    .removeAt(index);
                                                controller.update();
                                                controller
                                                    .getNonEmptyTextFieldsCount();
                                              }
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              color: blackColor,
                                            ),
                                          ),
                                          isList: true,
                                          validationText:
                                              "Please Enter Training Given Name"),
                                    ],
                                  ),
                                );
                              },
                            ),

                            ///Add Name Controller

                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  controller.trainingController
                                      .add(TextEditingController());
                                  FocusNode newFocusNode = FocusNode();
                                  controller.focusNodes.add(newFocusNode);
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    FocusScope.of(context)
                                        .requestFocus(newFocusNode);
                                  });
                                  controller.trainingValues.add(null);
                                  controller.update();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: const Icon(
                                    Icons.add,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(
                            horizontal: w * 0.05, vertical: h * 0.015),
                      ),
                    ));
    });
  }

  inputTextField(double w, double h,
      {bool isReadOnly = false,
      bool isList = false,
      required TextEditingController controller,
      String? validationText,
      String? hintText,
      String? title,
      Widget? suffixIcon,
      FocusNode? focusNode,
      int? maxLine,
      String? Function(String?)? validation,
      void Function(String)? onChanged,
      VoidCallback? onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ((title ?? hintText) ?? "").semiBoldBarlowTextStyle(fontSize: 14),
        isList ? const SizedBox() : (h * 0.008).addHSpace(),
        TextFormField(
          readOnly: isReadOnly,
          controller: controller,
          style: textFieldTextStyle,
          cursorWidth: 2,
          onTap: onTap,
          focusNode: focusNode,
          validator: validation ??
              (value) {
                if (value!.trim().isEmpty || controller.text.isEmpty) {
                  return validationText;
                }
                return null;
              },
          maxLines: maxLine ?? 1,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: suffixIcon,
            fillColor: containerColor.withOpacity(0.7),
            hintText: AppString.writeHere,
            hintStyle: textFieldHintTextStyle,
            contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045)
                .copyWith(top: h * 0.03),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.red.shade600,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  /// UPDATE BUTTON
  // Widget updateButton(
  //     double h,
  //     BuildContext context,
  //     ReportController controller,
  //     List<String>? overallImages,
  //     DateTime trainingDateData,
  //     int trainingId,
  //     int projectId,
  //     int towerId) {
  //   return Padding(
  //     padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
  //     child: MaterialButton(
  //
  //       onPressed: () async {
  //         controller.updateReportDetail(
  //             overallImages, trainingDateData, trainingId, projectId, towerId);
  //       },
  //       color: Colors.black,
  //       height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Center(
  //         child: AppString.update
  //             .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
  //       ),
  //     ),
  //   );
  // }

  Widget updateButton(
      double h,
      double w,
      BuildContext context,
      ReportController controller,
      List<String>? overallImages,
      DateTime trainingDateData,
      int trainingId,
      int projectId,
      int towerId) {
    return Padding(
      padding: EdgeInsets.only(
        top: h * 0.015,
        bottom: h * 0.02,
        left: w * 0.05,
        right: w * 0.05,
      ),
      child: InkWell(
        onTap: () async {
          if (controller.formKey.currentState!.validate()) {
            controller.updateReportDetail(overallImages, trainingDateData,
                trainingId, projectId, towerId);
          }
        },
        child: Container(
          height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
          width: w,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: AppString.update
                .boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
          ),
        ),
      ),
    );
  }
}

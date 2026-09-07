import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/offline_hqi_flate_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';

class HQIFlatListController extends GetxController {
  final searchController = TextEditingController();

  List<OfflineHQIData> flatVisitList = [];
  List<OfflineLocationData> locationdata = [];
  bool isOffline = false;

  // List<HQIFlatData> searchHQIFlatList = [];

  // FlatVisitData? flatVisitdata;

  // FlatVisitsResponseModel? flatvisitres;

  void searchActivity() {
    update();
    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      locationdata = [];

      for (var visit in flatVisitList) {
        for (var location in visit.locationData ?? []) {
          if (location.locationName?.toLowerCase().contains(query) ?? false) {
            locationdata.add(location);
          }
        }
      }
    } else {
      locationdata.clear();
      for (var visit in flatVisitList) {
        locationdata.addAll(visit.locationData ?? []);
      }
    }

    update();
  }

  ///   GET FLAT VISITS DATA LOCALLY

  getAndStoreData({
    required String projectId,
    required String towerId,
    required String flatId,
    required int visitId, // select the specific visit
  }) {
    String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);

    if (resData != null && resData.isNotEmpty) {
      _flatVisitsApiResponse = ApiResponse.loading(message: 'Loading...');
      flatVisitList.clear();
      locationdata.clear();
      update();

      try {
        List<dynamic> decodedData = jsonDecode(resData);

        // Convert JSON -> List<List<OfflineHQIData>>
        List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
          if (sublist is List) {
            return sublist.map<OfflineHQIData>((item) {
              return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
            }).toList();
          }
          return <OfflineHQIData>[];
        }).toList();

        // Find the matching flat sublist
        List<OfflineHQIData>? matchedFlatList;
        for (var sublist in allOfflineData) {
          if (sublist.isNotEmpty) {
            var first = sublist.first;
            if (first.projectId.toString() == projectId && first.towerId.toString() == towerId && first.flatId.toString() == flatId) {
              matchedFlatList = sublist;
              break;
            }
          }
        }

        if (matchedFlatList != null) {
          log("✅ Found offline data for flatId=$flatId");
          flatVisitList = matchedFlatList;

          // Select the specific visit by visitId
          final selectedVisit = flatVisitList.firstWhere(
            (v) => v.visitId == visitId,
            orElse: () => OfflineHQIData(
              visitId: 0,
              projectId: 0,
              towerId: 0,
              flatId: 0,
              locationData: [],
            ),
          );

          // Only include location_data of this visit
          locationdata = selectedVisit.locationData ?? [];

          update();
          _flatVisitsApiResponse = ApiResponse.complete(locationdata);
        } else {
          log("⚠ No local data found for flatId=$flatId, calling API...");
          getFlatVisitsController(
            projectId: projectId,
            towerId: towerId,
            flatId: flatId,
            visitId: visitId,
          );
        }
      } catch (e, st) {
        log("❌ getAndStoreData ERROR: $e");
        _flatVisitsApiResponse = ApiResponse.error(message: e.toString());
      }
    } else {
      log("ℹ Offline=false or no local storage, calling API...");
      getFlatVisitsController(
        projectId: projectId,
        towerId: towerId,
        flatId: flatId,
        visitId: visitId,
      );
    }
  }

  /// working but reflact data

  getAndStoreData2({
    required String projectId,
    required String towerId,
    required String flatId,
    int? visitId,
  }) {
    String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);

    if (resData != null && resData.isNotEmpty) {
      _flatVisitsApiResponse = ApiResponse.loading(message: 'Loading...');
      flatVisitList.clear();
      locationdata.clear();
      update();

      try {
        List<dynamic> decodedData = jsonDecode(resData);

        // Convert JSON -> List<List<OfflineHQIData>>
        List<List<OfflineHQIData>> allOfflineData = decodedData.map((sublist) {
          if (sublist is List) {
            return sublist.map<OfflineHQIData>((item) {
              return OfflineHQIData.fromJson(Map<String, dynamic>.from(item));
            }).toList();
          }
          return <OfflineHQIData>[];
        }).toList();

        // Find the matching flat sublist
        List<OfflineHQIData>? matchedFlatList;
        for (var sublist in allOfflineData) {
          if (sublist.isNotEmpty) {
            var first = sublist.first;
            if (first.projectId.toString() == projectId && first.towerId.toString() == towerId && first.flatId.toString() == flatId) {
              matchedFlatList = sublist;
              break;
            }
          }
        }

        if (matchedFlatList != null) {
          log("✅ Found local offline data for flatId=$flatId");
          flatVisitList = matchedFlatList;

          if (visitId != null) {
            final selected = flatVisitList.firstWhere(
              (v) => v.visitId == visitId,
              orElse: () => flatVisitList.first,
            );
            locationdata = selected.locationData ?? [];
          } else {
            for (var visit in flatVisitList) {
              if (visit.locationData != null) {
                locationdata.addAll(visit.locationData!);
              }
            }
          }
          update();

          _flatVisitsApiResponse = ApiResponse.complete(locationdata);
        } else {
          log("⚠ No local data found for flatId=$flatId, calling API...");
          getFlatVisitsController(
            projectId: projectId,
            towerId: towerId,
            flatId: flatId,
            visitId: visitId,
          );
        }
      } catch (e, st) {
        log("❌ getAndStoreData ERROR: $e");
        _flatVisitsApiResponse = ApiResponse.error(message: e.toString());
      }
    } else {
      log("ℹ Offline=false or no local storage, calling API...");
      getFlatVisitsController(
        projectId: projectId,
        towerId: towerId,
        flatId: flatId,
        visitId: visitId,
      );
    }
  }

/*  bool isOffline = false;
  getAndStoreData({
    required bool isOffline,
    required String projectId,
    required String towerId,
    required String flatId,
    int? visitId,
  }) {
    String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
    if (isOffline == true && resData != null && resData.isNotEmpty) {
      _flatVisitsApiResponse = ApiResponse.loading(message: 'Loading...');
      flatVisitList.clear();
      locationdata.clear();
      update();

      try {
        List<dynamic> data = jsonDecode(resData);
        flatVisitList = List<OfflineHQIData>.from(data.map((x) => OfflineHQIData.fromJson(x)));

        if (visitId != null) {
          final selected = flatVisitList.firstWhere(
            (v) => v.visitId == visitId,
            orElse: () => flatVisitList.first,
          );
          locationdata = selected.locationData ?? [];
        } else {
          for (var visit in flatVisitList) {
            if (visit.locationData != null) {
              locationdata.addAll(visit.locationData!);
            }
          }
        }

        _flatVisitsApiResponse = ApiResponse.complete(locationdata);
      } catch (e, st) {
        log("getAndStoreData ERROR: $e");
        _flatVisitsApiResponse = ApiResponse.error(message: e.toString());
      }
    } else {
      getFlatVisitsController(
        projectId: projectId,
        towerId: towerId,
        flatId: flatId,
        visitId: visitId,
      );
    }
  }*/

  ApiResponse _flatVisitsApiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get flatVisitsApiResponse => _flatVisitsApiResponse;

  Future<void> getFlatVisitsController({
    required String projectId,
    required String towerId,
    required String flatId,
    int? visitId,
  }) async {
    _flatVisitsApiResponse = ApiResponse.loading(message: 'Loading...');
    flatVisitList.clear();
    locationdata.clear();
    update();

    try {
      final response = await ProjectRepo().getHQIFlatsOfflineRepo(body: {
        // "project_id": projectId,
        // "tower_id": towerId,
        "flat_id": flatId,
        "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0")
      });

      if (response.status == "SUCCESS") {
        flatVisitList = response.data ?? [];

        if (visitId != null) {
          final selected = flatVisitList.firstWhere(
            (v) => v.visitId == visitId,
            orElse: () => flatVisitList.first,
          );
          locationdata = selected.locationData ?? [];
        } else {
          for (var visit in flatVisitList) {
            if (visit.locationData != null) {
              locationdata.addAll(visit.locationData!);
            }
          }
        }

        _flatVisitsApiResponse = ApiResponse.complete(response);
      } else {
        _flatVisitsApiResponse = ApiResponse.error(
          message: response.message ?? "Something went wrong",
        );
      }
    } catch (e, st) {
      log("getFlatVisitsController ERROR: $e");
      _flatVisitsApiResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

/*  Future<void> getOfflineOrApiData({
    required bool isOffline,
    required String projectId,
    required String towerId,
    required String flatId,
    int? visitId,
  }) async {
    log('===== getOfflineOrApiData START =====');
    log('Params: isOffline=$isOffline, projectId=$projectId, towerId=$towerId, flatId=$flatId, visitId=$visitId');

    if (!isOffline) {
      log('ℹ Offline mode disabled. Fetching from API...');
      getFlatVisitsController(
        projectId: projectId,
        towerId: towerId,
        flatId: flatId,
        visitId: visitId,
      );
      return;
    }

    String? resData = preferences.getString(SharedPreference.hqiFlatsOfflineData);
    if (resData == null || resData.isEmpty) {
      log('⚠ No offline data found. Calling API...');
      getFlatVisitsController(
        projectId: projectId,
        towerId: towerId,
        flatId: flatId,
        visitId: visitId,
      );
      return;
    }

    try {
      List<dynamic> decoded = jsonDecode(resData);
      List<OfflineHQIData> allOfflineData = decoded.map<OfflineHQIData>((item) {
        if (item is Map<String, dynamic>) return OfflineHQIData.fromJson(item);
        return OfflineHQIData.fromJson((item as dynamic).toJson());
      }).toList();

      // Search for exact match on all three keys
      OfflineHQIData? matched = allOfflineData.firstWhere(
        (rec) => rec.projectId.toString() == projectId && rec.towerId.toString() == towerId && rec.flatId.toString() == flatId,
        orElse: () => null as OfflineHQIData, // Will be handled below
      );

      if (matched == null) {
        log('⚠ No match found in offline data. Calling API...');
        getFlatVisitsController(
          projectId: projectId,
          towerId: towerId,
          flatId: flatId,
          visitId: visitId,
        );

        return;
      }

      log('✅ Match found for projectId=$projectId, towerId=$towerId, flatId=$flatId');
      flatVisitList = matched; // <-- your local variable

      // Safely create the FlatVisitData object
      */ /*  final flatVisitData = FlatVisitData(
        visitId: matched.visitId,
        visitName: matched.visitName,
        locationData: matched.locationData != null
            ? matched.locationData!
                .map<LocationData>(
                  (v) => v is LocationData ? v : LocationData.fromJson((v as dynamic).toJson()),
                )
                .toList()
            : [],
        // If your model has String? color:
        color: matched.color?.toString(),
        // If your model has bool? color, use:
        // color: matched.color is bool ? matched.color : (matched.color?.toString().toLowerCase() == 'true'),

        activity_type_status: matched.activityTypeStatus,
        desc: matched.desc,
        sequence: matched.sequence,
        totalObservationCount: matched.totalObservationCount,
        pendingObservationCount: matched.pendingObservationCount,
        completedObservationCount: matched.completedObservationCount,
        checkerCompletedCount: matched.checkerCompletedCount,
        checkerPendingCount: matched.checkerPendingCount,
        makerCompletedCount: matched.makerCompletedCount,
        makerPendingCount: matched.makerPendingCount,
      );*/ /*

      // Convert matched.visitData → List<FlatVisitData>
      if (matched.visitData != null) {
        flatVisitList = matched.visitData!.map((v) => v is FlatVisitData ? v : FlatVisitData.fromJson((v as dynamic).toJson())).toList();
      } else {
        flatVisitList = [];
      }

      // Fill locationdata depending on visitId
      locationdata.clear();
      if (visitId != null && flatVisitList.isNotEmpty) {
        final selectedVisit = flatVisitList.firstWhere(
          (v) => v.visitId == visitId,
          orElse: () => flatVisitList.first,
        );
        if (selectedVisit.locationData != null) {
          locationdata.addAll(selectedVisit.locationData!);
        }
      } else {
        for (var visit in flatVisitList) {
          if (visit.locationData != null) {
            locationdata.addAll(visit.locationData!);
          }
        }
      }

      _flatVisitsApiResponse = ApiResponse.complete(locationdata);
      update();
    } catch (e, st) {
      log('❌ ERROR in getOfflineOrApiData: $e');
      log('STACKTRACE: $st');
      getFlatVisitsController(
        projectId: projectId,
        towerId: towerId,
        flatId: flatId,
        visitId: visitId,
      );
    }

    log('===== getOfflineOrApiData END =====');
  }*/

  /// OLD WORKING API
  /*ApiResponse _flatVisitsApiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get flatVisitsApiResponse => _flatVisitsApiResponse;

  Future<void> getFlatVisitsController({
    required String projectId,
    required String towerId,
    required String flatId,
    int? visitId,
  }) async {
    _flatVisitsApiResponse = ApiResponse.loading(message: 'Loading...');
    flatVisitList.clear();
    locationdata.clear();
    update();

    try {
      final response = await ProjectRepo().hqiSiteVisitRepo(body: {
        "project_id": projectId,
        "tower_id": towerId,
        "flat_id": flatId,
        "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0")
      });

      if (response.status == "SUCCESS") {
        flatVisitList = response.data ?? [];

        if (visitId != null) {
          final selected = flatVisitList.firstWhere(
            (v) => v.visitId == visitId,
            orElse: () => flatVisitList.first,
          );
          locationdata = selected.locationData ?? [];
        } else {
          for (var visit in flatVisitList) {
            if (visit.locationData != null) {
              locationdata.addAll(visit.locationData!);
            }
          }
        }

        _flatVisitsApiResponse = ApiResponse.complete(response);
      } else {
        _flatVisitsApiResponse = ApiResponse.error(
          message: response.message ?? "Something went wrong",
        );
      }
    } catch (e, st) {
      log("getFlatVisitsController ERROR: $e");
      _flatVisitsApiResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }*/

  /// REPLICATE ACTIVITY

  ApiResponse _getReplicateActivityApiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get getReplicateActivityApiResponse => _getReplicateActivityApiResponse;

  Future<dynamic> replicatelocationforhqi({Map<String, dynamic>? body}) async {
    _getReplicateActivityApiResponse = ApiResponse.loading(message: 'Loading');

    update();
    try {
      SuccessDataResponseModel successDataResponseModel = await ProjectRepo().replicatelocationforhqiRepo(body: body);
      _getReplicateActivityApiResponse = ApiResponse.complete(successDataResponseModel);

      log("successDataResponseModel==>$successDataResponseModel");
    } catch (e) {
      _getReplicateActivityApiResponse = ApiResponse.error(message: e.toString());
      log("successDataResponseModel=ERROR=>$e");
    }
    update();
  }

  /// DELETE  ACTIVITY

  ApiResponse _deleteActivityApiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get deleteActivityApiResponse => _deleteActivityApiResponse;

  Future<dynamic> deleteActivityController({Map<String, dynamic>? body}) async {
    _deleteActivityApiResponse = ApiResponse.loading(message: 'Loading');

    update();
    try {
      SuccessDataResponseModel successDataResponseModel = await ProjectRepo().deleteActivityRepo(body: body);
      _deleteActivityApiResponse = ApiResponse.complete(successDataResponseModel);

      log("_deleteActivityApiResponse==>$successDataResponseModel");
    } catch (e) {
      _deleteActivityApiResponse = ApiResponse.error(message: e.toString());
      log("_deleteActivityApiResponse=ERROR=>$e");
    }
    update();
  }

// ApiResponse _getFlatLocationObservationApiResponse =
//     ApiResponse.initial(message: 'Initialization');

// ApiResponse get getFlatLocationObservationApiResponse =>
//     _getFlatLocationObservationApiResponse;

// Future<void> getFlatLocationObservationOffline({
//   required int locationId,
// }) async {
//   _getFlatLocationObservationApiResponse = ApiResponse.loading(message: 'Loading');
//   update();

//   try {
//     final Map<String, dynamic> body = {
//       "location_id": locationId,
//     };

//     log('Sending location observation offline body: $body');

//     FlatLocationObservationOfflineResponseModel response =
//         await ProjectRepo().getFlatLocationObservationOfflineRepo(body: body);

//     _getFlatLocationObservationApiResponse = ApiResponse.complete(response);
//   } catch (e) {
//     _getFlatLocationObservationApiResponse =
//         ApiResponse.error(message: e.toString());
//     log("getFlatLocationObservationOffline=>ERROR: $e");
//   }

//   update();
// }

  // ApiResponse _getFlatLocationObservationApiResponse = ApiResponse.initial(message: 'Initialization');
  //
  // ApiResponse get getFlatLocationObservationApiResponse => _getFlatLocationObservationApiResponse;
  //
  // Future<void> getFlatLocationObservationOffline({
  //   required int locationId,
  //   required BuildContext context,
  //   required double h,
  //   required double w,
  // }) async {
  //   _getFlatLocationObservationApiResponse = ApiResponse.loading(message: 'Loading');
  //   update();
  //
  //   try {
  //     final Map<String, dynamic> body = {
  //       "location_id": locationId,
  //     };
  //
  //     log('Sending location observation offline body: $body');
  //
  //     FlatLocationObservationOfflineResponseModel response = await ProjectRepo().getFlatLocationObservationOfflineRepo(body: body);
  //
  //     /// ✅ Load existing saved data
  //     String resData = preferences.getString(SharedPreference.hqiFlatsOffline).toString();
  //
  //     List<LocationObservationData> tempData = [];
  //     if (resData.isNotEmpty) {
  //       var data = jsonDecode(resData);
  //       tempData = List<LocationObservationData>.from(data.map((x) => LocationObservationData.fromJson(x)));
  //       if (tempData.length >= 5) {
  //         syncDataFirst(context, h, w);
  //         return;
  //       }
  //     }
  //
  //     /// ✅ Remove old entry if exists
  //     tempData.removeWhere((e) => e.locationId == response.data?.first.locationId);
  //
  //     /// ✅ Add new entry
  //     if (response.data != null && response.data!.isNotEmpty) {
  //       tempData.add(response.data!.first);
  //     }
  //
  //     /// ✅ Save updated data
  //     preferences.putString(SharedPreference.hqiFlatsOffline, jsonEncode(tempData.map((e) => e.toJson()).toList()));
  //
  //     await Future.delayed(const Duration(seconds: 1));
  //
  //     _getFlatLocationObservationApiResponse = ApiResponse.complete(response);
  //
  //     // ignore: use_build_context_synchronously
  //     saveForOfflineUse(context, h, w, tempData.length);
  //   } catch (e) {
  //     _getFlatLocationObservationApiResponse = ApiResponse.error(message: e.toString());
  //     log("getFlatLocationObservationOffline => ERROR: $e");
  //   }
  //
  //   update();
  // }

  // Future<void> saveForOfflineUse(BuildContext context, double h, double w, int length) {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         title: Center(
  //           child: "Save Activity".semiBoldBarlowTextStyle(fontSize: 22, textAlign: TextAlign.center),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               "This activity data saved successfully for the offline use. You can store maximum 5 activity data for offline use."
  //                   .regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               "Total saved activities : $length/5".regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
  //             ],
  //           ),
  //         ),
  //         contentPadding: const EdgeInsets.all(15).copyWith(top: 20),
  //         actions: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: MaterialButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               color: appColor,
  //               height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //               child: Center(
  //                 child: "Okay".boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
  //               ),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> syncDataFirst(BuildContext context, double h, double w) {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         title: Center(
  //           child: "Alert!".semiBoldBarlowTextStyle(fontSize: 22, textAlign: TextAlign.center),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               "You have reached save activity limit which is maximum 5 so please sync data to the server then you can store other activities."
  //                   .regularRobotoTextStyle(fontSize: 15, textAlign: TextAlign.center),
  //             ],
  //           ),
  //         ),
  //         contentPadding: const EdgeInsets.all(15).copyWith(top: 20),
  //         actions: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: MaterialButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               color: appColor,
  //               height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //               child: Center(
  //                 child: "Okay".boldRobotoTextStyle(fontSize: 16, fontColor: backGroundColor),
  //               ),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}

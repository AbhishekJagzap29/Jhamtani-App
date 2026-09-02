// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:vj_developers_app/Api/Apis/api_response.dart';
// import 'package:vj_developers_app/Api/Repo/project_repo.dart';
// import 'package:vj_developers_app/Api/ResponseModel/HomeInspection/observation_history_res_model.dart';

// class ObservationHistoryController extends GetxController {
//   List<ObservationHistory> observationHistoryList = [];

//   ApiResponse _observationResponse = ApiResponse.initial(message: 'Initialization');
//   ApiResponse get observationResponse => _observationResponse;

//   Future<void> fetchObservationHistory({required int? observationId}) async {
//     _observationResponse = ApiResponse.loading(message: 'Loading observation history...');
//     update();

//     try {
//       final request = {"observation_id": observationId};

//       ObservationHistoryModel response = await ProjectRepo().observationHistoryRepo(body: request);

//       if (response.data != null && response.data!.isNotEmpty) {
//         observationHistoryList = response.data!;
//         _observationResponse = ApiResponse.complete(response);
//       } else {
//         observationHistoryList = [];
//         _observationResponse = ApiResponse.error(message: 'No observation history found');
//       }
//     } catch (e, stacktrace) {
//       log("Error fetching observation history: $e");
//       log("Stacktrace: $stacktrace");
//       _observationResponse = ApiResponse.error(message: e.toString());
//     }

//     update();
//   }
// }






























import 'dart:developer';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/observation_history_res_model.dart';
import 'package:get/get.dart';

class ObservationHistoryController extends GetxController {
  ObservationHistory? observationHistory; // <- Now a single object
  List<ObservationHistory>? observationHistoryList;

  ApiResponse _observationResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get observationResponse => _observationResponse;

  Future<void> fetchObservationHistory({required int? observationId}) async {
    _observationResponse = ApiResponse.loading(message: 'Loading observation history...');
    update();

    try {
      final request = {"observation_id": observationId};

      ObservationHistoryModel response = await ProjectRepo().observationHistoryRepo(body: request);

      if (response.data != null) {
        observationHistory = response.data; // <- Store single object
        _observationResponse = ApiResponse.complete(response);
      } else {
        observationHistory = null;
        _observationResponse = ApiResponse.error(message: 'No observation history found');
      }
    } catch (e, stacktrace) {
      log("Error fetching observation history: $e");
      log("Stacktrace: $stacktrace");
      _observationResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }
}

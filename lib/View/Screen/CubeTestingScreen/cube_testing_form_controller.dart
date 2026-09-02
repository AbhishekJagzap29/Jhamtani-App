

import 'package:jhamtani_app/Api/Repo/cube_testing_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/CubeTestingResponseModel/cube_testing_form_model.dart';

class CubeTestingController {
  final CubeTestingRepository repo = CubeTestingRepository();

  /// CREATE CUBE RECORD
  Future<CubeTestingModel?> createCube(CubeTestingModel model) async {
    print("CONTROLLER → CREATE CUBE CALLED");
    try {
      final response = await repo.createRecord(model.toJson());
      if (response != null) {
        print("CUBE CREATED SUCCESSFULLY");
        return response;
      } else {
        print("CREATE API FAILED");
        return null;
      }
    } catch (e) {
      print("ERROR IN CONTROLLER: $e");
      return null;
    }
  }

  /// FETCH CUBE LIST
  Future<List<dynamic>> getCubeList() async {
    print("CONTROLLER → FETCH LIST");

    try {
      final response = await repo.getRecords();

      return response;
    } catch (e) {
      print("LIST FETCH ERROR: $e");
      return [];
    }
  }
}

import 'dart:convert';

import 'package:jhamtani_app/Api/ResponseModel/CubeTestingResponseModel/cube_testing_form_model.dart';
import 'package:jhamtani_app/Api/Services/base_service.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:http/http.dart' as http;

class CubeTestingRepository {
  int _loggedInUserId() {
    return int.tryParse(
            preferences.getString(SharedPreference.userId) ?? "0") ??
        0;
  }

  /// CREATE RECORD
  Future<CubeTestingModel?> createRecord(Map<String, dynamic> body) async {
    final requestBody = Map<String, dynamic>.from(body);
    requestBody["user_id"] ??= _loggedInUserId();

    print("CREATE CUBE API CALLED");
    print("API URL: ${ApiRouts.createCubeTesting}");
    print("REQUEST BODY: $requestBody");

    final response = await http.post(
      Uri.parse(ApiRouts.createCubeTesting),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return CubeTestingModel.fromJson(jsonData);
    } else {
      print("API ERROR");
      return null;
    }
  }

  //fetch all records
  Future<List<dynamic>> getRecords({int? floorId}) async {
    print("GET CUBE RECORDS API CALLED");

    final response = await http.post(
      Uri.parse(ApiRouts.getCubeTestingList),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"floor_id": floorId}),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final result = data["result"];

      if (result["status"] == "success") {
        return result["data"] ?? [];
      }
    }

    return [];
  }

  /// GET SINGLE RECORD
  Future<dynamic> getSingleRecord(int id) async {
    print("GET SINGLE RECORD API CALLED");

    final url = ApiRouts.getSingleCubeTesting;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id": id,
      }),
    );

    print("URL: $url");
    print("Sent ID: $id");
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["result"]["status"] == "success") {
        return data["result"]["data"];
      } else {
        print("ERROR: ${data["result"]["message"]}");
      }
    }

    return null;
  }

  Future<bool> deleteCubeRecord(int id) async {
    final url = Uri.parse("${ApiRouts.deleteCubeTesting}$id");
    final requestBody = {
      "user_id": _loggedInUserId(),
    };

    print("DELETE API CALLED");
    print("URL: $url");
    print("BODY: $requestBody");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["result"] != null && data["result"]["status"] == "success") {
        return true;
      }
    }

    return false;
  }

  /// UPDATE RECORD
  Future<bool> updateCubeRecord(int id, Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiRouts.updateCubeTesting}/$id");
    final requestBody = Map<String, dynamic>.from(body);
    requestBody["user_id"] ??= _loggedInUserId();

    print("UPDATE API CALLED");
    print("URL: $url");
    print("BODY: $requestBody");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["error"] != null) {
        print("UPDATE API ERROR: ${data["error"]}");
        return false;
      }

      if (data["status"] == "success") {
        return true;
      }

      if (data["result"] != null && data["result"]["status"] == "success") {
        return true;
      }
    }

    return false;
  }
}

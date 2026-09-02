import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/app_routes.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const isLogin = "isLogin";
  static const isAdmin = "isAdmin";
  static const userLoginData = "userLoginData";
  static const sessionId = "sessionId";
  static const userType = "userType";
  static const userId = "userId";
  static const activityData = "activityData";
  // static const workActivityData = "workActivityData";
  // static const materialActivityData = "materialActivityData";
  static const savedActivityData = "savedActivityData";
  static const del_activity_users = "del_activity_users";
  static const projectId = "projectId";
  static const userPassword = "userPassword";
  static const userName = "userName";
  static const hqiFlatsOffline = "hqiFlatsOffline";
  static const hqiFlatsOfflineData = "hqiFlatsData";
  static const issueCategoriesWithTypes = "issueCategoriesWithTypes";
  static const observationCategory ="observationCategory";
  static const String impactTypes = 'impact_types';
//static const userType = "hqi_user_type";


  logOut() async {
    // await AuthRepo().logOut();
    await _preferences!.clear();
    Get.offAllNamed(Routes.loginScreen);
    successSnackBar("Success", "You've been logged out");
  }

  // removeCheckPointData() async {
  //   _preferences?.remove(SharedPreference.checkPointData);
  // }

  Future<bool?> putString(String key, String value) async {
    return _preferences == null ? null : _preferences!.setString(key, value);
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences == null ? defValue : _preferences!.getString(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    return _preferences == null ? null : _preferences!.setInt(key, value);
  }

  int? getInt(String key, {int defValue = 0}) {
    return _preferences == null ? defValue : _preferences!.getInt(key) ?? defValue;
  }

  Future<bool?> putDouble(String key, double value) async {
    return _preferences == null ? null : _preferences!.setDouble(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _preferences == null ? defValue : _preferences!.getDouble(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    return _preferences == null ? null : _preferences!.setBool(key, value);
  }

  bool? getBool(String key, {bool defValue = false}) {
    return _preferences == null ? defValue : _preferences!.getBool(key) ?? defValue;
  }

  Future<bool?> removePreference(String key) async {
    return _preferences?.remove(key);
  }
}

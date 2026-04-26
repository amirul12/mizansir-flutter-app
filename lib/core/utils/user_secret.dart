import 'dart:convert';

import 'package:mizansir/core/utils/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
 

 
const String TOKEN_KEY = "token";
const String LOGIN_KEY = "loginKey";
const String MOBILE_KEY = "mobileKey";
const String CURRENT_VERSION_UPDATE_KEY = "CURRENT_VERSION_UPDATE_KEY";
const String DONT_SHOW_UPDATE_IN_THIS_VERSION =
    "dontShowUpdateAgainInThisVersion";
const String deviceName = "deviceName";
const String deviceAddress = "deviceAddress";

const String USER_INFO = "userInfo";
const String USER_ToKEN = "userToken";

class UserSecret {
  UserSecret();

  static bool isFirstTime = true;

  static int adValue = 0;
  static String currency = "৳";

  static String? accessToken;
  static String? firebaseToken;

  static String? shippingAddressId;

  static String? addFullName;
  static String? addMobile;
  static String? addAddress;

  static int currentPage = 0;

 

  addressClear() {
    addFullName = null;
    addMobile = null;
    addAddress = null;
  }

  // static User? userInfo;
  // static setUserInfo(val) {
  //   userInfo = val;
  // }

  // Save the response data
  // Future<void> saveResponse(String responseData) async {
  //   var box = await Hive.openBox<CommonResponseHive>('responseBox');
  //   var apiResponse = CommonResponseHive()..response = responseData;
  //   box.add(apiResponse);
  // }

// Retrieve the saved response data
  // Future<String?> getResponse() async {
  //   var box = await Hive.openBox<CommonResponseHive>('responseBox');
  //   if (box.isNotEmpty) {
  //     CommonResponseHive firstItem = box.getAt(0)!;
  //     return firstItem.response;
  //   }
  //   return null;
  // }

  clearData() {
    accessToken = null;
    // userInfo = null;
    // addressClear();
    logoutAccount();
  }

  Future setDeviceData(name, address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(deviceName, name);
    prefs.setString(deviceAddress, address);
  }

  Future<String?> getDeviceName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(deviceName) ?? "";
  }

  Future<String?> getDeviceAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(deviceAddress) ?? "66:22:AC:21:54:E8";
  }

  Future clearDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(deviceName, "");
    prefs.setString(deviceAddress, "");
  }

  logoutAccount() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    prefs.clear();
    return true;
  }

  /// Adding a string value
  dynamic putString(key, val) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    var res = prefs.setString("$key", val);
    return res;
  }

  // Save data
  Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    }
  }

// Retrieve data
  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  /// Get string value
  /// Argument [key]
  dynamic getString(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    String? res = prefs.getString("$key");
    return res;
  }

  /// Adding a bool value
  dynamic putBool(key, val) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    var res = prefs.setBool("$key", val);
    return res;
  }

  /// Get bool value

  dynamic getBool(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    bool? res = prefs.getBool("$key");
    return res;
  }

  /// Adding a list or object
  /// Use import 'dart:convert'; for jsonEncode
  dynamic putJson(key, val) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    var valString = jsonEncode(val);
    var res = prefs.setString("$key", valString);
    return res;
  }

  dynamic getJsonString(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    String? res = prefs.getString("$key");
    return res;
  }

  dynamic getMobileNumber() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    String? res = prefs.getString("mobile");
    return res;
  }

  /// Get list or object
  /// Use import 'dart:convert'; for jsonEncode
  /// Argument [key]
  dynamic getJson(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    String? jsonString = prefs.getString("$key");
    var res = jsonDecode(jsonString!);
    return res;
  }

  dynamic setLogin(bool isLogin) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    prefs.setBool(LOGIN_KEY, isLogin);
  }

  dynamic getLogin() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    Object? token = prefs.get(LOGIN_KEY);

    return token;
  }

  dynamic setAuthToken(String token) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    prefs.setString(TOKEN_KEY, token);
    amirPrint("set token");
    amirPrint(token);
    return token;
  }

  dynamic getAuthToken() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    String? token = prefs.getString(
      TOKEN_KEY,
    );
    amirPrint("get token");
    amirPrint(token);
    return token;
  }
}

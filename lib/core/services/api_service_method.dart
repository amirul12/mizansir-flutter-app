// Updated ApiMethod with dynamic language support

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mizansir/core/services/error_response.dart' show ErrorResponse;
import 'package:mizansir/core/services/token_service.dart' show TokenService;
import 'package:mizansir/core/utils/logger.dart' show logger;
import 'package:mizansir/core/utils/testing.dart' show amirPrint;
import 'package:mizansir/core/di/injection_container.dart' as di;
import 'package:mizansir/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mizansir/features/auth/presentation/bloc/auth_event.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' as QContext;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import



import 'api_exception.dart';

final log = logger(ApiMethod);

// UPDATED: Method to get current language dynamically
Future<String> getCurrentLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('selected_language') ?? 'bn'; // Default to Bangla
}

Future<String> getPlateformName() async {
  if (Platform.isAndroid) {
    return "android";
  } else if (Platform.isIOS) {
    return "ios";
  } else {
    return "mobile"; // Default to web for other platforms
  }
}

Future<String> getAppVertion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version; // Get the app version dynamically
}

// UPDATED: Make basicHeaderInfo async and dynamic
Future<Map<String, String>> basicHeaderInfo() async {
  final currentLang = await getCurrentLanguage();
  final platformName = await getPlateformName();
  final appVersion = await getAppVertion(); // Get app version dynamically

  final headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json",
    "clienttype": platformName, // UPDATED: Dynamic client type
    "appversion": appVersion, // UPDATED: Dynamic app version
    "lang": currentLang, // UPDATED: Dynamic language
    "headerapisecret":
        "4B57AC7AC8892694D579EE884AD1E44A36CDB3ACA969E18CAF41778A3D18981F9B8296C"
  };

  amirPrint("📋 Basic Header Info:");
  amirPrint("  ├─ clienttype: $platformName");
  amirPrint("  ├─ appversion: $appVersion");
  amirPrint("  ├─ lang: $currentLang");
  amirPrint("  └─ Full Headers: $headers");

  return headers;
}

// UPDATED: Updated bearerHeaderInfo with dynamic language
Future<Map<String, String>> bearerHeaderInfo() async {
  var token = await TokenService().retrieveBearerToken();
  final currentLang =
      await getCurrentLanguage(); // UPDATED: Get current language

  final platformName =
      await getPlateformName(); // Get platform name dynamically
  final appVersion = await getAppVertion(); // Get app version dynamically

  final headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    "clienttype": platformName, // UPDATED: Dynamic client type
    "appversion": appVersion, // UPDATED: Dynamic app version
    "headerapisecret":
        "4B57AC7AC8892694D579EE884AD1E44A36CDB3ACA969E18CAF41778A3D18981F9B8296C",
    "lang": currentLang, // UPDATED: Dynamic language
    HttpHeaders.authorizationHeader: "Bearer $token",
  };

  amirPrint("🔐 Bearer Header Info:");
  amirPrint("  ├─ clienttype: $platformName");
  amirPrint("  ├─ appversion: $appVersion");
  amirPrint("  ├─ lang: $currentLang");
  amirPrint("  ├─ token: ${token?.substring(0, 20)}...");
  amirPrint("  └─ Full Headers: $headers");

  return headers;
}

class ApiMethod {
  ApiMethod({required this.isBasic});

  bool isBasic;
  static bool _isSessionOutShowing = false;

  void _handleUnauthorized() {
    if (_isSessionOutShowing) return;
    _isSessionOutShowing = true;

    final context = QContext.navigatorKey.currentState?.context;
    if (context != null) {
      // Clear token/auth state
      di.sl<AuthBloc>().add(LogoutEvent());

      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: 'Session Expired',
        desc: 'Session out, please login',
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        btnOkOnPress: () {
          _isSessionOutShowing = false;
          context.go('/');
        },
      ).show();
    }
  }

  static Future<bool> hasInternet() async {
    bool hasInternet = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        amirPrint('connected');
        hasInternet = true;
      }
    } on SocketException catch (_) {
      amirPrint('not connected');
      hasInternet = false;
    }

    return hasInternet;
  }


  // UPDATED: Get method with dynamic headers
  Future<dynamic> get(
    String url, {
    int code = 200,
    query,
    overloadBase,
    hasLoader = false,
    bool queryEncoderd = false,
    int duration = 30,
    bool showResult = false,
  }) async {
    log.i(
        '|📍📍📍|----------------- [[ GET ]] method details start -----------------|📍📍📍|');
    log.i(url);
    log.i(
        '|📍📍📍|----------------- [[ GET ]] method details ended -----------------|📍📍📍|');

    try {
      if (hasLoader) {
        // Show loader if necessary
      }

      var response;

      Uri uri;
      if (query != null) {
        String queryString = Uri(queryParameters: query).query;
        url = "$url?$queryString";
      }

      uri = Uri.parse(overloadBase ?? url);
      if (queryEncoderd) {
        uri.replace(
            query: queryEncoderd ? uri.query : Uri.decodeFull(uri.query));
      }
      amirPrint(uri);

      http.Request request = http.Request('GET', uri);
      // UPDATED: Now uses await for dynamic headers
      request.headers
          .addAll(isBasic ? await basicHeaderInfo() : await bearerHeaderInfo());

      amirPrint(request);
      amirPrint(request.headers.entries);
      amirPrint("header print");
      response = await request.send().timeout(
            const Duration(
              seconds: 60,
            ),
            onTimeout: () =>
                throw TimeoutException("Request Timed out! Try again"),
          );

      if (response.statusCode == 401) {
        amirPrint("401 Unauthorized - showing dialog");
        _handleUnauthorized();
        return null;
      }

      log.i(response.statusCode);
      log.i(
          '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

      return _response(response, hasLoader: false);
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      if (hasLoader) {
        Navigator.of(QContext.navigatorKey.currentState!.context).pop(false);
      }

      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: QContext.navigatorKey.currentState!.context,
        dialogType: DialogType.noHeader,
        animType: AnimType.bottomSlide,
        title: 'No Internet Connection',
        desc: 'Please check your internet connection and try again',
        titleTextStyle:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        descTextStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        dialogBorderRadius: BorderRadius.circular(0),
        buttonsBorderRadius: BorderRadius.circular(0),
        btnOkColor: Colors.black,
        btnCancelOnPress: () {
          SystemNavigator.pop();
        },
        btnCancelText: "Exit",
        btnOkOnPress: () {
          get(url,
              query: query,
              hasLoader: hasLoader,
              code: code,
              overloadBase: overloadBase,
              queryEncoderd: queryEncoderd,
              duration: duration,
              showResult: showResult);
        },
        btnOkText: "Retry",
      ).show();

      throw NetworkException();
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');
      log.e('Time out exception$url');
      throw TimeoutException();
    } on http.ClientException catch (err, stackTrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackTrace.toString());
      throw ClientException();
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');
      log.e('❌❌❌ unlisted error received');
      log.e("❌❌❌ $e");
      throw CustomException(e?.toString() ?? 'Unknown error');
    }
  }

  // UPDATED: Post Method with dynamic headers
  Future post(String url, Map<String, dynamic> body,
      {int code = 200,
      int duration = 30,
      overloadBase,
      hasLoader = true,
      bool showResult = false}) async {
    try {
      if (hasLoader) {
        // Show loader if necessary
      }
      log.i(
          '|📍📍📍|-----------------[[ POST ]] method details start -----------------|📍📍📍|');

      log.i(url);
      log.i(body);
      log.i(
          '|📍📍📍|-----------------[[ POST ]] method details end ------------|📍📍📍|');

      var uri = Uri.parse(url);

      http.Request request = http.Request('POST', uri);
      // UPDATED: Now uses await for dynamic headers
      request.headers
          .addAll(isBasic ? await basicHeaderInfo() : await bearerHeaderInfo());
      if (body.isNotEmpty) {
        request.body = jsonEncode(body);
      }

      var response = await request.send().timeout(Duration(seconds: duration),
          onTimeout: () =>
              throw TimeoutException("Request Timed out! Try again"));

      log.i(response.statusCode);
      log.i(
          '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

      if (response.statusCode == 401) {
        amirPrint("401 Unauthorized - showing dialog");
        _handleUnauthorized();
        return null;
      }

      return _response(response, hasLoader: false);
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      throw NetworkException();
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');
      log.e('Time out exception$url');
      throw TimeoutException();
    } on http.ClientException catch (err, stackTrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackTrace.toString());
      throw ClientException();
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');
      log.e('❌❌❌ unlisted error received');
      log.e("❌❌❌ $e");
      throw CustomException(e?.toString() ?? 'Unknown error');
    }
  }

  // UPDATED: paramGet method with dynamic headers
  Future<Map<String, dynamic>?> paramGet(String url, Map<String, String> body,
      {int code = 200, int duration = 15, bool showResult = false}) async {
    log.i(
        '|Get param📍📍📍|----------------- [[ GET ]] param method Details Start -----------------|📍📍📍|');

    log.i("##body given --> ");

    if (showResult) {
      log.i(body);
    }

    log.i("##url list --> $url");

    log.i(
        '|Get param📍📍📍|----------------- [[ GET ]] param method details ended ** ---------------|📍📍📍|');

    try {
      final response = await http
          .get(
            Uri.parse(url).replace(queryParameters: body),
            // UPDATED: Now uses await for dynamic headers
            headers:
                isBasic ? await basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(const Duration(seconds: 15));

      log.i(
          '|📒📒📒| ----------------[[ Get ]] Peram Response Start---------------|📒📒📒|');

      if (showResult) {
        log.i(response.body.toString());
      }

      log.i(
          '|📒📒📒| ----------------[[ Get ]] Peram Response End **-----------------|📒📒📒|');

      if (response.statusCode == 401) {
        _handleUnauthorized();
        return null;
      }
      if (response.statusCode == code) {
        return jsonDecode(response.body);
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));
        return null;
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      return null;
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('Time out exception$url');
      return null;
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackrace.toString());
      return null;
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('#url->$url||#body -> $body');
      log.e('❌❌❌ unlisted error received');
      log.e("❌❌❌ $e");
      return null;
    }
  }

  // UPDATED: multipart method with dynamic headers
  Future multipart(
      String url, Map<String, String> body, String? filepath, String filedName,
      {int code = 200, bool showResult = false}) async {
    try {
      log.i(
          '|📍📍📍|-----------------[[ Multipart ]] method details start -----------------|📍📍📍|');

      log.i(url);
      log.i(body);
      log.i(filepath);
      log.i(
          '|📍📍📍|-----------------[[ Multipart ]] method details end ------------|📍📍📍|');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      )
        ..fields.addAll(body)
        // UPDATED: Now uses await for dynamic headers
        ..headers.addAll(await bearerHeaderInfo());

      if (filepath != "null" && filepath != null) {
        request.files
            .add(await http.MultipartFile.fromPath(filedName, filepath));
      } else {
        log.e("file path is null");
      }

      var response = await request.send();
      log.i(response.statusCode);
      log.i(
          '|📒📒📒|-----------------[[ UPLOAD ]] method response end --------------------|📒📒📒|');

      if (response.statusCode == 401) {
        log.e("401 Unauthorized - showing dialog");
        _handleUnauthorized();
        return null;
      }

      return _response(response, hasLoader: false);
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      throw NetworkException();
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');
      log.e('Time out exception$url');
      throw TimeoutException();
    } on http.ClientException catch (err, stackTrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackTrace.toString());
      throw ClientException();
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');
      log.e('❌❌❌ unlisted error received');
      log.e("❌❌❌ $e");
      throw CustomException(e?.toString() ?? 'Unknown error');
    }
  }

  // UPDATED: multipartMultiFile method with dynamic headers
  Future<Map<String, dynamic>?> multipartMultiFile(
    String url,
    Map<String, String> body, {
    int code = 200,
    bool showResult = false,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    try {
      log.i(
          '|📍📍📍|-----------------[[ Multipart ]] method details start -----------------|📍📍📍|');

      log.i(url);

      if (showResult) {
        log.i(body);
        log.i(pathList);
        log.i(fieldList);
      }

      log.i(
          '|📍📍📍|-----------------[[ Multipart ]] method details end ------------|📍📍📍|');

      var token = '';
      final currentLang =
          await getCurrentLanguage(); // UPDATED: Get current language
      final platformName = await getPlateformName(); // Get platform name
      final appVersion = await getAppVertion(); // Get app version

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'clienttype': platformName, // ADDED: Dynamic client type
        'appversion': appVersion, // ADDED: Dynamic app version
        'Authorization': 'Bearer $token',
        'lang': currentLang, // UPDATED: Dynamic language
        'headerapisecret':
            "4B57AC7AC8892694D579EE884AD1E44A36CDB3ACA969E18CAF41778A3D18981F9B8296C",
      };

      amirPrint("📤 Multipart Multi-File Upload Headers:");
      amirPrint("  ├─ clienttype: $platformName");
      amirPrint("  ├─ appversion: $appVersion");
      amirPrint("  ├─ lang: $currentLang");
      amirPrint("  └─ Full Headers: $headers");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      )
        ..fields.addAll(body)
        ..headers.addAll(headers);

      for (int i = 0; i < fieldList.length; i++) {
        request.files
            .add(await http.MultipartFile.fromPath(fieldList[i], pathList[i]));
      }

      var response = await request.send();
      var jsonData = await http.Response.fromStream(response);

      log.i(
          '|📒📒📒|-----------------[[ POST ]] method response start ------------------|📒📒📒|');

      log.i(jsonData.body.toString());
      log.i(response.statusCode);
      log.i(
          '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

      if (response.statusCode == 401) {
        _handleUnauthorized();
        return null;
      }
      if (response.statusCode == code) {
        return jsonDecode(jsonData.body) as Map<String, dynamic>;
      } else {
        log.e('🐞🐞🐞 Error Alert On Status Code 🐞🐞🐞');
        log.e(
            'unknown error hitted in status code ${jsonDecode(jsonData.body)}');

        ErrorResponse res = ErrorResponse.fromJson(jsonDecode(jsonData.body));
        return null;
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      return null;
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');
      log.e('Time out exception$url');
      return null;
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackrace.toString());
      return null;
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');
      log.e('❌❌❌ unlisted error received');
      log.e("❌❌❌ $e");
      return null;
    }
  }

  // UPDATED: delete method with dynamic headers
  Future<Map<String, dynamic>?> delete(String url,
      {int code = 203,
      bool isLogout = false,
      int duration = 15,
      bool showResult = false}) async {
    log.i(
        '|📍📍📍|-----------------[[ DELETE ]] method details start-----------------|📍📍📍|');

    log.i(url);
    log.i(
        '|📍📍📍|-----------------[[ DELETE ]] method details end ------------------|📍📍📍|');

    try {
      // UPDATED: Now uses await for dynamic headers
      var headers =
          isBasic ? await basicHeaderInfo() : await bearerHeaderInfo();

      if (isLogout) {}

      log.i(headers);

      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(Duration(seconds: duration));

      log.i(
          '|📒📒📒|----------------- [[ DELETE ]] method response start-----------------|📒📒📒|');

      if (showResult) {
        log.i(response.body.toString());
      }

      log.i(response.statusCode);
      log.i(
          '|📒📒📒|----------------- [[ DELETE ]] method response start-----------------|📒📒📒|');

      if (response.statusCode == 401) {
        _handleUnauthorized();
        return null;
      }
      if (response.statusCode == code) {
        return jsonDecode(response.body);
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));
        return null;
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      return null;
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('Time out exception$url');
      return null;
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackrace.toString());
      return null;
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('❌❌❌ unlisted error received');
      log.e("❌❌❌ $e");
      return null;
    }
  }

  // UPDATED: put method with dynamic headers
  Future<Map<String, dynamic>?> put(String url, Map<String, dynamic> body,
      {int code = 200, int duration = 15, bool showResult = false}) async {
    try {
      log.i(
          '|📍📍📍|-------------[[ PUT ]] method details start-----------------|📍📍📍|');

      log.i(url);
      log.i(body);
      log.i(
          '|📍📍📍|-------------[[ PUT ]] method details end ------------|📍📍📍|');

      final response = await http
          .put(
            Uri.parse(url),
            body: jsonEncode(body),
            // UPDATED: Now uses await for dynamic headers
            headers:
                isBasic ? await basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      log.i(
          '|📒📒📒|-----------------[[ PUT ]] AKA Update method response start-----------------|📒📒📒|');

      if (showResult) {
        log.i(response.body);
      }

      log.i(response.statusCode);
      log.i(
          '|📒📒📒|-----------------[[ PUT ]] AKA Update method response End -----------------|📒📒📒|');

      if (response.statusCode == 401) {
        _handleUnauthorized();
        return null;
      }
      if (response.statusCode == code) {
        return jsonDecode(response.body);
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));
        return null;
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      return null;
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('Time out exception$url');
      return null;
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackrace.toString());
      return null;
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');
      log.e('unlisted catch error received');
      log.e(e.toString());
      return null;
    }
  }

  // Rest of the methods remain the same...
  Future<String?> getAccesstokenFile() async {
    return null;
  }

  Future uploadFile(String url, String filePath,
      {int code = 200,
      int duration = 30,
      overloadBase,
      hasLoader = true,
      bool showResult = false}) async {
    try {
      if (hasLoader) {
        // Show loader if necessary
      }
      log.i(
          '|📍📍📍|-----------------[[ UPLOAD ]] method details start -----------------|📍📍📍|');

      log.i(url);
      log.i(filePath);
      log.i(
          '|📍📍📍|-----------------[[ UPLOAD ]] method details end ------------|📍📍📍|');

      var uri = Uri.parse(url);

      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      // UPDATED: Now uses await for dynamic headers
      request.headers.addAll(await bearerHeaderInfo());

      // Adding file to request
      request.files
          .add(await http.MultipartFile.fromPath('aiz_file', filePath));

      var response = await request.send().timeout(Duration(seconds: duration),
          onTimeout: () =>
              throw TimeoutException("Request Timed out! Try again"));

      log.i(response.statusCode);
      log.i(
          '|📒📒📒|-----------------[[ UPLOAD ]] method response end --------------------|📒📒📒|');

      if (response.statusCode == 401) {
        _handleUnauthorized();
        return null;
      }

      return _response(response, hasLoader: false);
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
      throw NetworkException();
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');
      log.e('Time out exception$url');
      throw TimeoutException();
    } on http.ClientException catch (err, stackTrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');
      log.e('client exception hitted');
      log.e(err.toString());
      log.e(stackTrace.toString());
      throw ClientException();
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');
      log.e('❌❌❌ unlisted error received');
      log.e("❌❌❌ $e");
      throw CustomException(e?.toString() ?? 'Unknown error');
    }
  }

  dynamic _response(http.StreamedResponse response,
      {bool hasLoader = true}) async {
    final res = await http.Response.fromStream(response);

    log.i(
        '|📒📒📒|-----------------[[ POST ]] method response start ------------------|📒📒📒|');

    log.i(res.body.toString());

    if (hasLoader) {
      // Hide loader if necessary
    }

    switch (res.statusCode) {
      case 200:
      case 201:
        var responseJson = jsonDecode(res.body.toString());
        return responseJson;
      case 400:
        var errorResponse = jsonDecode(res.body.toString());

        String message = errorResponse['message'];

        throw BadRequestException(message);
      case 401:
        _handleUnauthorized();
        throw UnauthorizedException();
      case 422:
        var errorResponse = jsonDecode(res.body.toString());
        Map<String, List<String>> errorMessages = {};

        if (errorResponse['data'] != null) {
          errorResponse['data'].forEach((field, errors) {
            errorMessages[field] = List<String>.from(errors);
          });
        }
        String formattedErrorMessages = errorMessages.entries.map((entry) {
          String field = entry.key;
          String errors = entry.value.join(', ');
          return '$field: $errors';
        }).join('\n');

        throw UnprocessableEntityException(formattedErrorMessages);

      case 403:
        throw CustomException('Forbidden');
      case 404:
        throw CustomException('Not Found');
      case 500:
        throw ServerException();
      default:
        throw CustomException(
            'Check your internet connection or try again later');
    }
  }
}

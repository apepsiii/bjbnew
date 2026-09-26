import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/transaction_item.dart';

class ApiService {
  static const String _tokenKey = 'bjb_jwt_token';

  // Domain URL Backend BJB
  static const String _defaultProductionUrl = 'https://bjb.gxa.my.id/api/v1';

  // Dynamic Base URL Generator (Dapat di-override via --dart-define=API_URL=http://...)
  static String get baseUrl {
    const String overrideUrl = String.fromEnvironment('API_URL');
    if (overrideUrl.isNotEmpty) {
      return overrideUrl;
    }

    return _defaultProductionUrl;
  }

  static const String _savedUsernameKey = 'bjb_saved_username';
  static const String _savedFullNameKey = 'bjb_saved_fullname';

  // Token management
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Session user persistence (Ingat User ALDI FIRNANDO setelah login pertama)
  static Future<void> saveRememberedUser(String username, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedUsernameKey, username);
    await prefs.setString(_savedFullNameKey, fullName);
  }

  static Future<Map<String, String>?> getRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_savedUsernameKey);
    final fullName = prefs.getString(_savedFullNameKey);
    if (username != null && username.isNotEmpty) {
      return {'username': username, 'fullName': fullName ?? username};
    }
    return null;
  }

  // Header helper dengan Bearer JWT
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // POST /api/v1/auth/login
  static Future<UserModel?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final token = body['data']['token'] as String;
          await saveToken(token);
          final userJson = body['data']['user'] as Map<String, dynamic>;
          final user = UserModel.fromJson(userJson);
          await saveRememberedUser(user.username, user.fullName);
          return user;
        }
      }
    } catch (e) {
      debugPrint('API Login error: $e');
    }
    return null;
  }

  // GET /api/v1/user/profile
  static Future<UserModel?> getProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          return UserModel.fromJson(body['data']);
        }
      }
    } catch (e) {
      debugPrint('API Profile error: $e');
    }
    return null;
  }

  // GET /api/v1/mutasi
  static Future<List<TransactionItem>> getMutasi({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{};
      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate;
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }

      final uri = Uri.parse('$baseUrl/mutasi').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List list = body['data'];
          return list.map((item) => TransactionItem.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint('API Mutasi error: $e');
    }
    return [];
  }

  // GET /api/v1/mutasi/periods
  static Future<List<Map<String, dynamic>>> getStatementPeriods() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/mutasi/periods'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List list = body['data'];
          return list.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      debugPrint('API Statement Periods error: $e');
    }
    return [];
  }

  // GET /api/v1/mutasi/download?id=X&start_date=Y&end_date=Z -> Downloads PDF file directly to local storage
  static Future<String?> downloadStatementPDF({
    int? statementId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{};
      if (statementId != null && statementId > 0) {
        queryParams['id'] = statementId.toString();
      }
      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate;
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }

      final uri = Uri.parse('$baseUrl/mutasi/download').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        final bytes = response.bodyBytes;
        Directory? dir;
        try {
          if (!kIsWeb && Platform.isAndroid) {
            dir = Directory('/storage/emulated/0/Download');
            if (!dir.existsSync()) {
              dir = await getExternalStorageDirectory();
            }
          } else if (!kIsWeb) {
            dir = await getApplicationDocumentsDirectory();
          }
        } catch (_) {
          dir = await getApplicationDocumentsDirectory();
        }

        final targetDir = dir ?? await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${targetDir.path}/Rekening_Koran_BJB_$timestamp.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return file.path;
      }
    } catch (e) {
      debugPrint('API Download PDF error: $e');
    }
    return null;
  }

  // POST /api/v1/mutasi/send-email
  static Future<bool> sendMutasiEmail({
    required String recipientEmail,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/mutasi/send-email'),
        headers: headers,
        body: jsonEncode({
          'recipient_email': recipientEmail,
          'start_date': startDate,
          'end_date': endDate,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['success'] == true;
      }
    } catch (e) {
      debugPrint('API sendMutasiEmail error: $e');
    }
    return false;
  }
}

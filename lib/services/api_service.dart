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

  // Production Domain URL (Dapat diatur via --dart-define=API_URL=https://...)
  static const String _defaultProductionUrl = 'https://api-digi.bankbjb.co.id/api/v1';

  // IP Lokal Wi-Fi Laptop Anda untuk Pengujian HP Fisik Tanpa Kabel USB
  static String customLocalIp = '192.168.1.100';

  // Dynamic Base URL Generator (Dev vs Production)
  static String get baseUrl {
    const String overrideUrl = String.fromEnvironment('API_URL');
    if (overrideUrl.isNotEmpty) {
      return overrideUrl;
    }

    const bool isRelease = bool.fromEnvironment('dart.vm.product');
    if (isRelease) {
      return _defaultProductionUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:8080/api/v1';
    }

    // Untuk HP Fisik via ADB Reverse USB Cable atau Android Emulator (10.0.2.2 / localhost)
    if (Platform.isAndroid || Platform.isIOS) {
      return 'http://localhost:8080/api/v1';
    }

    return 'http://localhost:8080/api/v1';
  }

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
          return UserModel.fromJson(userJson);
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

  // GET /api/v1/mutasi/download?id=X -> Downloads PDF file directly to local storage
  static Future<String?> downloadStatementPDF({int? statementId}) async {
    try {
      final headers = await _getHeaders();
      final queryParam = (statementId != null && statementId > 0) ? '?id=$statementId' : '';
      final uri = Uri.parse('$baseUrl/mutasi/download$queryParam');
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
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
}

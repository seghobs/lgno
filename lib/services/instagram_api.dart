import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../models/device_profile.dart';
import '../models/login_response.dart';

class InstagramAPI {
  late Dio dio;
  late DeviceProfile deviceProfile;
  String? waterfallId;
  String? mid;
  String? uuid;
  
  // API Base URL - Kendi backend'inizi buraya ekleyin
  static const String baseUrl = 'http://localhost:5000';
  
  InstagramAPI({DeviceProfile? profile}) {
    deviceProfile = profile ?? DeviceProfile.samsung23();
    const uuidGen = Uuid();
    uuid = uuidGen.v4();
    waterfallId = uuidGen.v4();
    mid = DeviceProfile.generateMid();
    
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/api/login',
        data: {
          'username': username,
          'password': password,
          'device_profile': deviceProfile.id,
          'use_saved_ids': false,
        },
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Server responded with error
        return LoginResponse.fromJson(e.response!.data);
      } else {
        // Connection error
        return LoginResponse(
          success: false,
          error: 'CONNECTION_ERROR',
          message: 'Bağlantı hatası: ${e.message}',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        error: 'UNKNOWN_ERROR',
        message: 'Bilinmeyen hata: $e',
      );
    }
  }

  Future<LoginResponse> handleCheckpoint(String code, Map<String, dynamic> checkpointData) async {
    try {
      final response = await dio.post(
        '/api/checkpoint',
        data: {
          'code': code,
          'checkpoint_data': checkpointData,
        },
      );

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      return LoginResponse(
        success: false,
        error: 'CHECKPOINT_ERROR',
        message: 'Doğrulama hatası: $e',
      );
    }
  }

  Future<List<DeviceProfile>> getDeviceProfiles() async {
    try {
      final response = await dio.get('/api/device-profiles');
      
      final profiles = (response.data['profiles'] as List)
          .map((p) => DeviceProfile(
                id: p['id'],
                name: p['name'],
                deviceId: DeviceProfile.generateUuid(),
                androidId: DeviceProfile.generateAndroidId(),
                phoneId: DeviceProfile.generateUuid(),
                manufacturer: p['manufacturer'] ?? '',
                model: p['model'],
                device: p['device'] ?? '',
                androidVersion: p['android_version'] ?? '',
                androidRelease: p['android_release'] ?? '',
                cpu: p['cpu'] ?? '',
                resolution: p['resolution'],
                dpi: p['dpi'] ?? '',
                userAgent: p['user_agent'] ?? '',
                capabilities: '3brTv10=',
                connectionType: 'WIFI',
                bandwidthKbps: p['bandwidth_kbps'] ?? '8000',
              ))
          .toList();
      
      return profiles;
    } catch (e) {
      // Fallback to local profiles if API fails
      return DeviceProfile.getAllProfiles();
    }
  }

  Future<Map<String, dynamic>?> getSession() async {
    try {
      final response = await dio.get('/api/session');
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await dio.post('/api/logout');
      return response.data['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getSavedTokens() async {
    try {
      final response = await dio.get('/api/saved-tokens');
      return List<Map<String, dynamic>>.from(response.data['tokens'] ?? []);
    } catch (e) {
      return [];
    }
  }

  void updateBaseUrl(String newUrl) {
    dio.options.baseUrl = newUrl;
  }
}
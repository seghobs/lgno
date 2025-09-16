import 'dart:math';
import 'package:uuid/uuid.dart';

class DeviceProfile {
  final String id;
  final String name;
  final String deviceId;
  final String androidId;
  final String phoneId;
  final String manufacturer;
  final String model;
  final String device;
  final String androidVersion;
  final String androidRelease;
  final String cpu;
  final String resolution;
  final String dpi;
  final String userAgent;
  final String capabilities;
  final String connectionType;
  final String bandwidthKbps;

  DeviceProfile({
    required this.id,
    required this.name,
    required this.deviceId,
    required this.androidId,
    required this.phoneId,
    required this.manufacturer,
    required this.model,
    required this.device,
    required this.androidVersion,
    required this.androidRelease,
    required this.cpu,
    required this.resolution,
    required this.dpi,
    required this.userAgent,
    required this.capabilities,
    required this.connectionType,
    required this.bandwidthKbps,
  });

  static String generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static String generateAndroidId() {
    final random = Random();
    const chars = '0123456789abcdef';
    final hex = List.generate(16, (index) => chars[random.nextInt(16)]).join();
    return 'android-$hex';
  }

  static String generateMid() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    final mid = List.generate(27, (index) => chars[random.nextInt(chars.length)]).join();
    return 'X$mid=';
  }

  factory DeviceProfile.samsung23() {
    return DeviceProfile(
      id: 'samsung_s23',
      name: 'Samsung Galaxy S23 Ultra',
      deviceId: generateUuid(),
      androidId: generateAndroidId(),
      phoneId: generateUuid(),
      manufacturer: 'samsung',
      model: 'SM-S918B',
      device: 'dm3q',
      androidVersion: '34',
      androidRelease: '14',
      cpu: 'qcom',
      resolution: '1440x3088',
      dpi: '560dpi',
      userAgent: 'Instagram 396.0.0.46.242 Android (34/14; 560dpi; 1440x3088; samsung; SM-S918B; dm3q; qcom; tr_TR; 785863906)',
      capabilities: '3brTv10=',
      connectionType: 'WIFI',
      bandwidthKbps: '8500',
    );
  }

  factory DeviceProfile.pixel8Pro() {
    return DeviceProfile(
      id: 'pixel_8_pro',
      name: 'Google Pixel 8 Pro',
      deviceId: generateUuid(),
      androidId: generateAndroidId(),
      phoneId: generateUuid(),
      manufacturer: 'Google',
      model: 'Pixel 8 Pro',
      device: 'husky',
      androidVersion: '34',
      androidRelease: '14',
      cpu: 'tensor_g3',
      resolution: '1344x2992',
      dpi: '480dpi',
      userAgent: 'Instagram 396.0.0.46.242 Android (34/14; 480dpi; 1344x2992; Google; Pixel 8 Pro; husky; tensor_g3; tr_TR; 785863906)',
      capabilities: '3brTv10=',
      connectionType: 'WIFI',
      bandwidthKbps: '9000',
    );
  }

  factory DeviceProfile.xiaomi13() {
    return DeviceProfile(
      id: 'xiaomi_13',
      name: 'Xiaomi 13 Pro',
      deviceId: generateUuid(),
      androidId: generateAndroidId(),
      phoneId: generateUuid(),
      manufacturer: 'Xiaomi',
      model: '2210132C',
      device: 'nuwa',
      androidVersion: '33',
      androidRelease: '13',
      cpu: 'qcom',
      resolution: '1440x3200',
      dpi: '560dpi',
      userAgent: 'Instagram 396.0.0.46.242 Android (33/13; 560dpi; 1440x3200; Xiaomi; 2210132C; nuwa; qcom; tr_TR; 785863906)',
      capabilities: '3brTv10=',
      connectionType: 'WIFI',
      bandwidthKbps: '8000',
    );
  }

  static List<DeviceProfile> getAllProfiles() {
    return [
      DeviceProfile.samsung23(),
      DeviceProfile.pixel8Pro(),
      DeviceProfile.xiaomi13(),
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'device_id': deviceId,
      'android_id': androidId,
      'phone_id': phoneId,
      'manufacturer': manufacturer,
      'model': model,
      'device': device,
      'android_version': androidVersion,
      'android_release': androidRelease,
      'cpu': cpu,
      'resolution': resolution,
      'dpi': dpi,
      'user_agent': userAgent,
      'capabilities': capabilities,
      'connection_type': connectionType,
      'bandwidth_kbps': bandwidthKbps,
      'mid': generateMid(),
    };
  }
}
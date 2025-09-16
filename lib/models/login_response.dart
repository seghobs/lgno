class LoginResponse {
  final bool success;
  final String? token;
  final String? error;
  final String? message;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? deviceInfo;

  LoginResponse({
    required this.success,
    this.token,
    this.error,
    this.message,
    this.userData,
    this.deviceInfo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      token: json['token'],
      error: json['error'],
      message: json['message'],
      userData: json['user_data'],
      deviceInfo: json['device_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'error': error,
      'message': message,
      'user_data': userData,
      'device_info': deviceInfo,
    };
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response.dart';
import '../services/instagram_api.dart';

class DashboardScreen extends StatefulWidget {
  final LoginResponse loginResponse;
  final String username;

  const DashboardScreen({
    Key? key,
    required this.loginResponse,
    required this.username,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isTokenVisible = false;
  List<Map<String, dynamic>> _savedTokens = [];
  
  @override
  void initState() {
    super.initState();
    _saveToken();
    _loadSavedTokens();
  }

  Future<void> _saveToken() async {
    if (widget.loginResponse.token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_token', widget.loginResponse.token!);
      await prefs.setString('last_username', widget.username);
      await prefs.setString('last_login_time', DateTime.now().toIso8601String());
    }
  }

  Future<void> _loadSavedTokens() async {
    final api = InstagramAPI();
    final tokens = await api.getSavedTokens();
    setState(() {
      _savedTokens = tokens;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: "Kopyalandı! 📋",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  Widget _buildInfoCard(String title, String? value, IconData icon, {bool isToken = false}) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: value != null ? () => _copyToClipboard(value) : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade400,
                          Colors.pink.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isToken) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _isTokenVisible 
                                    ? (value ?? 'Token yok')
                                    : '••••••••••••••••••••',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'monospace',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isTokenVisible 
                                    ? Icons.visibility_off 
                                    : Icons.visibility,
                                  color: Colors.white60,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isTokenVisible = !_isTokenVisible;
                                  });
                                },
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            value ?? 'Bilgi yok',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (value != null)
                    Icon(
                      Icons.copy,
                      color: Colors.white.withOpacity(0.5),
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfoSection() {
    final deviceInfo = widget.loginResponse.deviceInfo;
    if (deviceInfo == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '📱 Cihaz Bilgileri',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildInfoCard('Cihaz', deviceInfo['model'], Icons.phone_android),
        _buildInfoCard('Android Versiyon', deviceInfo['android_release'], Icons.android),
        _buildInfoCard('Çözünürlük', deviceInfo['resolution'], Icons.aspect_ratio),
        _buildInfoCard('Device ID', deviceInfo['device_id'], Icons.fingerprint),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
              Color(0xFF533483),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Dashboard',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, color: Colors.green, size: 10),
                          const SizedBox(width: 5),
                          Text(
                            'Aktif',
                            style: TextStyle(
                              color: Colors.green.shade300,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Success Card
                      FadeInDown(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade600.withOpacity(0.3),
                                Colors.green.shade800.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Giriş Başarılı!',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '@$widget.username',
                                      style: TextStyle(
                                        color: Colors.green.shade200,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // User Info Section
                      Text(
                        '👤 Kullanıcı Bilgileri',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      _buildInfoCard('Kullanıcı Adı', widget.username, Icons.person),
                      _buildInfoCard(
                        'Bearer Token', 
                        widget.loginResponse.token, 
                        Icons.key,
                        isToken: true,
                      ),
                      
                      if (widget.loginResponse.userData != null) ...[
                        _buildInfoCard(
                          'User ID', 
                          widget.loginResponse.userData!['pk']?.toString(),
                          Icons.badge,
                        ),
                      ],

                      // Device Info Section
                      _buildDeviceInfoSection(),

                      // Saved Tokens Section
                      if (_savedTokens.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          '💾 Kayıtlı Token\'lar',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ..._savedTokens.map((token) => _buildInfoCard(
                          token['username'] ?? 'Unknown',
                          token['modified'] ?? '',
                          Icons.history,
                        )),
                      ],

                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final api = InstagramAPI();
                                await api.logout();
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('Çıkış Yap'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Settings page
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text('Ayarlar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/instagram_api.dart';
import '../models/device_profile.dart';
import '../models/login_response.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  DeviceProfile? _selectedDevice;
  List<DeviceProfile> _deviceProfiles = [];
  
  late AnimationController _gradientController;
  late Animation<Alignment> _topAlignment;
  late Animation<Alignment> _bottomAlignment;

  @override
  void initState() {
    super.initState();
    _loadDeviceProfiles();
    _setupAnimations();
  }

  void _setupAnimations() {
    _gradientController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _topAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_gradientController);

    _bottomAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_gradientController);
  }

  Future<void> _loadDeviceProfiles() async {
    setState(() {
      _deviceProfiles = DeviceProfile.getAllProfiles();
      _selectedDevice = _deviceProfiles.first;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final api = InstagramAPI(profile: _selectedDevice);
    final response = await api.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      Fluttertoast.showToast(
        msg: "Giriş başarılı! ✅",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              loginResponse: response,
              username: _usernameController.text,
            ),
          ),
        );
      }
    } else {
      String errorMessage = _getErrorMessage(response.error ?? 'UNKNOWN');
      
      if (response.error == 'CHECKPOINT_REQUIRED') {
        _showCheckpointDialog();
      } else if (response.error == '2FA_REQUIRED') {
        _show2FADialog();
      } else {
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  String _getErrorMessage(String error) {
    switch (error) {
      case '2FA_REQUIRED':
        return 'İki faktörlü doğrulama gerekiyor 🔐';
      case 'CHECKPOINT_REQUIRED':
        return 'Güvenlik kontrolü gerekiyor 🛡️';
      case 'INVALID_PASSWORD':
        return 'Şifre yanlış ❌';
      case 'INVALID_USER':
        return 'Kullanıcı bulunamadı ❌';
      case 'CONNECTION_ERROR':
        return 'Bağlantı hatası 📡';
      default:
        return 'Giriş başarısız ❌';
    }
  }

  void _showCheckpointDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          '🛡️ Güvenlik Kontrolü',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Instagram güvenlik kodu gönderdi.\nEmail veya SMS\'e gelen kodu girin:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '6 haneli kod',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement checkpoint verification
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Doğrula'),
          ),
        ],
      ),
    );
  }

  void _show2FADialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          '🔐 İki Faktörlü Doğrulama',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Authenticator uygulamanızdaki kodu girin:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '6 haneli kod',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement 2FA verification
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Doğrula'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _topAlignment.value,
                end: _bottomAlignment.value,
                colors: const [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0f3460),
                  Color(0xFF533483),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade600,
                                  Colors.pink.shade600,
                                  Colors.orange.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          child: Text(
                            'Instagram Login',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInDown(
                          delay: const Duration(milliseconds: 400),
                          child: Text(
                            'Mobile API Interface',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeInLeft(
                          delay: const Duration(milliseconds: 600),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Kullanıcı Adı',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                prefixIcon: const Icon(Icons.person, color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(20),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kullanıcı adı gerekli';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInRight(
                          delay: const Duration(milliseconds: 800),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Şifre',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(20),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Şifre gerekli';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInLeft(
                          delay: const Duration(milliseconds: 1000),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<DeviceProfile>(
                                value: _selectedDevice,
                                isExpanded: true,
                                dropdownColor: Colors.grey[900],
                                icon: const Icon(Icons.phone_android, color: Colors.white70),
                                style: const TextStyle(color: Colors.white),
                                items: _deviceProfiles.map((device) {
                                  return DropdownMenuItem(
                                    value: device,
                                    child: Text(
                                      device.name,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDevice = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1200),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade600,
                                      Colors.pink.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 25,
                                        )
                                      : Text(
                                          'GİRİŞ YAP',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
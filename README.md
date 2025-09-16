# Instagram Login Flutter App 📱

Modern ve şık bir Instagram Mobile API Login uygulaması. Dark gradient tonlarında tasarlanmış Flutter uygulaması.

## 🚀 Özellikler

- ✨ Modern dark gradient arayüz
- 📱 Farklı cihaz profilleri desteği (Samsung S23, Pixel 8 Pro, Xiaomi 13)
- 🔐 Güvenli login işlemi
- 🛡️ Checkpoint ve 2FA desteği
- 💾 Token kaydetme ve yönetimi
- 🎨 Animasyonlu UI elementleri
- 📋 Token kopyalama özelliği

## 📦 Kurulum

### 1. Flutter SDK Kurulumu
Flutter'ın sisteminizde kurulu olduğundan emin olun:
```bash
flutter --version
```

Eğer kurulu değilse: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

### 2. Proje Bağımlılıkları
Proje klasöründe aşağıdaki komutu çalıştırın:
```bash
flutter pub get
```

### 3. Backend Kurulumu
Bu uygulama Python Flask backend'i ile çalışır. Backend'i çalıştırmak için:

1. Ana klasördeki Python dosyalarını (`app.py` ve `main.py`) çalıştırın:
```bash
python app.py
```

2. Backend varsayılan olarak `http://localhost:5000` adresinde çalışır.

### 4. API URL Ayarları
`lib/services/instagram_api.dart` dosyasındaki `baseUrl` değişkenini backend adresinize göre güncelleyin:
```dart
static const String baseUrl = 'http://localhost:5000';
```

## 🎮 Kullanım

### Uygulamayı Çalıştırma
```bash
flutter run
```

### Web için çalıştırma:
```bash
flutter run -d chrome
```

### Android için build:
```bash
flutter build apk
```

### iOS için build:
```bash
flutter build ios
```

## 🎨 Uygulama Ekranları

### 1. Login Ekranı
- Kullanıcı adı ve şifre girişi
- Cihaz profili seçimi
- Animasyonlu gradient arkaplan
- Şifre göster/gizle özelliği

### 2. Dashboard Ekranı
- Başarılı giriş sonrası bilgiler
- Bearer token gösterimi
- Cihaz bilgileri
- Token kopyalama
- Çıkış yapma

## 🛠️ Teknolojiler

- **Flutter**: UI Framework
- **Dart**: Programming Language
- **Dio**: HTTP istekleri
- **Provider**: State management
- **SharedPreferences**: Local storage
- **Google Fonts**: Typography
- **Animate Do**: Animasyonlar
- **Flutter SpinKit**: Loading animasyonları

## 📁 Proje Yapısı

```
instagram_login_app/
├── lib/
│   ├── main.dart              # Ana uygulama dosyası
│   ├── models/                # Data modelleri
│   │   ├── device_profile.dart
│   │   └── login_response.dart
│   ├── services/              # API servisleri
│   │   └── instagram_api.dart
│   ├── screens/               # UI ekranları
│   │   ├── login_screen.dart
│   │   └── dashboard_screen.dart
│   ├── widgets/               # Özel widget'lar
│   └── utils/                 # Yardımcı fonksiyonlar
├── pubspec.yaml              # Proje bağımlılıkları
└── README.md                 # Bu dosya
```

## 🔒 Güvenlik Notları

- Şifreler güvenli bir şekilde şifrelenerek gönderilir
- Token'lar local storage'da güvenli şekilde saklanır
- Hassas bilgiler UI'da maskelenir

## 🚨 Dikkat

- Bu uygulama sadece eğitim amaçlıdır
- Instagram'ın resmi API'sini kullanmaz
- Kullanım riski size aittir
- Hesap güvenliği için 2FA kullanmanız önerilir

## 📝 Lisans

MIT License

## 🤝 Katkıda Bulunma

Pull request'ler kabul edilir. Büyük değişiklikler için önce bir issue açın.

## 📞 İletişim

Sorularınız için issue açabilirsiniz.

---

**Not**: Backend server'ın çalıştığından emin olun. Aksi takdirde login işlemleri başarısız olacaktır.
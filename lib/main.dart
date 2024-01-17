import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'ana_ekran.dart'; // Yeni oluşturulan AnaEkran widget'ını içe aktarıyoruz
import 'package:flutter_localizations/flutter_localizations.dart'; // Yerelleştirme için gerekli paket

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sağlık Çalışanları Nöbet Çizelgesi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      // Yerelleştirme desteği ekliyoruz
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // iOS için yerelleştirme desteği
      ],
      supportedLocales: [
        const Locale('tr', 'TR'), // Türkçe
        // Buraya diğer desteklenen dilleri ekleyebilirsiniz.
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Zamanlayıcı ile 5 saniye sonra AnaEkran'a geçiş yap
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AnaEkran()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Yükleniyor...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Bu uygulama tüm sağlık çalışanları için\nLütfi Çelik tarafından ücretsiz olarak tasarlanmıştır.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

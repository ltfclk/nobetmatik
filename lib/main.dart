import 'package:flutter/material.dart';
import 'dart:async';
import 'ana_ekran.dart'; // AnaEkran widget'ını içe aktarıyoruz
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
        GlobalCupertinoLocalizations.delegate,
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
    // Zamanlayıcı ile 1 saniye sonra AnaEkran'a geçiş yap
    Timer(Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AnaEkran()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan rengini kaldırıyoruz çünkü artık arka plan resmi kullanacağız.
      body: Container( // Container widget'ı ekleniyor.
        decoration: BoxDecoration( // BoxDecoration ile arka plana resim ekleniyor.
          image: DecorationImage(
            image: AssetImage('assets/openings/opening.jpg'), // Resim yolu
            fit: BoxFit.cover, // Resmin uygun şekilde kaplamasını sağlıyoruz.
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Yükleniyor...',
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personel Listesi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Personeller(),
    );
  }
}

class Personeller extends StatefulWidget {
  @override
  _PersonellerState createState() => _PersonellerState();
}

class _PersonellerState extends State<Personeller> {
  final TextEditingController _yeniPersonelSayisiController = TextEditingController();
  List<TextEditingController> _isimControllers = [];

  @override
  void initState() {
    super.initState();
    _kayitliPersonelleriYukle();
  }

  void _kayitliPersonelleriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> kayitliIsimler = prefs.getStringList('kayitliPersoneller') ?? [];
    setState(() {
      _isimControllers = kayitliIsimler.map((isim) => TextEditingController(text: isim)).toList();
    });
  }

  @override
  void dispose() {
    _yeniPersonelSayisiController.dispose();
    for (var controller in _isimControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _yeniPersonelEklemeSayisiOnayla() {
    final int eklenecekPersonelSayisi = int.tryParse(_yeniPersonelSayisiController.text) ?? 0;
    setState(() {
      for (int i = 0; i < eklenecekPersonelSayisi; i++) {
        _isimControllers.add(TextEditingController());
      }
    });
  }

  void _personelleriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> isimler = _isimControllers.map((controller) => controller.text).toList();
    await prefs.setStringList('kayitliPersoneller', isimler);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Personeller kaydedildi!')));
  }

  void _tumPersonelleriSil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('kayitliPersoneller');
    setState(() {
      _isimControllers.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tüm personeller silindi!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personel Listesi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _yeniPersonelSayisiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Eklenecek Personel Sayısı',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _yeniPersonelEklemeSayisiOnayla,
              child: Text(
                'Yeni Personel Ekle',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            ElevatedButton(
              onPressed: _tumPersonelleriSil,
              child: Text(
                'Personel Listesini Sil',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            ..._isimControllers.map((controller) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Personel İsmi',
                  border: OutlineInputBorder(),
                ),
              ),
            )).toList(),
            if (_isimControllers.isNotEmpty) ElevatedButton(
              onPressed: _personelleriKaydet,
              child: Text(
                'Değişiklikleri Kaydet',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

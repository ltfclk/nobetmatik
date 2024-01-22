import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Personel Listesi',
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
    if (_isimControllers.any((controller) => controller.text.trim().isEmpty)) {
      // Eğer herhangi bir personel ismi girilmemişse hata göster
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Hata'),
          content: Text('Lütfen tüm personel isimlerini giriniz.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Tamam'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    List<String> isimler = _isimControllers.map((controller) => controller.text).toList();
    await prefs.setStringList('kayitliPersoneller', isimler);
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Kayıt Başarılı'),
        content: Text('Personeller kaydedildi!'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Tamam'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _tumPersonelleriSil() async {
    setState(() {
      _isimControllers.clear();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('kayitliPersoneller');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Personel Listesi'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.trash),
          onPressed: _tumPersonelleriSil,
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder( // LayoutBuilder widget'ı eklendi.
          builder: (context, constraints) {
            // Burada ekranın genişliğine göre bir responsive tasarım yapılıyor.
            double padding = constraints.maxWidth > 600 ? constraints.maxWidth * 0.1 : 8.0;

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: CupertinoTextField(
                      controller: _yeniPersonelSayisiController,
                      keyboardType: TextInputType.number,
                      placeholder: 'Eklenecek Personel Sayısı',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: CupertinoButton(
                            onPressed: _yeniPersonelEklemeSayisiOnayla,
                            color: CupertinoColors.activeBlue,
                            child: Text('Ekle'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: CupertinoButton(
                            onPressed: _personelleriKaydet,
                            color: CupertinoColors.activeBlue,
                            child: Text('Kaydet'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var controller in _isimControllers)
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: CupertinoTextField(
                        controller: controller,
                        placeholder: 'Personel İsmi',
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

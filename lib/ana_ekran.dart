import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'liste_hazirla.dart';
import 'personeller.dart';
import 'gun_ayari.dart';
import 'kesin_gun.dart';
import 'vardiya_secimi.dart';
import 'vardiya_kisi_sayfasi.dart';
// Diğer ekranlarınızın importlarını buraya ekleyin.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  int kayitliPersonelSayisi = 0;
  String kayitliTarih = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _kayitliPersonelSayisiniGetir();
      _kayitliTarihiGetir();
    });
  }


  void _kayitliPersonelSayisiniGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final kayitliPersoneller = prefs.getStringList('kayitliPersoneller') ?? [];
    setState(() {
      kayitliPersonelSayisi = kayitliPersoneller.length;
    });
  }

  void _kayitliTarihiGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final int? year = prefs.getInt('year');
    final int? month = prefs.getInt('month');
    setState(() {
      kayitliTarih = (year != null && month != null) ? '$month/$year' : 'Ay/Yıl seçilmedi';
    });
  }

  Widget _buildCupertinoButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoButtonWithCounter(BuildContext context, String text, IconData icon, int counter, String counterText, VoidCallback onPressed) {
    return Expanded(
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              counterText,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Nöbetmatik'),
      ),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  _buildCupertinoButtonWithCounter(context, 'Liste Tarihi Seç', CupertinoIcons.calendar, kayitliPersonelSayisi, 'Seçili Tarih: $kayitliTarih', () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ListeHazirla())).then((_) => _kayitliTarihiGetir());
                  }),
                  _buildCupertinoButtonWithCounter(context, 'Personel Listesi', CupertinoIcons.person_2_fill, kayitliPersonelSayisi, '$kayitliPersonelSayisi kayıtlı personel', () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Personeller())).then((_) => _kayitliPersonelSayisiniGetir());
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  _buildCupertinoButton(context, 'Personel İzin Yönetimi', CupertinoIcons.time, () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => GunAyari()));
                  }),
                  _buildCupertinoButton(context, 'Kesin Çalışma Günü', CupertinoIcons.calendar_today, () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => KesinGun()));
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  _buildCupertinoButton(context, 'Vardiya Seçimi', CupertinoIcons.calendar_badge_plus, () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => VardiyaSecimi())); // Buton 5'e basıldığında yapılacak işlemler
                  }),
                  _buildCupertinoButton(context, 'Vardiya Kişi Sayısı', CupertinoIcons.clock_fill, () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => VardiyaKisiSayfasi()));
                  }),
                ],
              ),
            ),
            // Yeni eklenen butonlar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  _buildCupertinoButton(context, 'Vardiyaya Personel Ata', CupertinoIcons.add, () {
                    // Navigator.of(context).push(CupertinoPageRoute(builder: (context) => YeniEkran7()));
                    // TODO: Yeni Ekran 7 navigasyon işlemini buraya ekleyin
                  }),
                  _buildCupertinoButton(context, 'Yeni Ekran 8', CupertinoIcons.add_circled, () {
                    // Navigator.of(context).push(CupertinoPageRoute(builder: (context) => YeniEkran8()));
                    // TODO: Yeni Ekran 8 navigasyon işlemini buraya ekleyin
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
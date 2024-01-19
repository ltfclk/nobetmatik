import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'liste_hazirla.dart';
import 'personeller.dart';
import 'gun_ayari.dart';

class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  int kayitliPersonelSayisi = 0;

  @override
  void initState() {
    super.initState();
    _kayitliPersonelSayisiniGetir();
  }

  void _kayitliPersonelSayisiniGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final kayitliPersoneller = prefs.getStringList('kayitliPersoneller') ?? [];
    setState(() {
      kayitliPersonelSayisi = kayitliPersoneller.length;
    });
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
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
    );
  }

  Widget _buildButtonWithCounter(BuildContext context, String text, IconData icon, int counter, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
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
            '$counter kayıtlı personel',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ekran boyutuna göre crossAxisCount değerini belirle
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    // Ekran boyutuna göre childAspectRatio değerini belirle
    double childAspectRatio = (MediaQuery.of(context).size.width / crossAxisCount) / (MediaQuery.of(context).size.height / (crossAxisCount + 1));

    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Ekran'),
      ),
      body: GridView.count(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          _buildButton(context, 'Liste Tarihi Seç', Icons.date_range, () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListeHazirla()));
          }),
          _buildButtonWithCounter(context, 'Personel Listesi', Icons.list, kayitliPersonelSayisi, () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Personeller())).then((_) => _kayitliPersonelSayisiniGetir());
          }),
          _buildButton(context, 'Personel Gün Ayarı', Icons.calendar_today, () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GunAyari()));
          }),
          _buildButton(context, 'Buton 4', Icons.add_circle_outline, () {
            // Buton 4'e basıldığında yapılacak işlem
          }),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: AnaEkran()));

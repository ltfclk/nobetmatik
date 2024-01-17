import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'liste_hazirla.dart';
import 'personeller.dart';

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

  Widget _buildButton(BuildContext context, String text, double size, VoidCallback onPressed) {
    return Container(
      height: size,
      width: size,
      child: Card(
        color: Colors.blue,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithCounter(BuildContext context, String text, double size, int counter, VoidCallback onPressed) {
    return Container(
      height: size,
      width: size,
      child: Card(
        color: Colors.blue,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4), // Yazılar arasında boşluk bırak
                Text(
                  '$counter kayıtlı personel', // Personel sayısını göster
                  style: TextStyle(
                    color: Colors.white70, // Alt yazı için daha soluk bir renk kullan
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = (MediaQuery.of(context).size.width / 2) - 16;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Ekran'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          _buildButton(context, 'Liste Tarihi Seç', buttonSize, () {
            // Liste Hazırla sayfasına yönlendirme
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListeHazirla()));
          }),
          _buildButtonWithCounter(context, 'Personel Listesi', buttonSize, kayitliPersonelSayisi, () {
            // Personeller sayfasına yönlendirme ve dönüşte personel sayısını güncelleme
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Personeller())).then((_) => _kayitliPersonelSayisiniGetir());
          }),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: AnaEkran()));

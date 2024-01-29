import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VardiyaKisiSayfasi extends StatefulWidget {
  @override
  _VardiyaKisiSayfasiState createState() => _VardiyaKisiSayfasiState();
}

class _VardiyaKisiSayfasiState extends State<VardiyaKisiSayfasi> {
  int haftaIciVardiyaSayisi = 0;
  int haftaSonuVardiyaSayisi = 0;
  int resmiTatilVardiyaSayisi = 0;
  List<String> haftaIciVardiyaSaatleri = [];
  List<String> haftaSonuVardiyaSaatleri = [];
  List<String> resmiTatilVardiyaSaatleri = [];

  @override
  void initState() {
    super.initState();
    _loadVardiyaData();
  }

  _loadVardiyaData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      haftaIciVardiyaSayisi = prefs.getInt('haftaIciVardiyaSayisi') ?? 0;
      haftaSonuVardiyaSayisi = prefs.getInt('haftaSonuVardiyaSayisi') ?? 0;
      resmiTatilVardiyaSayisi = prefs.getInt('resmiTatilVardiyaSayisi') ?? 0;

      haftaIciVardiyaSaatleri = List.generate(haftaIciVardiyaSayisi,
              (i) => prefs.getString('haftaIciVardiya$i') ?? '');
      haftaSonuVardiyaSaatleri = List.generate(haftaSonuVardiyaSayisi,
              (i) => prefs.getString('haftaSonuVardiya$i') ?? '');
      resmiTatilVardiyaSaatleri = List.generate(resmiTatilVardiyaSayisi,
              (i) => prefs.getString('resmiTatilVardiya$i') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Vardiya Kişi Sayısı'),
        previousPageTitle: 'Geri',
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle(context, 'Hafta İçi Vardiyalar'),
                  buildVardiyaListesi(context, haftaIciVardiyaSaatleri),
                  buildSectionTitle(context, 'Hafta Sonu Vardiyalar'),
                  buildVardiyaListesi(context, haftaSonuVardiyaSaatleri),
                  buildSectionTitle(context, 'Resmi Tatil Vardiyalar'),
                  buildVardiyaListesi(context, resmiTatilVardiyaSaatleri),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: CupertinoTheme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget buildVardiyaListesi(BuildContext context, List<String> vardiyalar) {
    if (vardiyalar.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          'Kayıtlı vardiya yok.',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: vardiyalar.map((saat) => Text(
        saat,
        style: TextStyle(
          fontSize: 18.0,
          color: CupertinoColors.black,
        ),
      )).toList(),
    );
  }
}

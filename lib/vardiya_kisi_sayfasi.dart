import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: VardiyaKisiSayfasi(),
    );
  }
}

class VardiyaKisiSayfasi extends StatefulWidget {
  @override
  _VardiyaKisiSayfasiState createState() => _VardiyaKisiSayfasiState();
}

class _VardiyaKisiSayfasiState extends State<VardiyaKisiSayfasi> {
  List<String> tumVardiyalar = [];

  @override
  void initState() {
    super.initState();
    _loadVardiyalar();
  }

  Future<void> _loadVardiyalar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Vardiyaları yükle ve türlerine göre sırala
    List<String> haftaIciVardiyalar = _loadVardiyaTuru(prefs, 'haftaIciVardiya', 'Haftaiçi ');
    List<String> haftaSonuVardiyalar = _loadVardiyaTuru(prefs, 'haftaSonuVardiya', 'Haftasonu ');
    List<String> resmiTatilVardiyalar = _loadVardiyaTuru(prefs, 'resmiTatilVardiya', 'Resmi Tatil ');

    // Vardiyaları birleştir ve saatlerine göre sırala
    setState(() {
      tumVardiyalar = [...haftaIciVardiyalar, ...haftaSonuVardiyalar, ...resmiTatilVardiyalar]
        ..sort((a, b) => a.compareTo(b));
    });
  }

  List<String> _loadVardiyaTuru(SharedPreferences prefs, String key, String prefix) {
    final int count = prefs.getInt('${key}Sayisi') ?? 0;
    return List.generate(
      count,
          (i) => '$prefix${i + 1}. Vardiya: ${prefs.getString('$key$i') ?? ''}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Vardiya Listesi'),
      ),
      child: SafeArea(
        child: ListView.builder(
          itemCount: tumVardiyalar.length,
          itemBuilder: (context, index) {
            return VardiyaWidget(tumVardiyalar[index]);
          },
        ),
      ),
    );
  }

  Widget VardiyaWidget(String vardiya) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      child: Text(vardiya, style: CupertinoTheme.of(context).textTheme.textStyle),
    );
  }
}

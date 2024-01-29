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
  List<String> haftaIciVardiyalar = [];
  List<String> haftaSonuVardiyalar = [];
  List<String> resmiTatilVardiyalar = [];

  @override
  void initState() {
    super.initState();
    _loadVardiyalar();
  }

  Future<void> _loadVardiyalar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Vardiya sayılarını al (varsayılan olarak 0)
    final int haftaIciVardiyaSayisi = prefs.getInt('haftaIciVardiyaSayisi') ?? 0;
    final int haftaSonuVardiyaSayisi = prefs.getInt('haftaSonuVardiyaSayisi') ?? 0;
    final int resmiTatilVardiyaSayisi = prefs.getInt('resmiTatilVardiyaSayisi') ?? 0;

    // Vardiyaları yükle
    setState(() {
      haftaIciVardiyalar = List.generate(
        haftaIciVardiyaSayisi,
            (i) => prefs.getString('haftaIciVardiya$i') ?? '',
      );
      haftaSonuVardiyalar = List.generate(
        haftaSonuVardiyaSayisi,
            (i) => prefs.getString('haftaSonuVardiya$i') ?? '',
      );
      resmiTatilVardiyalar = List.generate(
        resmiTatilVardiyaSayisi,
            (i) => prefs.getString('resmiTatilVardiya$i') ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Vardiya Saatleri'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Haftaiçi Vardiyalar', style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => VardiyaWidget(haftaIciVardiyalar[index]),
                childCount: haftaIciVardiyalar.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Haftasonu Vardiyalar', style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => VardiyaWidget(haftaSonuVardiyalar[index]),
                childCount: haftaSonuVardiyalar.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Resmi Tatil Vardiyalar', style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => VardiyaWidget(resmiTatilVardiyalar[index]),
                childCount: resmiTatilVardiyalar.length,
              ),
            ),
          ],
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

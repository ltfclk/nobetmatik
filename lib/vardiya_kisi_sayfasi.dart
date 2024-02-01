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
  Map<String, int> vardiyaKisiSayilari = {}; // Vardiyalardaki kişi sayılarını tutan map

  @override
  void initState() {
    super.initState();
    _loadVardiyalar();
  }

  Future<void> _loadVardiyalar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Vardiyaları ve kişi sayılarını yükle
    List<String> haftaIciVardiyalar = _loadVardiyaTuru(prefs, 'haftaIciVardiya', 'Haftaiçi ');
    List<String> haftaSonuVardiyalar = _loadVardiyaTuru(prefs, 'haftaSonuVardiya', 'Haftasonu ');
    List<String> resmiTatilVardiyalar = _loadVardiyaTuru(prefs, 'resmiTatilVardiya', 'Resmi Tatil ');

    // Vardiyalardaki kişi sayılarını yükle
    vardiyaKisiSayilari = {
      for (var vardiya in [...haftaIciVardiyalar, ...haftaSonuVardiyalar, ...resmiTatilVardiyalar])
        vardiya: prefs.getInt('$vardiya Kisi Sayisi') ?? 0,
    };

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
            return VardiyaWidget(tumVardiyalar[index], vardiyaKisiSayilari[tumVardiyalar[index]] ?? 0);
          },
        ),
      ),
    );
  }

  // VardiyaWidget fonksiyonunuzu güncelleyin
  Widget VardiyaWidget(String vardiya, int kisiSayisi) {
    return Container(
      padding: EdgeInsets.all(8), // İç boşluk ekleyin
      margin: EdgeInsets.only(bottom: 8), // Altta boşluk bırakın
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey), // Kenarlık rengi
        borderRadius: BorderRadius.circular(8), // Kenarlık yuvarlaklığı
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vardiya, style: CupertinoTheme.of(context).textTheme.textStyle),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bu Vardiyada Çalışacak Kişi Sayısı: $kisiSayisi',
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 14)),
              CupertinoButton(
                child: Text('Düzenle'),
                onPressed: () => _showEditDialog(context, vardiya, kisiSayisi),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, String vardiya, int currentKisiSayisi) async {
    final TextEditingController _controller = TextEditingController(text: currentKisiSayisi.toString());
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Kişi Sayısını Düzenle'),
            content: CupertinoTextField(controller: _controller),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('İptal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('Kaydet'),
                onPressed: () async {
                  int newKisiSayisi = int.tryParse(_controller.text) ?? currentKisiSayisi;
                  await _saveKisiSayisi(vardiya, newKisiSayisi);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _saveKisiSayisi(String vardiya, int kisiSayisi) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$vardiya Kisi Sayisi', kisiSayisi);
    setState(() {
      vardiyaKisiSayilari[vardiya] = kisiSayisi;
    });
  }
}
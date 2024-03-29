import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GunAyari extends StatefulWidget {
  @override
  _GunAyariState createState() => _GunAyariState();
}

class _GunAyariState extends State<GunAyari> {
  List<String> _personelListesi = [];
  Map<String, List<DateTime>> _personelIzinGunleri = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ilkAcilisDialogGoster();
    });
    _kayitliPersonelleriYukle();
  }

  void _ilkAcilisDialogGoster() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Dikkat!'),
          content: Text('Lütfen bir personelin izin günleri ile kesin çalışma günlerini aynı seçmemeye dikkat edin.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _kayitliPersonelleriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? personeller = prefs.getStringList('kayitliPersoneller');
    if (personeller != null) {
      setState(() {
        _personelListesi = personeller;
      });
      _izinGunleriniYukle();
    }
  }

  void _izinGunleriniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    for (var personel in _personelListesi) {
      List<String>? izinGunleriStringListesi = prefs.getStringList('izinGunleri_$personel');
      if (izinGunleriStringListesi != null) {
        List<DateTime> izinGunleri = izinGunleriStringListesi
            .map((izinGunu) => DateTime.parse(izinGunu))
            .toList();
        setState(() {
          _personelIzinGunleri[personel] = izinGunleri;
        });
      }
    }
  }

  void _gunSecimiYap(String personel) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SfDateRangePicker(
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    if (args.value is List<DateTime>) {
                      setState(() {
                        _personelIzinGunleri[personel] = args.value;
                      });
                    }
                  },
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  initialSelectedDates: _personelIzinGunleri[personel],
                ),
              ),
              CupertinoButton(
                child: Text('Tamam'),
                onPressed: () async {
                  Navigator.pop(context);
                  final prefs = await SharedPreferences.getInstance();
                  List<String> izinGunleriString = _personelIzinGunleri[personel]!
                      .map((DateTime date) => date.toIso8601String())
                      .toList();
                  await prefs.setStringList('izinGunleri_$personel', izinGunleriString);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _tumIzinleriTemizle() async {
    final prefs = await SharedPreferences.getInstance();
    for (var personel in _personelListesi) {
      await prefs.remove('izinGunleri_$personel');
    }
    setState(() {
      _personelIzinGunleri.clear();
    });
  }

  String _izinGunleriniFormatla(List<DateTime>? izinGunleri) {
    if (izinGunleri == null || izinGunleri.isEmpty) return 'İzin günü yok';
    return izinGunleri.map((DateTime date) => '${date.day}').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Personel İzin Gün Ayarı'),
        backgroundColor: CupertinoColors.white,
        trailing: GestureDetector(
          onTap: _tumIzinleriTemizle,
          child: Text('Temizle', style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          itemCount: _personelListesi.length,
          itemBuilder: (context, index) {
            String personel = _personelListesi[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                border: Border(bottom: BorderSide(color: CupertinoColors.systemGrey)),
              ),
              child: CupertinoButton(
                onPressed: () => _gunSecimiYap(personel),
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        personel,
                        style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.black),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _izinGunleriniFormatla(_personelIzinGunleri[personel]),
                        style: TextStyle(color: CupertinoColors.black),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        CupertinoIcons.calendar,
                        color: CupertinoColors.systemPurple,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
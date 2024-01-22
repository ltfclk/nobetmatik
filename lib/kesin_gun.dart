import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class KesinGun extends StatefulWidget {
  @override
  _KesinGunState createState() => _KesinGunState();
}

class _KesinGunState extends State<KesinGun> {
  List<String> _personelListesi = [];
  Map<String, List<DateTime>> _personelKesinCalismaGunleri = {};

  @override
  void initState() {
    super.initState();
    _kayitliPersonelleriYukle();
  }

  void _kayitliPersonelleriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? personeller = prefs.getStringList('kayitliPersoneller');
    if (personeller != null) {
      setState(() {
        _personelListesi = personeller;
      });
      _kesinCalismaGunleriniYukle();
    }
  }

  void _kesinCalismaGunleriniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    for (var personel in _personelListesi) {
      List<String>? kesinCalismaGunleriStringListesi = prefs.getStringList('kesinCalismaGunleri_$personel');
      if (kesinCalismaGunleriStringListesi != null) {
        List<DateTime> kesinCalismaGunleri = kesinCalismaGunleriStringListesi
            .map((kesinCalismaGunu) => DateTime.parse(kesinCalismaGunu))
            .toList();
        setState(() {
          _personelKesinCalismaGunleri[personel] = kesinCalismaGunleri;
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
                        _personelKesinCalismaGunleri[personel] = args.value;
                      });
                    }
                  },
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  initialSelectedDates: _personelKesinCalismaGunleri[personel],
                ),
              ),
              CupertinoButton(
                child: Text('Tamam'),
                onPressed: () async {
                  Navigator.pop(context);
                  final prefs = await SharedPreferences.getInstance();
                  List<String> kesinCalismaGunleriString = _personelKesinCalismaGunleri[personel]!
                      .map((DateTime date) => date.toIso8601String())
                      .toList();
                  await prefs.setStringList('kesinCalismaGunleri_$personel', kesinCalismaGunleriString);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _tumKesinCalismalariTemizle() async {
    final prefs = await SharedPreferences.getInstance();
    for (var personel in _personelListesi) {
      await prefs.remove('kesinCalismaGunleri_$personel');
    }
    setState(() {
      _personelKesinCalismaGunleri.clear();
    });
  }

  String _kesinCalismaGunleriniFormatla(List<DateTime>? kesinCalismaGunleri) {
    if (kesinCalismaGunleri == null || kesinCalismaGunleri.isEmpty) return 'kesin çalışma günü girilmemiş';
    return kesinCalismaGunleri.map((DateTime date) => '${date.day}').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Kesin Çalışma Günü Belirle'),
        backgroundColor: CupertinoColors.white,
        trailing: GestureDetector(
          onTap: _tumKesinCalismalariTemizle,
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
                        _kesinCalismaGunleriniFormatla(_personelKesinCalismaGunleri[personel]),
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
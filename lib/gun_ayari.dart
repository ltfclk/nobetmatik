import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GunAyari extends StatefulWidget {
  @override
  _GunAyariState createState() => _GunAyariState();
}

class _GunAyariState extends State<GunAyari> {
  List<String> _personelListesi = [];
  List<DateTime> _secilenGunler = [];

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
    }
  }

  void _gunSecimiYap() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('İzinli Günleri Seç'),
          content: Container(
            height: 350,
            width: double.maxFinite,
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.multiple,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.pop(context);
                // Seçilen günleri kaydetme işlemi burada yapılabilir.
              },
            ),
          ],
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is List<DateTime>) {
        _secilenGunler = args.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personel Gün Ayarı'),
      ),
      body: ListView.builder(
        itemCount: _personelListesi.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_personelListesi[index]),
              trailing: ElevatedButton(
                onPressed: _gunSecimiYap,
                child: Text('Seç'),
              ),
            ),
          );
        },
      ),
    );
  }
}

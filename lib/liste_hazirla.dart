import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListeHazirla extends StatefulWidget {
  @override
  _ListeHazirlaState createState() => _ListeHazirlaState();
}

class _ListeHazirlaState extends State<ListeHazirla> {
  DateTime? secilenTarih;
  List<bool>? secilenGunler;
  List<String> secilenResmiTatiller = [];
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    prefs = await SharedPreferences.getInstance();
    int? year = prefs?.getInt('year');
    int? month = prefs?.getInt('month');
    List<String>? savedTatiller = prefs?.getStringList('tatiller');

    if (year != null && month != null) {
      setState(() {
        secilenTarih = DateTime(year, month);
        int gunSayisi = DateTime(year, month + 1, 0).day;
        secilenGunler = List.generate(gunSayisi, (index) => false);
        savedTatiller?.forEach((gun) {
          int gunIndex = int.parse(gun.split('.')[0]) - 1;
          secilenGunler![gunIndex] = true;
          secilenResmiTatiller.add(gun);
        });
      });
    }
  }

  void _saveData() async {
    await prefs?.setInt('year', secilenTarih!.year);
    await prefs?.setInt('month', secilenTarih!.month);
    await prefs?.setStringList('tatiller', secilenResmiTatiller);
  }

  void _aySec() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            initialDateTime: secilenTarih ?? DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                secilenTarih = newDate;
                int gunSayisi = DateTime(secilenTarih!.year, secilenTarih!.month + 1, 0).day;
                secilenGunler = List.generate(gunSayisi, (index) => false);
                secilenResmiTatiller.clear();
                _saveData();
              });
            },
            mode: CupertinoDatePickerMode.date,
            minimumYear: DateTime.now().year,
            maximumYear: DateTime.now().year + 5,
          ),
        );
      },
    );
  }

  void _clearSelections() {
    setState(() {
      for (int i = 0; i < secilenGunler!.length; i++) {
        secilenGunler![i] = false;
      }
      secilenResmiTatiller.clear();
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar yerine CupertinoNavigationBar kullanıyoruz.
      appBar: CupertinoNavigationBar(
        middle: Text('Liste Hazırla'), // Başlık
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _clearSelections,
          child: Text('Temizle'),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _aySec,
                child: Text('Liste Ayı Seç'),
              ),
              ElevatedButton(
                onPressed: _clearSelections,
                child: Text('Seçilenleri Temizle'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white // Butonun arka plan rengi
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Lütfen Resmi Tatil Günlerini Seçin',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: secilenGunler?.length ?? 0,
              itemBuilder: (context, index) {
                if (secilenTarih == null) return Container(); // Tarih seçilmediyse boş container döndür.

                DateTime gununTarihi = DateTime(secilenTarih!.year, secilenTarih!.month, index + 1);
                String formattedGun = DateFormat('dd MMMM EEEE', 'tr_TR').format(gununTarihi);

                return CheckboxListTile(
                  title: Text(formattedGun),
                  value: secilenGunler![index],
                  onChanged: (bool? value) {
                    setState(() {
                      secilenGunler![index] = value!;
                      if (value) {
                        secilenResmiTatiller.add(DateFormat('dd.MM.yyyy').format(gununTarihi));
                      } else {
                        secilenResmiTatiller.remove(DateFormat('dd.MM.yyyy').format(gununTarihi));
                      }
                      _saveData();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

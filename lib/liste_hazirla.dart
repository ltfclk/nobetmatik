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
          int gunIndex = int.parse(gun.split('. ')[0]) - 1;
          secilenGunler![gunIndex] = true;
          secilenResmiTatiller.add(gun);
        });
      });
    }
  }

  void _aySec() async {
    final DateTime? yeniSecilenTarih = await showDatePicker(
      context: context,
      initialDate: secilenTarih ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (yeniSecilenTarih != null && yeniSecilenTarih != secilenTarih) {
      setState(() {
        secilenTarih = yeniSecilenTarih;
        int gunSayisi = DateTime(secilenTarih!.year, secilenTarih!.month + 1, 0).day;
        secilenGunler = List.generate(gunSayisi, (index) => false);
        secilenResmiTatiller.clear();
        _saveData();
      });
    }
  }

  void _saveData() {
    prefs?.setInt('year', secilenTarih!.year);
    prefs?.setInt('month', secilenTarih!.month);
    prefs?.setStringList('tatiller', secilenResmiTatiller);
  }

  void _gunleriGoster() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: secilenGunler?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              title: Text('${index + 1}. Gün'),
              value: secilenGunler![index],
              onChanged: (bool? value) {
                setState(() {
                  secilenGunler![index] = value!;
                  if (value) {
                    secilenResmiTatiller.add('${index + 1}. Gün');
                  } else {
                    secilenResmiTatiller.remove('${index + 1}. Gün');
                  }
                  _saveData();
                });
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste Hazırla'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              onPressed: _aySec,
              child: Text('Liste Ayı Seç'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            SizedBox(height: 20),
            if (secilenTarih != null)
              Text('Seçilen Ay: ${DateFormat.yMMM('tr_TR').format(secilenTarih!)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _gunleriGoster,
              child: Text('Resmi Tatil Seç'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            SizedBox(height: 20),
            if (secilenResmiTatiller.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: secilenResmiTatiller.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(secilenResmiTatiller[index]),
                    );
                  },
                ),
              ),
            if (secilenResmiTatiller.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Resmi tatil seçilmedi.'),
              ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ListeHazirla()));

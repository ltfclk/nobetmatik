import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // intl paketini ekleyin

class BosListe extends StatefulWidget {
  @override
  _BosListeState createState() => _BosListeState();
}

class _BosListeState extends State<BosListe> {
  List<String> daysOfMonth = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadSelectedDate();
  }

  void _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final int? year = prefs.getInt('year');
    final int? month = prefs.getInt('month');

    if (year != null && month != null) {
      selectedDate = DateTime(year, month);
      _generateDaysOfMonth(selectedDate!);
    }
  }

  void _generateDaysOfMonth(DateTime date) {
    final int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final DateFormat formatter = DateFormat('d MMMM EEEE', 'tr_TR'); // Türkçe format, '/' işaretleri kaldırıldı

    setState(() {
      daysOfMonth = List<String>.generate(daysInMonth, (i) {
        // Her gün için tarih nesnesi oluşturun
        final dayDate = DateTime(date.year, date.month, i + 1);
        // formatter ile tarihi formatlayın
        return formatter.format(dayDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Boş Liste'),
      ),
      child: ListView.builder(
        itemCount: daysOfMonth.length,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.centerLeft, // Metni sola yasla
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: CupertinoColors.systemGrey)),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero, // Buton padding'ini sıfırla
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(daysOfMonth[index]),
              ),
              onPressed: () {
                // Burada her gün için bir işlem yapabilirsiniz.
              },
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(CupertinoApp(home: BosListe()));

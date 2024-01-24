import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Vardiya Planlayıcı',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: VardiyaSecimi(),
    );
  }
}

class VardiyaSecimi extends StatefulWidget {
  @override
  _VardiyaSecimiState createState() => _VardiyaSecimiState();
}


class _VardiyaSecimiState extends State<VardiyaSecimi> {
  int haftaIciVardiyaSayisi = 1;
  int haftaSonuVardiyaSayisi = 1;
  int resmiTatilVardiyaSayisi = 1;

  List<TextEditingController> haftaIciControllers = [TextEditingController(text: '08.00-16.00')];
  List<TextEditingController> haftaSonuControllers = [TextEditingController(text: '08.00-16.00')];
  List<TextEditingController> resmiTatilControllers = [TextEditingController(text: '08.00-16.00')];



  @override
  void dispose() {
    haftaIciControllers.forEach((controller) => controller.dispose());
    haftaSonuControllers.forEach((controller) => controller.dispose());
    resmiTatilControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _updateVardiyaSayisi(bool increment, String vardiyaTuru) {
    if (increment) {
      bool canIncrement = false;
      if (vardiyaTuru == 'haftaIci') {
        canIncrement = haftaIciVardiyaSayisi < 3;
      } else if (vardiyaTuru == 'haftaSonu') {
        canIncrement = haftaSonuVardiyaSayisi < 3;
      } else if (vardiyaTuru == 'resmiTatil') {
        canIncrement = resmiTatilVardiyaSayisi < 3;
      }

      if (!canIncrement) {
        // Kullanıcıya bir CupertinoAlertDialog göster
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Uyarı'),
              content: Text('Maksimum vardiya sayısına ulaştınız! Yani şimdilik :) '),
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
      } else {
        setState(() {
          if (vardiyaTuru == 'haftaIci') {
            haftaIciVardiyaSayisi++;
            haftaIciControllers.add(TextEditingController(text: '08.00-16.00'));
          } else if (vardiyaTuru == 'haftaSonu') {
            haftaSonuVardiyaSayisi++;
            haftaSonuControllers.add(TextEditingController(text: '08.00-16.00'));
          } else if (vardiyaTuru == 'resmiTatil') {
            resmiTatilVardiyaSayisi++;
            resmiTatilControllers.add(TextEditingController(text: '08.00-16.00'));
          }
        });
      }
    } else {
      setState(() {
        if (vardiyaTuru == 'haftaIci' && haftaIciVardiyaSayisi > 1) {
          haftaIciVardiyaSayisi--;
          var removedController = haftaIciControllers.removeLast();
          removedController.dispose();
        } else if (vardiyaTuru == 'haftaSonu' && haftaSonuVardiyaSayisi > 1) {
          haftaSonuVardiyaSayisi--;
          var removedController = haftaSonuControllers.removeLast();
          removedController.dispose();
        } else if (vardiyaTuru == 'resmiTatil' && resmiTatilVardiyaSayisi > 1) {
          resmiTatilVardiyaSayisi--;
          var removedController = resmiTatilControllers.removeLast();
          removedController.dispose();
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Vardiya Seçimi'),
      ),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            buildVardiyaSection('Hafta İçi Vardiya Saatlerini Düzenleyin', haftaIciControllers, 'haftaIci'),
            buildVardiyaSection('Hafta Sonu Vardiya Saatlerini Düzenleyin', haftaSonuControllers, 'haftaSonu'),
            buildVardiyaSection('Resmi Tatil Vardiya Saatlerini Düzenleyin', resmiTatilControllers, 'resmiTatil'),
          ],
        ),
      ),
    );
  }

  Widget buildVardiyaSection(String title, List<TextEditingController> controllers, String vardiyaTuru) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
              color: CupertinoColors.activeBlue, // Başlık rengi
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
        Column(
          children: List.generate(controllers.length, (index) => buildTimeInputField(controllers[index])),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CupertinoButton(
              // Vardiya Çıkar butonu için metin eklendi
              child: Row(
                children: <Widget>[
                  Icon(CupertinoIcons.minus),
                  SizedBox(width: 4),
                  Text('Vardiya Çıkar'),
                ],
              ),
              onPressed: () => _updateVardiyaSayisi(false, vardiyaTuru),
            ),
            CupertinoButton(
              // Vardiya Ekle butonu için metin eklendi
              child: Row(
                children: <Widget>[
                  Icon(CupertinoIcons.add),
                  SizedBox(width: 4),
                  Text('Vardiya Ekle'),
                ],
              ),
              onPressed: () => _updateVardiyaSayisi(true, vardiyaTuru),
            ),
          ],
        ),
      ],
    );
  }



  Widget buildTimeInputField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: CupertinoTextField(
        controller: controller,
        keyboardType: TextInputType.number,
        placeholder: 'HH.MM-HH.MM',
        onEditingComplete: () {
          if (!_isValidTime(controller.text)) {
            // Hatalı format girildiğinde kullanıcıyı uyar
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('Yanlış Format'),
                  content: Text('Lütfen geçerli bir saat aralığı girin: HH.MM-HH.MM'),
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
            // Hatalı giriş yapıldığında, kullanıcıyı hatalı girdiği yere geri götür
            controller.text = '';
          }
        },
        inputFormatters: [
          _TimeInputFormatter(),
        ],
      ),
    );
  }


  bool _isValidTime(String input) {
    // Saat formatını kontrol et (HH.MM-HH.MM)
    final validTimeRegExp = RegExp(r'^\d{1,2}\.\d{2}-\d{1,2}\.\d{2}$');
    if (!validTimeRegExp.hasMatch(input)) {
      return false;
    }
    // Saatlerin geçerli olup olmadığını kontrol et
    var times = input.split('-');
    var startTime = times[0].split('.');
    var endTime = times[1].split('.');

    int startHour = int.parse(startTime[0]);
    int startMinute = int.parse(startTime[1]);
    int endHour = int.parse(endTime[0]);
    int endMinute = int.parse(endTime[1]);

    // Saat ve dakikanın geçerli aralıkta olup olmadığını kontrol et
    if (startHour < 0 || startHour > 23 || endHour < 0 || endHour > 23) {
      return false;
    }
    if (startMinute < 0 || startMinute > 59 || endMinute < 0 || endMinute > 59) {
      return false;
    }

    // Başlangıç saatinin bitiş saatinden önce olduğunu kontrol et
    if (startHour > endHour || (startHour == endHour && startMinute >= endMinute)) {
      return false;
    }

    return true;
  }
}
// Yeni TextInputFormatter'ınız
class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Eğer kullanıcı silme işlemi yapıyorsa, newText'i doğrudan döndür
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    // İlk noktayı ekleyerek HH.MM formatını zorla
    if (newText.length == 2 && oldValue.text.length == 1) {
      return TextEditingValue(
        text: '$newText.',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }

    // Çizgiyi ekleyerek HH.MM-HH formatını zorla
    else if (newText.length == 5 && oldValue.text.length == 4) {
      return TextEditingValue(
        text: '$newText-',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }

    // İkinci noktayı ekleyerek HH.MM-HH.MM formatını zorla
    else if (newText.length == 8 && oldValue.text.length == 7) {
      return TextEditingValue(
        text: '$newText.',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }

    // Kullanıcı fazladan bir şeyler girmişse, bunu kırptık
    else if (newText.length > 11) {
      return TextEditingValue(
        text: newText.substring(0, 11),
        selection: TextSelection.collapsed(offset: 11),
      );
    }

    return newValue;
  }
}

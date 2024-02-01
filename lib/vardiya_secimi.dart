import  'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());


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

  List<TextEditingController> haftaIciControllers = [];
  List<TextEditingController> haftaSonuControllers = [];
  List<TextEditingController> resmiTatilControllers = [];



  @override
  void initState() {
    super.initState();
    _loadVardiyaData();
    _addListenerToControllers(haftaIciControllers);
    _addListenerToControllers(haftaSonuControllers);
    _addListenerToControllers(resmiTatilControllers);
  }

  void _addListenerToControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.addListener(() {
        _saveVardiyaData();
      });
    }
  }

  _loadVardiyaData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      haftaIciVardiyaSayisi = prefs.getInt('haftaIciVardiyaSayisi') ?? 1;
      haftaSonuVardiyaSayisi = prefs.getInt('haftaSonuVardiyaSayisi') ?? 1;
      resmiTatilVardiyaSayisi = prefs.getInt('resmiTatilVardiyaSayisi') ?? 1;

      haftaIciControllers = List.generate(
        haftaIciVardiyaSayisi,
            (index) => TextEditingController(
          text: prefs.getString('haftaIciVardiya$index'),
        ),
      );
      haftaSonuControllers = List.generate(
        haftaSonuVardiyaSayisi,
            (index) => TextEditingController(
          text: prefs.getString('haftaSonuVardiya$index'),
        ),
      );
      resmiTatilControllers = List.generate(
        resmiTatilVardiyaSayisi,
            (index) => TextEditingController(
          text: prefs.getString('resmiTatilVardiya$index'),
        ),
      );
    });
  }

  _saveVardiyaData() async {
    final prefs = await SharedPreferences.getInstance();

    bool allFieldsFilled = true;
    for (var controller in haftaIciControllers) {
      if (controller.text.isEmpty) {
        allFieldsFilled = false;
        break;
      }
    }
    for (var controller in haftaSonuControllers) {
      if (controller.text.isEmpty) {
        allFieldsFilled = false;
        break;
      }
    }
    for (var controller in resmiTatilControllers) {
      if (controller.text.isEmpty) {
        allFieldsFilled = false;
        break;
      }
    }

    if (!allFieldsFilled) {
      // Eğer tüm alanlar doldurulmamışsa kullanıcıya hata göster
      // Hata mesajı gösterme kodu burada olacak
    } else {
      // Tüm alanlar doldurulmuşsa kaydetme işlemini yap
      await prefs.setInt('haftaIciVardiyaSayisi', haftaIciVardiyaSayisi);
      await prefs.setInt('haftaSonuVardiyaSayisi', haftaSonuVardiyaSayisi);
      await prefs.setInt('resmiTatilVardiyaSayisi', resmiTatilVardiyaSayisi);

      for (int i = 0; i < haftaIciControllers.length; i++) {
        await prefs.setString('haftaIciVardiya$i', haftaIciControllers[i].text);
      }
      for (int i = 0; i < haftaSonuControllers.length; i++) {
        await prefs.setString('haftaSonuVardiya$i', haftaSonuControllers[i].text);
      }
      for (int i = 0; i < resmiTatilControllers.length; i++) {
        await prefs.setString('resmiTatilVardiya$i', resmiTatilControllers[i].text);
      }
    }
  }

  void _updateVardiyaSayisi(bool increment, String vardiyaTuru) {
    setState(() {
      int sayi;
      List<TextEditingController> controllers;
      switch (vardiyaTuru) {
        case 'haftaIci':
          sayi = haftaIciVardiyaSayisi;
          controllers = haftaIciControllers;

          if (increment && sayi < 3) {
            sayi++;
            controllers.add(TextEditingController()); // Varsayılan değer atanmıyor
          } else if (!increment && sayi > 0) {
            sayi--;
            controllers.last.dispose();
            controllers.removeLast();
          }
          haftaIciVardiyaSayisi = sayi;
          break;
        case 'haftaSonu':
          sayi = haftaSonuVardiyaSayisi;
          controllers = haftaSonuControllers;
          if (increment && sayi < 3) {
            sayi++;
            controllers.add(TextEditingController()); // Varsayılan değer atanmıyor
          } else if (!increment && sayi > 0) {
            sayi--;
            controllers.last.dispose();
            controllers.removeLast();
          }
          haftaSonuVardiyaSayisi = sayi;
          break;
        case 'resmiTatil':
          sayi = resmiTatilVardiyaSayisi;
          controllers = resmiTatilControllers;
          if (increment && sayi < 3) {
            sayi++;
            controllers.add(TextEditingController()); // Varsayılan değer atanmıyor
          } else if (!increment && sayi > 0) {
            sayi--;
            controllers.last.dispose();
            controllers.removeLast();
          }
          resmiTatilVardiyaSayisi = sayi;
          break;
      }
      _saveVardiyaData(); // Save the updated data
    });
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
            buildVardiyaSection('Resmi Tatil Vardiya Saatlerini Düzenleyin                     (Resmi tatil yoksa eklemeyin)', resmiTatilControllers, 'resmiTatil'),
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
              color: CupertinoColors.activeBlue,
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
            Expanded(
              child: CupertinoButton(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.minus),
                      SizedBox(width: 4),
                      Text('Vardiya Çıkar'),
                    ],
                  ),
                ),
                onPressed: () => _updateVardiyaSayisi(false, vardiyaTuru),
              ),
            ),
            Expanded(
              child: CupertinoButton(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.add),
                      SizedBox(width: 4),
                      Text('Vardiya Ekle'),
                    ],
                  ),
                ),
                onPressed: () => _updateVardiyaSayisi(true, vardiyaTuru),
              ),
            ),
            Expanded(
              child: CupertinoButton(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.check_mark_circled_solid),
                      SizedBox(width: 4),
                      Text('Kaydet'),
                    ],
                  ),
                ),
                onPressed: () => _saveVardiyaData(),
              ),
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
        placeholder: 'Örnek: 08.00-16.00',
        onEditingComplete: () {
          // Klavye kapandığında veya başka bir input alanına geçildiğinde
          FocusScope.of(context).unfocus(); // Klavyeyi kapat
          if (_isValidTime(controller.text)) {
            _saveVardiyaData(); // Veriyi kaydet
          } else {
            // Format yanlışsa kullanıcıyı uyarmak için bir diyalog göster
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('Yanlış Saat Aralığı'),
                  content: Text('Lütfen geçerli bir saat aralığı girin: SS.DK-SS.DK örnek:08.00-16.00 '),
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
            controller.text = ''; // Yanlış girilen değeri temizle
          }
        },
        inputFormatters: [
          _TimeInputFormatter(),
        ],
      ),
    );
  }



  bool _isValidTime(String input) {
    // Saat formatını kontrol et (HH:MM-HH:MM)
    final validTimeRegExp = RegExp(r'^\d{1,2}\.\d{2}-\d{1,2}\.\d{2}$');
    if (!validTimeRegExp.hasMatch(input)) {
      return false;
    }

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

    // Vardiya aynı gün içinde bitiyorsa, başlangıç saatinin bitiş saatinden önce olduğunu kontrol et
    if (startHour < endHour || (startHour == endHour && startMinute <= endMinute)) {
      return true;
    }

    // Vardiya bir sonraki güne taşıyorsa ve bitiş saati başlangıç saatinden küçük veya eşitse, bu geçerli bir durumdur.
    // Örneğin, bir vardiya akşam 16.00'da başlayıp, ertesi gün sabah 08.00'de bitiyor olabilir.
    if (endHour < startHour || (endHour == startHour && endMinute <= startMinute)) {
      return true; // Gece boyunca devam eden vardiya için geçerli
    }

    // Diğer tüm durumlar geçersizdir
    return false;
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;


    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }


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


    else if (newText.length > 11) {
      return TextEditingValue(
        text: newText.substring(0, 11),
        selection: TextSelection.collapsed(offset: 11),
      );
    }
    return newValue;
  }
}
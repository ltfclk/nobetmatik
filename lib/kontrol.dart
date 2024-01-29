import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KontrolSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Kontrol Sayfası'),
      ),
      child: Center(
        child: Text(
          'Bu bir kontrol sayfasıdır.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

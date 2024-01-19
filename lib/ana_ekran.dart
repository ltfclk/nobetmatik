import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: AnaEkran(),
    );
  }
}

class AnaEkran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Nöbetmatik'),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Center(child: CupertinoButton(child: Text('Buton1'), onPressed: () {}))),
            Expanded(child: Center(child: CupertinoButton(child: Text('Buton2'), onPressed: () {}))),
            Expanded(child: Center(child: CupertinoButton(child: Text('Buton3'), onPressed: () {}))),
            Expanded(child: Center(child: CupertinoButton(child: Text('Buton4'), onPressed: () {}))),
          ],
        ),
      ),
    );
  }
}

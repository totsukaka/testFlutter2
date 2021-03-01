import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier{
  String sampleText = 'これはテストです';

  void changeSampleText(){
    sampleText = '変更しました';
    // 変更したことを通知
    notifyListeners();
  }
}
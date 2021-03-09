import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'moor_model.dart';

class MoorListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return ChangeNotifierProvider<MoorModel>(
      create: (_) => MoorModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('サインアップ'),
        ),
        body: Consumer<MoorModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'タイトル'),
                  controller: titleController,
                  onChanged: (text) {
                    model.title = text;
                  },
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(hintText: 'コンテンツ'),
                  onChanged: (text) {
                    model.content = text;
                  },
                ),
                RaisedButton(
                  child: Text('登録する'),
                  onPressed: () async {
                    try {
                      await model.registerToMoor();
                      _showDialog(context, '登録完了しました');
                    } catch (e) {
                      _showDialog(context, e.toString());
                      print(e);
                    }
                  },
                ),
                RaisedButton(
                  child: Text('一覧の表示'),
                  onPressed: () async {
                    try {
                      await model.printToMoor();
                    } catch (e) {
                      _showDialog(context, e.toString());
                      print(e);
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future _showDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

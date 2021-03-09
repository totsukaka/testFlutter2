import 'package:flutter/material.dart';
import 'package:flutter_app3/database/db.dart';
import 'package:flutter_app3/presentation/main/main.dart';
import 'package:moor_flutter/moor_flutter.dart';

class MoorModel extends ChangeNotifier {
  // MyDatabase myDatabase;
  String title = '';
  String content = '';
  // final myDatabase = MyDatabase();

  Future registerToMoor() async {
    if (title.isEmpty) {
      throw ('タイトルを入力してください');
    }

    if (content.isEmpty) {
      throw ('コンテンツを入力してください');
    }

    print('タイトル：$title');
    print('コンテンツ：$content');

    int result = await database.addTodoEntry(
      TodosCompanion(
        title: Value(title),
        content: Value(content),
      ),
    );
  }

  Future printToMoor() async {
    List<Todo> todoList = await database.getAllTodoEntries();

    for (int i = 0; i < todoList.length; i++) {
      print(todoList[i]);
    }
  }
}

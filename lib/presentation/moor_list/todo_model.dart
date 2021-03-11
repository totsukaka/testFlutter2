import 'package:flutter/material.dart';
import 'package:flutter_app3/database/db.dart';
import 'package:flutter_app3/presentation/main/main.dart';
import 'package:moor_flutter/moor_flutter.dart';

class TodoModel extends ChangeNotifier {
  String title = '';
  String content = '';
  List<Todo> todos = [];
  bool loadingFlag = false;

  startLoading() {
    loadingFlag = true;
    notifyListeners();
  }

  endLoading() {
    loadingFlag = false;
    notifyListeners();
  }

  // todoの登録を行う
  Future registerToMoor() async {
    if (title.isEmpty) {
      throw ('タイトルを入力してください');
    }

    if (content.isEmpty) {
      throw ('コンテンツを入力してください');
    }

    print('タイトル：$title');
    print('コンテンツ：$content');

    // 登録の実行
    int result = await database.addTodoEntry(
      TodosCompanion(
        title: Value(title),
        content: Value(content),
      ),
    );
  }

//  todoの表示を行う
  Future printToMoor() async {
    List<Todo> todoList = await database.getAllTodoEntries();
    this.todos = todoList;
    notifyListeners();
  }

  //  todoの削除を行う
  Future deleteToMoor(Todo todo) async {
    int result = await database.deleteTodo(todo.id);
  }

  //  todoの更新を行う
  Future updateToMoor(int todoId, Todo todo) async {
    String updateTitle = '';
    String updateContant = '';

    if (title.isEmpty) {
      throw ('タイトルを入力してください');
    }

    if (content.isEmpty) {
      throw ('コンテンツを入力してください');
    }

    // 登録の実行
    int result = await database.updateTodo(
      todoId,
      TodosCompanion(
        title: Value(title),
        content: Value(content),
      ),
    );
  }
}

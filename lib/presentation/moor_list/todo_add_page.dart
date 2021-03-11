import 'package:flutter/material.dart';
import 'package:flutter_app3/database/db.dart';
import 'package:provider/provider.dart';

import 'moor_list_page.dart';
import 'todo_model.dart';

class TodoAddPage extends StatelessWidget {
  TodoAddPage({this.todo});
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    /// 新規(false)か更新(true)か
    final bool updateFlag = todo != null;

    if (updateFlag) {
      titleController.text = todo.title;
      contentController.text = todo.content;
    }

    return ChangeNotifierProvider<TodoModel>(
      create: (_) => TodoModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(updateFlag ? 'todoの編集' : 'todoの新規追加'),
        ),
        body: Consumer<TodoModel>(builder: (context, model, child) {
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
                ElevatedButton(
                  child: Text(updateFlag ? '更新' : '登録'),
                  onPressed: () async {
                    try {
                      model.startLoading();

                      if (updateFlag) {
                        ///更新
                        await model.updateToMoor(todo.id, todo);
                      } else {
                        ///登録
                        await model.registerToMoor();
                      }
                      model.endLoading();

                      _showMordal(context, '登録完了しました');
                    } catch (e) {
                      _showMordal(context, e.toString());
                      print(e);
                    }
                  },
                ),
                ElevatedButton(
                  child: Text('一覧の表示'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoorListPage()),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future _showMordal(BuildContext context, String title) {
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

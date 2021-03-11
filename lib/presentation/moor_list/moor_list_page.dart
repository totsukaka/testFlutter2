import 'package:flutter/material.dart';
import 'package:flutter_app3/database/db.dart';
import 'package:flutter_app3/presentation/main/main.dart';
import 'package:flutter_app3/presentation/moor_list/todo_add_page.dart';
import 'package:provider/provider.dart';

import 'todo_model.dart';

class MoorListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoModel>(
      create: (_) => TodoModel()..printToMoor(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('todo一覧'),
        ),
        body: Consumer<TodoModel>(builder: (context, model, child) {
          final todos = model.todos;
          final listTiles = todos
              .map(
                (todo) => ListTile(
                  leading: Text(todo.id.toString()),
                  title: Text(todo.title),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoAddPage(todo: todo),
                          // 縦スクロールで遷移(前画面に戻るときは×ボタンになる)
                          fullscreenDialog: true,
                        ),
                      );
                      model.printToMoor();
                    },
                  ),
                  onLongPress: () async {
                    await showDialog(
                      context: context,
                      // barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('${todo.title}を削除しますか'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('ok'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await deleteTodo(context, model, todo);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
              .toList();
          return ListView(
            children: listTiles,
          );
        }),
      ),
    );
  }

  Future deleteTodo(BuildContext context, TodoModel model, Todo todo) async {
    try {
      // await model.deleteToMoor(todo);
      await database.deleteTodo(todo.id);
      model.printToMoor();
      await _showModal(context, '削除しました');
    } catch (e) {
      await _showModal(context, e.toString());
    }
  }

  Future _showModal(BuildContext context, String title) {
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

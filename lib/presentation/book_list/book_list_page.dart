import 'package:flutter/material.dart';
import 'package:flutter_app3/domain/main/book.dart';
import 'package:flutter_app3/presentation/add_book/add_book_page.dart';
import 'package:flutter_app3/presentation/book_list/book_list_modell.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      ///リアルタイムで変更される
      create: (_) => BookListModel()..getTodoListRealtime(),

      ///画面遷移と同時に更新
      // create: (_) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ラーメン一覧'),
          actions: [
            Consumer<BookListModel>(builder: (context, model, child) {
              final isActive = model.checkBeforeActiveFinishButton();
              return TextButton(
                  onPressed: isActive
                      ? () async {
                          await model.deleteCheckedItems();
                        }
                      : null,
                  child: Text(
                    '完了',
                    style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.5)),
                  ));
            })
          ],
        ),
        body: Consumer<BookListModel>(builder: (context, model, child) {
          final books = model.books;
          final listTiles = books;
          return ListView(
            children: books
                .map(
                  (book) => CheckboxListTile(
                    title: Text(book.title),
                    value: book.isCheck,
                    onChanged: (bool value) {
                      book.isCheck = !book.isCheck;
                      model.reload();
                    },
                  ),
                )
                .toList(),
          );
        }),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  // 縦スクロールで遷移(前画面に戻るときは×ボタンになる)
                  fullscreenDialog: true,
                ),
              );
              model.fetchBooks();
            },
          );
        }),
      ),
    );
  }

  Future deleteBook(
      BuildContext context, BookListModel model, Book book) async {
    try {
      await model.deleteBook(book);
      model.fetchBooks();
      // await _showDialog(context, '削除しました'); //解決方法不明
    } catch (e) {
      await _showDialog(context, e.toString());
    }
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

import 'package:flutter/material.dart';
import 'package:flutter_app3/domain/main/book.dart';
import 'package:flutter_app3/presentation/add_book/add_book_page.dart';
import 'package:flutter_app3/presentation/book_list/book_list_modell.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp();
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),
        body: Consumer<BookListModel>(builder: (context, model, child) {
          final books = model.books;
          final listTiles = books
              .map(
                (book) => ListTile(
                  title: Text(book.title),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBookPage(book: book),
                          // 縦スクロールで遷移(前画面に戻るときは×ボタンになる)
                          fullscreenDialog: true,
                        ),
                      );
                      model.fetchBooks();
                    },
                  ),
                  onLongPress: () async {
                    await showDialog(
                      context: context,
                      // barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('${book.title}を削除しますか'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('ok'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await deleteBook(context, model, book);
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

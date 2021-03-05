import 'package:flutter/material.dart';
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
          final listTiles =
              books.map((book) => ListTile(title: Text(book.title))).toList();
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
}

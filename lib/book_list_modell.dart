import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'book.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];

  Future fetchBooks() async {
    // firestoreのbooksデータを取得し変数docsに変換する。
    final docs = await FirebaseFirestore.instance.collection('books').get();
    print(docs.docs);
    // 取得したdocsデータをmapに変換する。
    final books = docs.docs.map((doc) => Book(doc['title'])).toList();
    this.books = books;
    // print(this.books[0].title);
    notifyListeners();
  }
}

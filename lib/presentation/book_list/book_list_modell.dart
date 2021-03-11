import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/domain/main/book.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];

  Future fetchBooks() async {
    // firestoreのbooksデータを取得し変数docsに変換する。
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
    final docs = snapshot.docs;
    // 取得したdocsデータをmapに変換する。
    final books = docs.map((doc) => Book(doc)).toList();
    this.books = books;
    // print(this.books[0].title);
    notifyListeners();
  }

  Future deleteBook(Book book) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(book.documentID)
        .delete();
  }

  void getTodoListRealtime() {
    final snapshots =
        FirebaseFirestore.instance.collection('books').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final bookList = docs.map((doc) => Book(doc)).toList();
      bookList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      this.books = bookList;
      notifyListeners();
    });
  }
}

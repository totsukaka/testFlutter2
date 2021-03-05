import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/domain/main/book.dart';

class AddBookModel extends ChangeNotifier {
  String bookTitle = '';

  Future addBookToFirebase() async {
    if (bookTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }
    FirebaseFirestore.instance.collection('books').add({
      'title': bookTitle,
      'createdAt': Timestamp.now(),
    });
  }

  Future updateBook(Book book) async {
    String updateBookTitle = '';
    if (bookTitle.isEmpty) {
      updateBookTitle = book.title;
    } else {
      updateBookTitle = bookTitle;
    }

    final document =
        FirebaseFirestore.instance.collection('books').doc(book.documentID);
    await document.update(
      {
        'title': updateBookTitle,
        'updateAt': Timestamp.now(),
      },
    );
  }
}

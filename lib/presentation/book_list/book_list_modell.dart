import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/domain/main/book.dart';
import 'package:image_picker/image_picker.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];
  String newBookTitle = '';
  File imageFile;
  bool isLoading = false;

  /// bookの一覧表示
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

  /// bookの一覧表示(リアルタイム)
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

  /// bookの削除
  Future deleteBook(Book book) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(book.documentID)
        .delete();
  }

  /// ロード開始
  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  /// ロード修了
  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// 端末のフォトライブラリを開かせる
  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  /// 新規追加
  Future addBookToFirebase() async {
    if (newBookTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }
    // final imageURL = await _uploadImage();
    final imageURL = 'imageURL';
    FirebaseFirestore.instance.collection('books').add({
      'title': newBookTitle,
      'imageURL': imageURL,
      'createdAt': Timestamp.now(),
    });
  }

  /// 更新
  Future updateBook(Book book) async {
    String updateBookTitle = '';
    String imageURL = '';

    // // 画像の更新があった場合
    // if (imageFile != null) {
    //   // 画像の更新
    //   imageURL = await _uploadImage();
    // }

    if (newBookTitle.isEmpty) {
      updateBookTitle = book.title;
    } else {
      updateBookTitle = newBookTitle;
    }

    final document =
        FirebaseFirestore.instance.collection('books').doc(book.documentID);

    print(document.get().then((value) => value.get('title')));
    await document.update(
      {
        'title': updateBookTitle,
        'imageURL': imageURL,
        'updateAt': Timestamp.now(),
      },
    );
  }

  /// 画像の追加・更新処理
  // Future<String> _uploadImage() async {
  //   final storage = FirebaseStorage.instance;
  //   print(imageFile == null);
  //   TaskSnapshot snapshot =
  //       await storage.ref('books/$newBookTitle').putFile(imageFile);
  //   final String donwloadURL = await snapshot.ref.getDownloadURL();
  //   return donwloadURL;
  // }

  void reload() {
    notifyListeners();
  }

  Future deleteCheckedItems() async {
    final checkedItems = books.where((book) => book.isCheck).toList();
    final references =
        checkedItems.map((book) => book.documentReference).toList();

    final batch = FirebaseFirestore.instance.batch();

    references.forEach((reference) {
      batch.delete(reference);
    });

    return batch.commit();
  }

  bool checkBeforeActiveFinishButton() {
    final checkedItems = books.where((book) => book.isCheck).toList();
    return checkedItems.length > 0;
  }
}

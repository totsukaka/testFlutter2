///使用済み（1つのモデルを使いまわすため、bool_list_modelに引っ越し）
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/domain/main/book.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  Book createBook;
  String bookTitle = '';
  File imageFile;
  bool isLoading = false;
  String newBookTitle = '';

  setBook(Book injectionbook) {
    createBook = injectionbook;
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

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
    print(updateBookTitle);
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

// Future<String> _uploadImage() async {
//   final storage = FirebaseStorage.instance;
//   print(imageFile == null);
//   TaskSnapshot snapshot =
//       await storage.ref('books/$bookTitle').putFile(imageFile);
//   final String donwloadURL = await snapshot.ref.getDownloadURL();
//   return donwloadURL;
// }
}

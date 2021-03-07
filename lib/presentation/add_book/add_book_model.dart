import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/domain/main/book.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  String bookTitle = '';
  File imageFile;
  bool isLoading = false;

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
    if (bookTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }
    final imageURL = await _uploadImage();
    FirebaseFirestore.instance.collection('books').add({
      'title': bookTitle,
      'imageURL': imageURL,
      'createdAt': Timestamp.now(),
    });
  }

  Future updateBook(Book book) async {
    String updateBookTitle = '';
    String imageURL = '';

    // 画像の更新があった場合
    if (imageFile != null) {
      // 画像の更新
      imageURL = await _uploadImage();
    }

    print('updateBook');
    if (bookTitle.isEmpty) {
      updateBookTitle = book.title;
    } else {
      updateBookTitle = bookTitle;
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

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    print(imageFile == null);
    TaskSnapshot snapshot =
        await storage.ref('books/$bookTitle').putFile(imageFile);
    final String donwloadURL = await snapshot.ref.getDownloadURL();
    return donwloadURL;
  }
}

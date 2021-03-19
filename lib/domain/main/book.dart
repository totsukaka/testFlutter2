import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    this.documentID = doc.id;
    this.title = doc.data()['title'];
    this.imageURL = doc.data()['imageURL'];
    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
  }
  String documentID;
  String title;
  String imageURL;
  DateTime createdAt;
  bool isCheck = false;
  DocumentReference documentReference;
}

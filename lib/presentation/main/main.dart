import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/database/db.dart';
import 'package:flutter_app3/presentation/book_list/book_list_page.dart';
import 'package:flutter_app3/presentation/book_list/book_list_page2.dart';
import 'package:flutter_app3/presentation/login/login_page.dart';
import 'package:flutter_app3/presentation/main/main_model.dart';
import 'package:flutter_app3/presentation/moor_list/todo_add_page.dart';
import 'package:flutter_app3/presentation/signup/signup_page.dart';
import 'package:provider/provider.dart';

MyDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  database = MyDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('テストFlutter'),
          ),
          body: Consumer<MainModel>(builder: (context, model, child) {
            return Center(
              child: Column(children: [
                Text(
                  model.sampleText,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                ElevatedButton(
                  child: Text('ラーメン図鑑'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookListPage()),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('ラーメン図鑑2'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookListPage2()),
                    );
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.brown),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    )),
                  ),
                  child: Text('登録'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('ログイン'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('moor!'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TodoAddPage()),
                    );
                  },
                )
              ]),
            );
          }),
        ),
      ),
    );
  }
}

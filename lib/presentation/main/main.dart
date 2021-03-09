import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/database/db.dart';
import 'package:flutter_app3/presentation/book_list/book_list_page.dart';
import 'package:flutter_app3/presentation/login/login_page.dart';
import 'package:flutter_app3/presentation/main/main_model.dart';
import 'package:flutter_app3/presentation/moor_list/moor_page.dart';
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
                RaisedButton(
                  child: Text('本一覧'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookListPage()),
                    );
                  },
                ),
                RaisedButton(
                  child: Text('サインイン'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                ),
                RaisedButton(
                  child: Text('ログイン'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
                RaisedButton(
                  child: Text('moor!'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoorListPage()),
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

import 'package:flutter/material.dart';
import 'package:flutter_frontend/globalstate.dart';
import 'package:flutter_frontend/models.dart';
import 'package:flutter_frontend/pages.dart';
import 'package:flutter_frontend/widgets.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: MaterialApp(
        title: "App",
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      )
    );

    // return MaterialApp(
    //   title: "App",
    //   home: TestPage(),
    // );
  }
}


class TestPage extends StatelessWidget {
  final postshortcutWidget = PostShortcutWidget(
    shortcut: PostShortcut(
        postid: 1,
        title: "hello",
        shortcut: "<h5>hello world</h5>" * 200,
        author: User(id: 1, name: "hello", email: "hello"),
        category: Category(id: 1, name: "category1")
    ),
  );

  final postWidget = PostView(
      post: Post(
        id: 1,
        title: "hello",
        body: "<h1>Hello World</h1>" * 5,
        category: Category(id: 1, name: "category 1"),
        author: User(id: 1, name: "steiner", email: "email"),
        timestamp: '',
        comments: <Comment>[],
      )
  );

  final row = Row(
    children: [
      SizedBox(
        width: 200,
        child: TextField(),
      ),

      DropdownButton<String>(items: [], onChanged: (String? value) {})
    ],
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Test Page"),),
      body: Center(
        child: row
      )
    );
  }
}
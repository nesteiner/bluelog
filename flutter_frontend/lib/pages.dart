import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api.dart';
import 'package:flutter_frontend/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import 'package:flutter_frontend/globalstate.dart';
import 'package:flutter_frontend/models.dart';

class PostView extends StatelessWidget {
  final Post post;
  const PostView({Key? key, required this.post}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final column = Column(
      children: [
        buildTitle(context),
        buildDetail(context),
        buildBody(context),
        buildComments(context),
      ],
    );

    final padding = Padding(
      padding: const EdgeInsets.all(10),
      child: column,
    );

    final child = SingleChildScrollView(
      child: padding,
    );

    return Scaffold(
      appBar: AppBar(title: Text(post.title),),
      body: child,
    );
  }

  Widget buildTitle(BuildContext context) {
    return Row(
      children: [
        Text(post.title, style: Theme.of(context).textTheme.headline1,)
      ],
    );
  }

  Widget buildDetail(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(post.author.name),
        Column(
          children: [
            Text(post.category.name),
            Text(post.timestamp)
          ],
        )
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Html(data: post.body);
  }

  Widget buildComments(BuildContext context) {
    return Column(
      children: post.comments.map<Widget>((comment) => buildComment(context, comment)).toList()
    );
  }

  Widget buildComment(BuildContext context, Comment comment) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.125), width: 1),
      ),

      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(comment.user.name, style: const TextStyle(color: Colors.blue),),
              Text(comment.timestamp, style: const TextStyle(color: Colors.grey),)
            ],
          ),

          Wrap(
            children: [
              Text(comment.body)
            ],
          )
        ],
      ),
    );
  }
}

class PostManagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, GlobalState state, child) {
          final column = Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPostShortcuts(context, state),
              buildPagination(context, state),
            ],
          );

          final scroll = SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: column),
                buildCategories(context, state)
              ],
            ),
          );

          return scroll;
        }
    );
  }

  Widget buildPostShortcuts(BuildContext context, GlobalState state) {
    return Column(
      children: state.shortcuts.map<PostShortcutWidget>((shortcut) => PostShortcutWidget(shortcut: shortcut)).toList(),
    );
  }

  Widget buildPagination(BuildContext context, GlobalState state) {
    return Pagination(
        onPrev: () async {
          if(state.currentIndex > 0) {
            try {
              await state.setPageIndex(state.currentIndex - 1);
            } on DioError catch(error) {
              handleDioError(context, error);
            }
          }
        },
        onNext: () async {
          if(state.currentIndex < state.totalPage - 1) {
            try {
              await state.setPageIndex(state.currentIndex + 1);
            } on DioError catch(error) {
              handleDioError(context, error);
            }
          }
        }
    );
  }

  Widget buildCategories(BuildContext context, GlobalState state) {
    List<Widget> children = [
      TextButton(
        child: const Text("all", style: TextStyle(color: Colors.red),),
        onPressed: () async {
          await state.findData();
          state.notifyListeners();
        },
      )
    ];

    children.addAll(state.categories.map<Widget>((cateogry) => TextButton(
      child: Text(cateogry.name),
      onPressed: () async {
        await state.setCategory(cateogry);
      },
    )));

    return Column(
      children: children,
    );
  }
}

class PostAddPage extends StatefulWidget {
  @override
  PostAddState createState() => PostAddState();
}

class PostAddState extends State<PostAddPage> {
  final TextEditingController inputTitle = TextEditingController();
  final TextEditingController inputBody = TextEditingController();
  String selected = "default";

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, GlobalState state, child) => Column(
          children: [
            buildInputTitle(context),
            buildSelect(context, state),
            buildInputBody(context),
            buildFooter(context, state),
          ],
        )
    );

  }

  Widget buildInputTitle(BuildContext context) {
    return TextField(
      controller: inputTitle,
      decoration: const InputDecoration(
          labelText: "标题",
          hintText: "输入标题",
          prefixIcon: Icon(Icons.text_increase)
      ),
    );
  }

  Widget buildSelect(BuildContext context, GlobalState state) {
    return DropdownButton<String>(
        value: selected,
        items: state.categories.map<DropdownMenuItem<String>>((x) => DropdownMenuItem(value: x.name, child: Text(x.name), )).toList(),
        onChanged: (String? value) {
          setState(() {
            selected = value!;
          });
        }
    );
  }

  Widget buildInputBody(BuildContext context) {
    return TextField(
      controller: inputBody,
      maxLines: 8,
      decoration: const InputDecoration(
        labelText: "输入正文",
        hintText: "从这里输入"
      ),
    );
  }

  Widget buildFooter(BuildContext context, GlobalState state) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: handleCancel,
          child: const Text("cancel"),
        ),

        ElevatedButton(
          child: const Text("submit"),
          onPressed: () async {
            await handleSubmit(state);
          },
        ),
      ],
    );

    final padding = Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: row,
    );

    return padding;
  }

  Future<void> handleSubmit(GlobalState state) async {
    final PostRequest postRequest = PostRequest(title: inputTitle.text, body: inputBody.text, category: selected);
    try {
      await state.insertPost(postRequest);
    } on DioError catch(error) {
      handleDioError(context, error);
    } finally {
      handleCancel();
    }

  }

  void handleCancel() {
    inputTitle.text = "";
    inputBody.text = "";
  }
}

class PostEditPage extends StatefulWidget {
  final Post post;
  PostEditPage({required this.post});

  @override
  PostEditPageState createState() => PostEditPageState();
}

class PostEditPageState extends State<PostEditPage> {
  final TextEditingController inputTitle = TextEditingController();
  final TextEditingController inputBody = TextEditingController();
  String selected = "default";

  @override
  void initState() {
    inputTitle.text = widget.post.title;
    inputBody.text = widget.post.body;
    selected = widget.post.category.name;
  }

  @override
  Widget build(BuildContext context) {
    final column = Consumer(
      builder: (context, GlobalState state, child) => Column(
        children: [
          buildInputTitle(context),
          buildSelect(context, state),
          buildInputBody(context),
          buildFooter(context, state)
        ],
      ),
    );

    final padding = Padding(
      padding: const EdgeInsets.all(32),
      child: column,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Editting ${widget.post.title}"),),
      body: SingleChildScrollView(
        child: padding,
      ),
    );
  }

  Widget buildInputTitle(BuildContext context) {
    return TextField(
      controller: inputTitle,
      decoration: const InputDecoration(
          labelText: "标题",
          hintText: "输入标题",
          prefixIcon: Icon(Icons.text_increase)
      ),
    );
  }

  Widget buildSelect(BuildContext context, GlobalState state) {
    return DropdownButton<String>(
        value: selected,
        items: state.categories.map<DropdownMenuItem<String>>((x) => DropdownMenuItem(value: x.name, child: Text(x.name))).toList(),
        onChanged: (String? value) {
          setState(() {
            selected = value!;
          });
        }
    );
  }

  Widget buildInputBody(BuildContext context) {
    return TextField(
        controller: inputBody,
        maxLines: 8,
        decoration: const InputDecoration(
          labelText: "输入正文",
          hintText: "从这里输入"
        ),
    );
  }

  Widget buildFooter(BuildContext context, GlobalState state) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          child: const Text("cancel"),
          onPressed: () {handleCancel(context);},
        ),

        ElevatedButton(
          child: const Text("submit"),
          onPressed: () async {
            await handleSubmit(context, state);
          },
        ),
      ],
    );

    final padding = Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: row,
    );

    return padding;
  }

  Future<void> handleSubmit(BuildContext context, GlobalState state) async {
    widget.post.title = inputTitle.text;
    widget.post.body = inputBody.text;
    widget.post.category.name = selected;

    try {
      await state.updatePost(widget.post);
    } on DioError catch(error) {
      handleDioError(context, error);
    } finally {
      handleCancel(context);
    }

  }

  void handleCancel(BuildContext context) {
    inputTitle.text = "";
    inputBody.text = "";
    Navigator.of(context).pop();
  }

}

class CategoryManagePage extends StatelessWidget {
  final TextEditingController categoryName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, GlobalState state, child) {
          final categories = state.categories;
          // return Column(
          //   children: categories.map<Widget>((category) => buildCategory(context, category, state)).toList(),
          // );
          final list = ListView.separated(
              itemCount: categories.length,
              itemBuilder: (context, index) => buildCategory(context, categories[index], state),
              separatorBuilder: (context, index) => const Divider(color: Colors.grey),
          );

          return list;
        }
    );
  }

  Widget buildCategory(BuildContext context, Category category, GlobalState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(category.name),
        Row(
          children: [
            TextButton(
              child: const Text("Edit"),
              onPressed: () async {
                await handleEdit(context, category, state);
              },
            ),

            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                try {
                  await state.deleteCategory(category);
                } on DioError catch (error) {
                  handleDioError(context, error);
                }
              },
            )
          ],
        )
      ],
    );
  }

  Future<void> handleEdit(BuildContext context, Category category, GlobalState state) async {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Input new category name"),
        content: TextField(
          controller: categoryName,
        ),
        actions: [
          TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("cancel")),
          TextButton(
            child: const Text("submit"),
            onPressed: () async {
              try {
                category.name = categoryName.text;
                await state.updateCategory(category);
                Navigator.of(context).pop();
              } on DioError catch(error) {
                handleDioError(context, error);
              }
            },
          )
        ],
      );
    });

  }
}

class CategoryAddPage extends StatelessWidget {
  final TextEditingController categoryName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, GlobalState state, child) {
        return Column (
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(controller: categoryName,),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  child: const Text("cancel"),
                  onPressed: () {

                  },
                ),

                ElevatedButton(
                  child: const Text("submit"),
                  onPressed: () async {
                    try {
                      await state.insertCategory(categoryName.text);
                    } on DioError catch(error) {
                      handleDioError(context, error);
                    } finally {
                      categoryName.text = "";
                    }
                  },
                )
              ],
            )
          ],
        );

      },
    );
  }
}
class LoginPage extends StatelessWidget {
  TextEditingController usernameController = TextEditingController(text: "steiner");
  TextEditingController passwordController = TextEditingController(text: "password");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"),),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    final headIcon = Container(
      padding: const EdgeInsets.all(60),
      child: const Icon(Icons.login, size: 100,),
    );

    final usernameInput = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        controller: usernameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Username",
          hintText: "Enter username"
        ),
      ),
    );

    final passwordInput = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          hintText: "Enter secure password"
        ),
      ),
    );

    final loginButton = Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Consumer(
          builder: (context, GlobalState state, child) {
            return ElevatedButton(
              child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 25),),
              onPressed: () async {
                try {
                  final token = await login(
                      username: usernameController.text,
                      password: passwordController.text);
                  await state.setToken(token);

                  // Navigator.of(context).pushNamed("home");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => DefaultTabController(length: 4, child: HomePage())));
                } on DioError catch (error) {
                  handleDioError(context, error);
                } finally {
                  usernameController.text = "";
                  passwordController.text = "";
                }
              },

            );
          },
        )
    );

    final column = Column(
      children: [
        headIcon,
        usernameInput,
        passwordInput,
        loginButton,
      ],
    );

    return column;
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        bottom: const TabBar(
          tabs: [
            Tab(text: "PostManage",),
            Tab(text: "PostAdd",),
            Tab(text: "CategoryManage",),
            Tab(text: "CategoryAdd",)
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Logout", style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: TabBarView(
          children: [
            PostManagePage(),
            PostAddPage(),
            CategoryManagePage(),
            CategoryAddPage()
          ],
        ),
      )
    );
  }
}

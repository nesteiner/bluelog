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
        buildBody(context)
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
}

class PostManagePage extends StatefulWidget {
  @override
  PostManagePageState createState() => PostManagePageState();
}

class PostManagePageState extends State<PostManagePage>{
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
        child: Text("all", style: TextStyle(color: Colors.red),),
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
    return Column(
      children: [
        buildInputTitle(context),
        buildSelect(context),
        buildInputBody(context),
        buildFooter(context)
      ],
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

  Widget buildSelect(BuildContext context) {
    return Consumer(
        builder: (context, GlobalState state, child) {
          return DropdownButton<String>(
              value: selected,
              items: state.categories.map<DropdownMenuItem<String>>((x) => DropdownMenuItem(child: Text(x.name), value: x.name,)).toList(),
              onChanged: (String? value) {
                setState(() {
                  selected = value!;
                });
              }
          );
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

  Widget buildFooter(BuildContext context) {
    final consumer = Consumer(
        builder: (context, GlobalState state, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                child: const Text("cancel"),
                onPressed: handleCancel,
              ),

              ElevatedButton(
                child: const Text("submit"),
                onPressed: () async {
                  await handleSubmit(state);
                },
              ),
            ],
          );
        }
    );

    return consumer;
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
  Post post;
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
    final column = Column(
      children: [
        buildInputTitle(context),
        buildSelect(context),
        buildInputBody(context),
        buildFooter(context)
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Editting ${widget.post.title}"),),
      body: column,
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

  Widget buildSelect(BuildContext context) {
    return Consumer(
        builder: (context, GlobalState state, child) {
          return DropdownButton<String>(
              value: selected,
              items: state.categories.map<DropdownMenuItem<String>>((x) => DropdownMenuItem(child: Text(x.name), value: x.name,)).toList(),
              onChanged: (String? value) {
                setState(() {
                  selected = value!;
                });
              }
          );
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

  Widget buildFooter(BuildContext context) {
    final consumer = Consumer(
        builder: (context, GlobalState state, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
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
        }
    );

    return consumer;
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
          return Column(
            children: categories.map<Widget>((category) => buildCategory(context, category, state)).toList(),
          );
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
        return Column(
          children: [
            TextField(controller: categoryName,),
            Row(
              children: [
                TextButton(
                  child: const Text("cancel"),
                  onPressed: () {

                  },
                ),

                TextButton(
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
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
              labelText: "用户名",
              hintText: "用户名",
              prefixIcon: Icon(Icons.person)
          ),
        ),

        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
              labelText: "密码",
              hintText: "密码",
              prefixIcon: Icon(Icons.lock)
          ),
        ),

        Consumer(builder: (context, GlobalState state, child) {
          return ElevatedButton(
            child: const Text("Login"),
            onPressed: () async {
              try {
                final token = await login(username: usernameController.text,
                    password: passwordController.text);
                await state.setToken(token);

                // Navigator.of(context).pushNamed("home");
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => DefaultTabController(length: 4, child: HomePage())));
              } on DioError catch (error) {
                handleDioError(context, error);
              } finally {
                usernameController.text = "";
                passwordController.text = "";
              }
            },
          );
        })

      ],
    );

    final padding = Padding(
      padding: const EdgeInsets.all(24),
      child: column,
    );

    return padding;
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
      ),
      body: TabBarView(
        children: [
          PostManagePage(),
          PostAddPage(),
          CategoryManagePage(),
          CategoryAddPage()
        ],
      ),
    );
  }
}

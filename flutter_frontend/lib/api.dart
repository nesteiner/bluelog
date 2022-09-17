import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/models.dart';

final options = BaseOptions(
  baseUrl: "http://localhost:8082/api"
);

final dio = Dio(options);

String _formatToken(String token) {
  return "Bearer ${token}";
}

Future<String> login({required String username, required String password}) async {
  Response response = await dio.post("/authenticate", data: {
    "username": username,
    "password": password
  });

  return response.data["jwttoken"];
}

Future<PagePostShortcut> findPostShortcuts(int pageindex, String token) async {
  Response response = await dio.get(
      "/post?pageindex=${pageindex}",
      options: Options(headers: {
        "Authorization": _formatToken(token)
      }));
  return PagePostShortcut.fromJson(response.data["data"]);
}

Future<PagePostShortcut> findPostShortcutByCategory(int pageindex, String category, String token) async {
  Response response = await dio.get(
    "/post?pageindex=${pageindex}&category=${category}",
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );

  return PagePostShortcut.fromJson(response.data["data"]);
}

Future<PostShortcut> insertPost(PostRequest postRequest, String token) async {
  Response response = await dio.post(
    "/post",
    data: PostRequest.toJson(postRequest),
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );

  PostShortcut shortcut = PostShortcut.fromJson(response.data["data"]);
  return shortcut;
}

Future<void> deletePost(int id, String token) async {
  await dio.delete(
    "/post/${id}",
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );
}

Future<PostShortcut> updatePost(Post post, String token) async {
  Response response = await dio.put(
    "/post",
    data: post.toJson(),
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );

  PostShortcut shortcut = PostShortcut.fromJson(response.data["data"]);
  return shortcut;
}

Future<Post> findPost(int id, String token) async {
  Response response = await dio.get(
    "/post/${id}",
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );

  Post post = Post.fromJson(response.data["data"]);
  return post;
}

Future<Category> insertCategory(String categoryName, String token) async {
  Response response = await dio.post(
    "/category",
    data: {"name": categoryName},
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );

  Category category = Category.fromJson(response.data["data"]);
  return category;
}

Future<void> deleteCategory(int id, String token) async {
  await dio.delete(
    "/category/${id}",
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );
}

Future<Category> updateCategory(Category category, String token) async {
  Response response = await dio.put(
    "/category",
    data: category.toJson(),
    options: Options(headers: {
      "Authorization": _formatToken(token)
    })
  );

  return Category.fromJson(response.data["data"]);
}
Future<List<Category>> findCategories(String token) async {
  Response response = await dio.get(
      "/category",
      options: Options(
          headers: {
            "Authorization": _formatToken(token)
          }
      )
  );

  return response.data["data"].map<Category>((_json) => Category.fromJson(_json)).toList();
}

void handleDioError(BuildContext context, DioError error) {
  showDialog(context: context, builder: (context) {
    print(error.response!.data);
    return AlertDialog(
      title: Text("Error occurs"),
      content: Text(error.response!.data["message"]),
      actions: [
        TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text("确定"))
      ],
    );
  });

  if(error.response!.statusCode == 401) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api.dart' as api;

import 'package:flutter_frontend/models.dart';

class GlobalState extends ChangeNotifier {
  late String token;
  late List<PostShortcut> shortcuts;
  late List<Category> categories;
  int currentIndex = 0;
  int totalPage = 0;

  Future<void> findData() async {
    final pagePostShortcut = await api.findPostShortcuts(currentIndex, token);
    categories = await api.findCategories(token);
    totalPage = pagePostShortcut.totalPage;
    shortcuts = pagePostShortcut.shortcuts;
  }

  Future<void> findDataByCategory(Category category) async {
    final pagePostShortcut = await api.findPostShortcutByCategory(currentIndex, category.name, token);
    categories = await api.findCategories(token);
    totalPage = pagePostShortcut.totalPage;
    shortcuts = pagePostShortcut.shortcuts;
  }

  Future<void> setToken(String token) async {
    this.token = token;
    await findData();
  }

  Future<PostShortcut> insertPost(PostRequest post) async {
    final newpost = await api.insertPost(post, token);

    await findData();

    return newpost;
  }

  Future<void> deletePost(int id) async {
    await api.deletePost(id, token);
    int index = shortcuts.indexWhere((element) => element.postid == id);
    if(index != -1) {
      shortcuts.removeAt(index);
      await findData();
      notifyListeners();
    }
  }

  Future<PostShortcut> updatePost(Post post) async {
    final newpost = await api.updatePost(post, token);
    int index = shortcuts.indexWhere((element) => element.postid == post.id);
    if(index != -1) {
      shortcuts[index] = newpost;
      notifyListeners();
    }

    return newpost;
  }

  Future<Post> findPost(int id) async {
    final post = await api.findPost(id, token);
    return post;
  }

  Future<void> setCategory(Category category) async {
    currentIndex = 0;
    await findDataByCategory(category);
    notifyListeners();
  }

  Future<void> setPageIndex(int pageindex) async {
    currentIndex = pageindex;
    await findData();
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    await api.deleteCategory(category.id, token);
    categories.remove(category);
    notifyListeners();
  }

  Future<Category> updateCategory(Category category) async {
    final Category newcategory = await api.updateCategory(category, token);
    final index = categories.indexWhere((element) => element.id == category.id);
    if(index != -1) {
      categories[index] = newcategory;
      await findData();
      notifyListeners();
    }

    return newcategory;
  }

  Future<Category> insertCategory(String categoryName) async {
    final Category category = await api.insertCategory(categoryName, token);
    categories.add(category);
    notifyListeners();

    return category;
  }
}
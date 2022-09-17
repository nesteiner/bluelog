class User {
  int id;
  String name;
  String email;

  User({
    required this.id,
    required this.name,
    required this.email
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"]
    );
  }
}

class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name
    };
  }

  static Category fromJson(Map<String, dynamic> json) {
    return Category(id: json["id"], name: json["name"]);
  }
}

class Comment {
  int id;
  User user;
  String body;
  String timestamp;

  Comment({
    required this.id,
    required this.user,
    required this.body,
    required this.timestamp
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user": user.toJson(),
      "body": body,
      "timestamp": timestamp
    };
  }

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(id: json["id"], user: User.fromJson(json["user"]), body: json["body"], timestamp: json["timestamp"]);
  }

}

class Post {
  int id;
  String title;
  String body;
  String timestamp;
  User author;
  Category category;
  List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.author,
    required this.category,
    required this.comments
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "timestamp": timestamp,
      "author": author.toJson(),
      "category": category.toJson(),
      "comments": comments.map((x) => x.toJson()).toList()
    };
  }

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      timestamp: json["timestamp"],
      author: User.fromJson(json["author"]),
      category: Category.fromJson(json["category"]),
      comments: json["comments"].map<Comment>((_json) => Comment.fromJson(_json)).toList()
    );
  }
}

class PostRequest {
  String title;
  String body;
  String category;

  PostRequest({
    required this.title,
    required this.body,
    required this.category
  });

  static Map<String, dynamic> toJson(PostRequest request) {
    return {
      "title": request.title,
      "body": request.body,
      "category": request.category
    };
  }
}

class PostShortcut {
  int postid;
  String title;
  User author;
  String shortcut;
  Category category;

  PostShortcut({
    required this.postid,
    required this.title,
    required this.author,
    required this.shortcut,
    required this.category
  });

  static PostShortcut fromJson(Map<String, dynamic> json) {
    return PostShortcut(
      postid: json["postid"],
      title: json["title"],
      author: User.fromJson(json["author"]),
      shortcut: json["shortcut"],
      category: Category.fromJson(json["category"])
    );
  }
}

class PagePostShortcut {
  int totalPage;
  List<PostShortcut> shortcuts;

  PagePostShortcut({
    required this.totalPage,
    required this.shortcuts
  });

  static PagePostShortcut fromJson(Map<String, dynamic> json) {
    return PagePostShortcut(totalPage: json["totalPage"], shortcuts: json["shortcuts"].map<PostShortcut>((_json) => PostShortcut.fromJson(_json)).toList());
  }
}
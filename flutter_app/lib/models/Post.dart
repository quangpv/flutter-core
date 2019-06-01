import 'package:flutter_app/core/LiteDatabase.dart';
import 'package:flutter_app/core/Serializable.dart';

class Post implements Serializable {
  String title;

  String body;

  Post({this.title, this.body});

  static fromList(List json) {
    List<Post> posts = List();
    json.forEach((js) => posts.add(from(js)));
    return posts;
  }

  static from(Map<String, dynamic> js) => Post(
        title: js["title"],
        body: js["body"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "title": title,
        "body": body,
      };

  static ModelTable entity = ModelTable(Post, {
    "title": ModelColumn(String),
    "body": ModelColumn(String),
  });
}

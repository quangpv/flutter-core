class Post {
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
}

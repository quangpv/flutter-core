import 'package:flutter_app/core/Lazy.dart';
import 'package:flutter_app/core/LiteDatabase.dart';
import 'package:flutter_app/models/Post.dart';

class AppDatabase {
  LiteDatabase _db;
  Lazy<PostDao> _post;

  AppDatabase() {
    this._db = LiteDatabase(
      name: "app_database",
      models: [
        Post.entity,
      ],
      version: 2,
    );
    this._post = Lazy.of(() => PostDao(_db));
  }

  PostDao postDao() => _post.get();
}

class PostDao extends LiteDao {
  PostDao(LiteDatabase database) : super(database);

  Future savePosts(List<Post> post) async => await database.insert(post);

  Future<List<Post>> getPosts() async =>
      Post.fromList(await database.get<List>("select * from $Post"));
}

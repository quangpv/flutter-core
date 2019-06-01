import 'package:flutter_app/core/LiteDatabase.dart';
import 'package:flutter_app/models/Post.dart';

class AppDatabase extends LiteDatabase {
  PostDao _post;

  AppDatabase()
      : super(
          name: "app_database",
          models: [
            Post.entity,
          ],
          version: 2,
        );

  PostDao postDao() {
    if (_post == null) _post = PostDao(this);
    return _post;
  }
}

class PostDao extends LiteDao {
  PostDao(LiteDatabase database) : super(database);

  Future savePosts(List<Post> post) async => await database.insert(post);

  Future<List<Post>> getPosts() async =>
      Post.fromList(await database.get<List>("select * from $Post"));
}

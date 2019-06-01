import 'package:flutter_app/app/ApiClient.dart';
import 'package:flutter_app/app/AppCache.dart';
import 'package:flutter_app/app/AppDatabase.dart';
import 'package:flutter_app/core/TemporaryData.dart';
import 'package:flutter_app/models/Post.dart';
import 'package:flutter_app/resources/AppResources.dart';

class PostRepository {
  static const MAX_TIMEOUT = 3000;

  final AppCache _appCache;
  final ApiClient _apiClient;
  AppDatabase _database;

  var _posts = TemporaryData<List<Post>>(timeout: MAX_TIMEOUT);

  PostRepository(this._appCache, this._apiClient, this._database);

  Future<List<Post>> get posts async {
    var userId = (await _appCache.getUser()).id;
    var data = await _posts.loadIfNeeded(
        userId, () async => await _database.postDao().getPosts());
    if (data.isNotEmpty) return data;
    data = Post.fromList(await _apiClient.get(RA.posts(userId)));
    await _database.postDao().savePosts(data);
    _posts.put(userId, data);
    return data;
  }
}

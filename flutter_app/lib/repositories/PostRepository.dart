import 'package:flutter_app/app/ApiClient.dart';
import 'package:flutter_app/app/AppCache.dart';
import 'package:flutter_app/core/DependenceContext.dart';
import 'package:flutter_app/core/LiteDatabase.dart';
import 'package:flutter_app/core/TemporaryData.dart';
import 'package:flutter_app/models/Post.dart';
import 'package:flutter_app/resources/AppResources.dart';

class PostRepository {
  static const MAX_TIMEOUT = 3000;

  final AppCache _appCache;
  final ApiClient _apiClient;
  var _posts = TemporaryData<List<Post>>(timeout: MAX_TIMEOUT);

  LiteDatabase get _database => inject();

  PostRepository(this._appCache, this._apiClient);

  Future<List<Post>> get posts async {
    var userId = (await _appCache.getUser()).id;
    return _posts.loadIfNeeded(userId,
        () async => Post.fromList(await _apiClient.get(RA.posts(userId))));
  }
}

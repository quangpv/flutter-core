import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/AppStateModel.dart';
import 'package:flutter_app/core/BaseState.dart';
import 'package:flutter_app/core/DependenceContext.dart';
import 'package:flutter_app/models/Post.dart';
import 'package:flutter_app/repositories/PostRepository.dart';
import 'package:flutter_app/resources/AppResources.dart';
import 'package:flutter_app/widgets/SupportListView.dart';

class HomeFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeDetailState();
}

class _HomeDetailState extends StateWidget<HomeFragment, HomeDetailStateModel> {
  @override
  Widget buildWidget(BuildContext context) => Stack(
        children: <Widget>[
          SupportListView<Post>(
            buildItem: itemView,
            items: this.stateModel.posts,
          ),
          loading(stateModel.isLoading),
        ],
      );

  Widget itemView(Post item, int pos, int viewType) => Container(
        alignment: AlignmentDirectional.topStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: resources.getDimen(RD.text_size_18),
              ),
            ),
            Text(
              item.body,
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(resources.getDimen(RD.size_10)),
      );

  loading(bool isLoading) => Center(
        child: Visibility(
          child: CircularProgressIndicator(
              strokeWidth: resources.getDimen(RD.size_2)),
          visible: isLoading,
        ),
      );
}

class HomeDetailStateModel extends AppStateModel {
  List<Post> posts = List();

  PostRepository get postRepo => inject();

  @override
  void onInitState() {
    launch(() async {
      var result = await postRepo.posts;
      if (posts == result) return false;
      posts = result;
      return true;
    });
  }
}

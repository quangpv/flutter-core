import 'package:flutter/cupertino.dart';

class SupportListView<T> extends StatelessWidget {
  final List<T> items;

  final Widget Function(T item , int pos, int viewType) buildItem;

  final int Function(int) viewType;

  const SupportListView({
    Key key,
    @required this.items,
    @required this.buildItem,
    this.viewType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        children: _listWidget(),
      );

  _listWidget() {
    var list = List<Widget>();
    var funViewType = viewType != null ? viewType : (type) => type;
    for (var i = 0; i < items.length; i++) {
      list.add(buildItem(items[i], i, funViewType(i)));
    }
    return list;
  }
}

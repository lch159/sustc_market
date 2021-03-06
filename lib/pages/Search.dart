import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sustc_market/pages/Select.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

Set<String> _historySet = new Set();
List<HistoryRow> _historyList = new List<HistoryRow>();

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = new TextEditingController();
  bool _hasdeleteIcon = false;



  @override
  void initState() {
    // TODO: implement initState
    _historySet = new Set();
    _historyList = new List<HistoryRow>();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0))),
              suffixIcon: _hasdeleteIcon
                  ? new Container(
                      width: 20.0,
                      height: 20.0,
                      child: new IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0.0),
                        iconSize: 18.0,
                        icon: Icon(Icons.cancel),
                        color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            searchController.text = "";
                            _hasdeleteIcon = (searchController.text.isNotEmpty);
                          });
                        },
                      ),
                    )
                  : new Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
            ),
            autofocus: true,
            onEditingComplete: () {
              setState(() {
                if (!_historySet.contains(searchController.text)) {
                  _historySet.add(searchController.text);
                  _historyList.insert(
                      0,
                      HistoryRow(
                        text: searchController.text,
                      ));
                  Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
                      (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return new SelectPage(searchText: searchController.text,);
                  }, transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                      ) {
                    // 添加一个平移动画
                    return createTransition(animation, child);
                  }));
                }

              });
            },
            onChanged: (str) {
              setState(() {
                _hasdeleteIcon = (searchController.text.isNotEmpty);
              });
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '热门',
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  padding: EdgeInsets.only(
                      left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(90.0)),
                  child: Text(
                    "热门1",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  padding: EdgeInsets.only(
                      left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(90.0)),
                  child: Text(
                    "热门2",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  padding: EdgeInsets.only(
                      left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(90.0)),
                  child: Text(
                    "热门3",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  padding: EdgeInsets.only(
                      left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(90.0)),
                  child: Text(
                    "热门4",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  padding: EdgeInsets.only(
                      left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(90.0)),
                  child: Text(
                    "热门5",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              height: 10.0,
              color: Colors.black12,
            ),
            Align(
              alignment: FractionalOffset.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '历史搜索',
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
            ),
            Divider(),
            Column(
              children: _historyList,
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              padding: EdgeInsets.all(5.0),
              child: OutlineButton(
                borderSide: BorderSide(color: Colors.grey),
                child: Text(
                  '清除搜索记录',
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.black45),
                ),
                onPressed: () {
                  return showDialog<Null>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('确定要清除搜索记录吗？'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('确定'),
                            onPressed: () {
                              setState(() {
                                _historySet.clear();
                                _historyList.clear();
                                searchController.clear();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}

class HistoryRow extends StatefulWidget {
  const HistoryRow({
    Key key,
    this.child,
    this.text,
  }) : super(key: key);
  final Widget child;
  final String text;

  @override
  _HistoryRowState createState() => _HistoryRowState();
}

class _HistoryRowState extends State<HistoryRow> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.text,
                  style: TextStyle(color: Colors.black45),
                ),
//                IconButton(
//                  padding: EdgeInsets.all(0.0),
//                  iconSize: 15.0,
//                  color: Colors.black45,
//                  icon: Icon(Icons.clear),
//                  onPressed: () {
//                    _historySet.remove(widget.text);
//                    _historyList.remove(_historyList.indexOf())
//                  },
//                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
 SlideTransition createTransition(
Animation<double> animation, Widget child) {
return new SlideTransition(
position: new Tween<Offset>(
begin: const Offset(1.0, 0.0),
end: const Offset(0.0, 0.0),
).animate(animation),
child: child,
);
}
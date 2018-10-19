import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
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
            controller: TextEditingController(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0))),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Colors.grey,
                onPressed: () {},
              ),
            ),
          ),
        ),
        actions: <Widget>[Icon(Icons.format_list_bulleted)],
      ),
      body: Column(
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
//          Divider(color: Colors.black45,),
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
          Align(
            alignment: FractionalOffset.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
              child: Text(
                "历史纪录1",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
          Divider(),
          Align(
            alignment: FractionalOffset.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
              child: Text(
                "历史纪录2",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
          Divider(),

          Align(
            alignment: FractionalOffset.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
              child: Text(
                "历史纪录3",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
          Divider(),

          Container(
            margin: EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.all(5.0),
//            decoration: BoxDecoration(
//                color: Colors.grey,
//                borderRadius: BorderRadius.circular(90.0)),
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
                          child: Text('同意'),
                          onPressed: () {
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
      resizeToAvoidBottomPadding: true,
    );
  }
}

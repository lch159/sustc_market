import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustc_market/main.dart';
import 'package:sustc_market/pages/Production.dart';

class MyPublishPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPublishPageState();
  }
}

class _MyPublishPageState extends State<MyPublishPage> {
  var _isLogin = false;
  var _username = "";
  var _email = "";
  var _tempid = "";

  List<ProductionCard> _items = new List();

  RefreshController _refreshController = new RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLoginInfo().then((String value) {
      upgradeItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildItemsColumn(context),
    );
  }

  Future<String> readLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoginState = prefs.getString("isLogin");
    setState(() {
      print("here ---$isLoginState");
      if (isLoginState == "1") {
        _isLogin = true;
        _username = prefs.getString("username");
        _email = prefs.getString("email");
        _tempid = prefs.getString("temporaryid");
      } else {
        _isLogin = false;
      }
    });

    return isLoginState;
  }

  void upgradeItems() async {
    Dio dio = new Dio();
    FormData data = new FormData.from({
      "temporaryid": _tempid,
    });
    print("tempis:$_tempid");
    String url = "http://120.79.232.137:8080/helloSSM/dommodity/personalSelect";

    dio.interceptor.response.onSuccess = (Response response) async {
      // 在返回响应数据之前做一些预处理
      Map<String, dynamic> data = response.data;

      if (data["returncode"] == "200") {
        setState(() {
          var number = int.parse(data["dommoditynumber"]);
          _items = new List<ProductionCard>();
          for (int i = 0; i < number; i++) {
            Map<String, dynamic> item = data["dommoditylist"][i];
            _items.insert(
                0,
                ProductionCard(
                  id: item['id'],
                  imagePath: "images/LOGO/1x/logo_mdpi.jpg",
                  title: item["name"],
                  description: item["description"],
                  owner: item["owner"],
                  status: item["status"],
                  putAwayTime: item["putawayTime"],
                  availableTime: item["availableTime"],
                  price: item["price"],
                  address: item["address"],
                  payment: item["paytype"],
                ));
          }
        });
      }
      return response; // continue
    };
    dio.interceptor.response.onError = (DioError e) {
      // 当请求失败时做一些预处理
      print("connect error");
      showModalBottomSheet<Null>(
          context: context,
          builder: (BuildContext context) {
            return new Container(
                child: new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text('网络错误，请检查网络',
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 24.0))));
          });
      return e; //continue
    };
    await dio.get(url, data: data);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        '我的发布',
      ),
    );
  }

  Widget buildItemsColumn(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      headerBuilder: (context, mode) {
        return SpinKitThreeBounce(
          color: Colors.blue,
          size: 50.0,
        );
      },
      onRefresh: (up) {
        if (up) {
          new Future.delayed(const Duration(milliseconds: 2000)).then((val) {
            upgradeItems();
            _refreshController.sendBack(true, RefreshStatus.failed);
          });
        } else {}
      },
      controller: _refreshController,
      headerConfig: RefreshConfig(
        visibleRange: 75.0,
        completeDuration: 300,
      ),
      enableOverScroll: true,
      child: ListView(
        children: _items,
      ),
    );
  }
}

//平移动画
SlideTransition createTransition(Animation<double> animation, Widget child) {
  return new SlideTransition(
    position: new Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation),
    child: child,
  );
}

class ProductionCard extends StatefulWidget {
  const ProductionCard({
    Key key,
    this.child,
    this.id,
    this.title,
    this.imagePath,
    this.price,
    this.address,
    this.owner,
    this.status,
    this.putAwayTime,
    this.payment,
    this.description,
    this.availableTime,
  }) : super(key: key);

  final Widget child;
  final String id;
  final String imagePath;
  final String status;
  final String owner;
  final String putAwayTime;
  final String availableTime;
  final String address;
  final String price;
  final String payment;
  final String title;
  final String description;

  @override
  _ProductionCardState createState() => _ProductionCardState();
}

DateTime stringParseToDate(String StringTime) {
  var parseTime = StringTime.split(" ");
  var year = parseTime[5];
  var month;
  switch (parseTime[1]) {
    case "Jan":
      month = "1";
      break;
    case "Feb":
      month = "";
      break;
    case "Mar":
      month = "3";
      break;
    case "Apr":
      month = "4";
      break;
    case "May":
      month = "5";
      break;
    case "Jun":
      month = "6";
      break;
    case "Jul":
      month = "7";
      break;
    case "Aug":
      month = "8";
      break;
    case "Sep":
      month = "9";
      break;
    case "Oct":
      month = "10";
      break;
    case "Nov":
      month = "11";
      break;
    case "Dec":
      month = "12";
      break;
  }
  var day = parseTime[2];
  var putAwayTime = parseTime[3].split(":");
  DateTime date = new DateTime(
      int.parse(year),
      int.parse(month),
      int.parse(day),
      int.parse(putAwayTime[0]),
      int.parse(putAwayTime[1]),
      int.parse(putAwayTime[2]));
  return date;
}

class _ProductionCardState extends State<ProductionCard> {
  String getTimeDifference() {
    DateTime startDate = stringParseToDate(widget.putAwayTime);
    var dif = DateTime.now().difference(startDate);
    if (dif.inDays == 0) {
      return "今天";
    } else if (dif.inDays >= 1 && dif.inDays < 30) {
      return dif.inDays.toString() + "天前";
    } else if (dif.inDays >= 30 && dif.inDays < 365) {
      var temp = dif.inDays % 30;
      return temp.toString() + "个月前";
    } else if (dif.inDays >= 365) {
      var temp = dif.inDays % 365;
      return temp.toString() + "年前";
    }
    return "-1";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 96.0,
              height: 96.0,
              child: Image.asset(
                'images/LOGO/1.5x/logo_hdpi.png',
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 5.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 2.0, bottom: 20.0, top: 10.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: RichText(
                        text: TextSpan(
                            text: '￥',
                            style: TextStyle(fontSize: 15.0, color: Colors.red),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.price,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.red),
                              ),
                              TextSpan(
                                text: '   ' +
                                    widget.status +
                                    '   ' +
                                    widget.address,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.black38),
                              ),
                            ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            getTimeDifference(),
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.black45),
                          ),
                          PopupMenuButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 15.0,
                                color: Colors.black45,
                              ),
                              padding: EdgeInsets.all(0.0),
                              onSelected: (String value) {
                                setState(() {});
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuItem<String>>[
                                    PopupMenuItem<String>(
                                        value: '编辑此商品', child: Text('编辑此商品')),
                                    PopupMenuItem<String>(
                                        value: '收藏此商品', child: Text('收藏此商品')),
                                  ])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              flex: 3,
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
              (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return new ProductionPage(
              title: widget.title,
              description: widget.description,
              owner: widget.owner,
//                  status:widget.status,
              putAwayTime: widget.putAwayTime,
//                  availableTime: widget.availableTime,
              price: widget.price,
              address: widget.address,
              payment: widget.payment,
            );
          }, transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
              ) {
            // 添加一个平移动画
            return createTransition(animation, child);
          }));

        },
      ),
    );
  }
}

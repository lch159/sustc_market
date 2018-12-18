import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sustc_market/pages/Production.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class SelectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectPageState();
  }
}

var sortValue;
var areaValue;

class _SelectPageState extends State<SelectPage> {
  bool _defaultFilter = false;
  bool _priceFilter = false;
  bool _timeFilter = false;
  bool _filterFilter = false;

  bool _defaultFilterActivated = true;
  bool _priceFilterActivated = false;
  bool _timeFilterActivated = false;

  bool _default = true;
  bool _priceFromLowToHigh = false;
  bool _latest = false;
  bool _priceFromHighToLow = false;

  RefreshController _refreshController = new RefreshController();
  TextEditingController priceFromController = new TextEditingController();
  TextEditingController priceToController = new TextEditingController();

  String _defaultFilterText = '默认排序';
  String _priceFrom = '起始价格';
  String _priceTo = '最高价格';
  String _dateFrom = '起始日期';
  String _dateTo = '最后日期';

  List<ProductionCard> items = new List<ProductionCard>();
  List<ProductionCard> originItem = new List<ProductionCard>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    upgradeItems();
  }

  void upgradeItems() async {
    Dio dio = new Dio();
    String url = "http://120.79.232.137:8080/helloSSM/dommodity/selectAll";
    Response response = await dio.get(url);

    Map<String, dynamic> data = response.data;
    if (response.statusCode != 200) {
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          AlertDialog(
            title: Text('无法连接到服务器，请检查网络'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      if (data["returncode"] == "200") {
        setState(() {
          var number = int.parse(data["dommoditynumber"]);
          items = new List<ProductionCard>();
          for (int i = 0; i < number; i++) {
            Map<String, dynamic> item = data["dommoditylist"][i];

            items.insert(
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
          originItem = items;
        });
      }
    }
  }

  void filterChangedTo(int filter, int subFilter) {
    switch (filter) {
      case 1:
        switch (subFilter) {
          case 1:
            _default = true;
            _priceFromLowToHigh = false;
            _latest = false;
            _priceFromHighToLow = false;
            _defaultFilterText = '默认排序';
            break;
          case 2:
            _default = false;
            _priceFromLowToHigh = false;
            _latest = true;
            _priceFromHighToLow = false;
            _defaultFilterText = '最新上传';
            break;
          case 3:
            _default = false;
            _priceFromLowToHigh = true;
            _latest = false;
            _priceFromHighToLow = false;
            _defaultFilterText = '价格升序';
            break;
          case 4:
            _default = false;
            _priceFromLowToHigh = false;
            _latest = false;
            _priceFromHighToLow = true;
            _defaultFilterText = '价格降序';
            break;
        }
        _defaultFilterActivated = true;
        _priceFilterActivated = false;
        _timeFilterActivated = false;

        priceFromController.clear();
        priceToController.clear();
        _defaultFilter = false;

        _priceFrom = '最低价';
        _priceTo = '最高价';
        _dateFrom = '起始日期';
        _dateTo = '最后日期';
        break;
      case 2:
        _defaultFilterActivated = false;
        _priceFilterActivated = true;
        _timeFilterActivated = false;

        _default = false;
        _priceFromLowToHigh = false;
        _latest = false;
        _priceFromHighToLow = false;
        if (subFilter == 2) _priceFilter = false;

        _dateFrom = '起始日期';
        _dateTo = '最后日期';

        break;
      case 3:
        _defaultFilterActivated = false;
        _priceFilterActivated = false;
        _timeFilterActivated = true;

        priceFromController.clear();
        priceToController.clear();

        _default = false;
        _priceFromLowToHigh = false;
        _latest = false;
        _priceFromHighToLow = false;
        if (subFilter == 2) _timeFilter = false;

        _priceFrom = '最低价';
        _priceTo = '最高价';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: SmartRefresher(
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
          children: <Widget>[
            buildTabRow(context),
            Divider(),
            buildDefaultFilter(context),
            buildPriceFilter(context),
            buildTimeFilter(context),
            Column(
              children: items,
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
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
      actions: <Widget>[
        PopupMenuButton<String>(
            icon: Icon(Icons.format_list_bulleted),
            onSelected: (String value) {
              setState(() {});
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(value: '我的信息', child: Text('我的信息')),
                  PopupMenuItem<String>(value: '我的消息', child: Text('我的消息')),
                  PopupMenuItem<String>(value: '我的订单', child: Text('我的订单'))
                ])
      ],
    );
  }

  Padding buildTabRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: _defaultFilterActivated
                  ? const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 5.0)))
                  : const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                      width: 5.0,
                      color: Colors.white10,
                    ))),
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  setState(() {
                    _defaultFilter = !_defaultFilter;
                    _timeFilter = false;
                    _priceFilter = false;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      _defaultFilterText,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: _defaultFilterActivated
                              ? Colors.blue
                              : Colors.black),
                    ),
                    Icon(
                        _defaultFilter
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: _defaultFilterActivated
                            ? Colors.blue
                            : Colors.black)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: _priceFilterActivated
                  ? const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 5.0)))
                  : const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.white10, width: 5.0))),
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  setState(() {
                    _defaultFilter = false;
                    _timeFilter = false;
                    _priceFilter = !_priceFilter;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      '价格区间',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: _priceFilterActivated
                              ? Colors.blue
                              : Colors.black),
                    ),
                    Icon(
                        _priceFilter
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color:
                            _priceFilterActivated ? Colors.blue : Colors.black)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: _timeFilterActivated
                  ? const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 5.0)))
                  : const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.white10, width: 5.0))),
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  setState(() {
                    _timeFilter = !_timeFilter;
                    _priceFilter = false;
                    _defaultFilter = false;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      '时间区间',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: _timeFilterActivated
                              ? Colors.blue
                              : Colors.black),
                    ),
                    Icon(
                        _timeFilter
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color:
                            _timeFilterActivated ? Colors.blue : Colors.black)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Text(
                    '筛选',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildDefaultFilter(BuildContext context) {
    return Column(
      children: _defaultFilter
          ? <Widget>[
              FlatButton(
                child: Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 2.0, bottom: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _default
                          ? <Widget>[
                              Text(
                                '默认',
                                style: TextStyle(
                                    color:
                                        _default ? Colors.blue : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _default ? Colors.blue : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '默认',
                                style: TextStyle(
                                    color:
                                        _default ? Colors.blue : Colors.black),
                              ),
                            ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    items.sort(
                        (a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

                    filterChangedTo(1, 1);
                  });
                },
              ),
              Divider(),
              FlatButton(
                child: Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 2.0, bottom: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _latest
                          ? <Widget>[
                              Text(
                                '最新上传',
                                style: TextStyle(
                                    color:
                                        _latest ? Colors.blue : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _latest ? Colors.blue : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '最新上传',
                                style: TextStyle(
                                    color:
                                        _latest ? Colors.blue : Colors.black),
                              ),
                            ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    filterChangedTo(1, 2);
                    items.sort((a, b) {
                      var putAwayDateA = a.putAwayTime.split("-")[0].split("/");
                      var putAwayTimeA = a.putAwayTime.split("-")[1].split(":");
                      DateTime startDateA = new DateTime(
                          int.parse(putAwayDateA[0]),
                          int.parse(putAwayDateA[1]),
                          int.parse(putAwayDateA[2]),
                          int.parse(putAwayTimeA[0]),
                          int.parse(putAwayTimeA[1]),
                          int.parse(putAwayTimeA[2]));
                      var startDifA =
                          DateTime.now().difference(startDateA).inMicroseconds;
                      var putAwayDateB = b.putAwayTime.split("-")[0].split("/");
                      var putAwayTimeB = b.putAwayTime.split("-")[1].split(":");
                      DateTime startDateB = new DateTime(
                          int.parse(putAwayDateB[0]),
                          int.parse(putAwayDateB[1]),
                          int.parse(putAwayDateB[2]),
                          int.parse(putAwayTimeB[0]),
                          int.parse(putAwayTimeB[1]),
                          int.parse(putAwayTimeB[2]));
                      var startDifB =
                          DateTime.now().difference(startDateB).inMicroseconds;
                      return startDifA.compareTo(startDifB);
                    });
                  });
                },
              ),
              Divider(),
              FlatButton(
                child: Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 2.0, bottom: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _priceFromLowToHigh
                          ? <Widget>[
                              Text(
                                '价格从低到高',
                                style: TextStyle(
                                    color: _priceFromLowToHigh
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _priceFromLowToHigh
                                      ? Colors.blue
                                      : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '价格从低到高',
                                style: TextStyle(
                                    color: _priceFromLowToHigh
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                            ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    filterChangedTo(1, 3);
                    items.sort((a, b) =>
                        int.parse(a.price).compareTo(int.parse(b.price)));
                  });
                },
              ),
              Divider(),
              FlatButton(
                child: Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 2.0, bottom: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _priceFromHighToLow
                          ? <Widget>[
                              Text(
                                '价格从高到低',
                                style: TextStyle(
                                    color: _priceFromHighToLow
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _priceFromHighToLow
                                      ? Colors.blue
                                      : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '价格从高到低',
                                style: TextStyle(
                                    color: _priceFromHighToLow
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                            ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    filterChangedTo(1, 4);
                    items.sort((a, b) =>
                        int.parse(b.price).compareTo(int.parse(a.price)));
                  });
                },
              ),
              Container(
                height: 5.0,
              ),
            ]
          : <Widget>[],
    );
  }

  Padding buildPriceFilter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _priceFilter
            ? <Widget>[
                Expanded(
                    child:
                        Align(alignment: Alignment.center, child: Text('从'))),
                Expanded(
                  child: TextField(
                    controller: priceFromController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: _priceFrom,
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(90.0))),
                    ),
                    onSubmitted: (val) {
                      setState(() {
                        _priceFrom = val;
                        filterChangedTo(2, 1);
                      });
                    },
                  ),
                  flex: 2,
                ),
                Expanded(
                    child:
                        Align(alignment: Alignment.center, child: Text('到'))),
                Expanded(
                  child: TextField(
                    controller: priceToController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: _priceTo,
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(90.0))),
                    ),
                    onSubmitted: (val) {
                      setState(() {
                        _priceTo = val;
                        filterChangedTo(2, 2);
                        print("-------------------");
                        originItem = items;
                        for (int i = 0; i < items.length; i++) {
                          print(items[i].price);
                        }
                        print(priceFromController.text);
                        print(priceToController.text);
                        print("before--");
                        for (int i = 0; i < items.length; i++) {

                          print(items[i].price);
                          if (int.parse(items[i].price) <
                                  int.parse(priceFromController.text) ||
                              int.parse(items[i].price) >
                                  int.parse(priceToController.text)) {
                            items.remove(items[i]);
                          }
                        }
                        print("after--");

                        for (int i = 0; i < items.length; i++) {
                          print(items[i].price);
                        }
                      });
                    },
                  ),
                  flex: 2,
                ),
              ]
            : <Widget>[],
      ),
    );
  }

  Column buildTimeFilter(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: _timeFilter
              ? <Widget>[
                  Expanded(
                      child:
                          Align(alignment: Alignment.center, child: Text('从'))),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          locale: 'zh',
                          minYear: 2010,
                          maxYear: 2018,
                          initialYear: 2018,
                          initialMonth: 6,
                          initialDate: 21,
                          dateFormat: 'yyyy-mm-dd',
                          onConfirm: (year, month, date) {
                            setState(() {
                              filterChangedTo(3, 1);
                              _dateFrom = year.toString() +
                                  "." +
                                  month.toString() +
                                  "." +
                                  date.toString();
                            });
                          },
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Text(_dateFrom),
                          Icon(Icons.date_range)
                        ],
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                      child:
                          Align(alignment: Alignment.center, child: Text('到'))),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          locale: 'zh',
                          minYear: 2010,
                          maxYear: 2020,
                          initialYear: 2018,
                          initialMonth: 6,
                          initialDate: 21,
                          dateFormat: 'yyyy-mm-dd',
                          onConfirm: (year, month, date) {
                            setState(() {
                              filterChangedTo(3, 2);
                              _dateTo = year.toString() +
                                  "." +
                                  month.toString() +
                                  "." +
                                  date.toString();
                            });
                          },
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Text(_dateTo),
                          Icon(Icons.date_range)
                        ],
                      ),
                    ),
                    flex: 2,
                  ),
                ]
              : <Widget>[],
        ),
        Container(
          height: 5.0,
        ),
      ],
    );
  }
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

class _ProductionCardState extends State<ProductionCard> {
  String getTimeDifference() {
    var putAwayDate = widget.putAwayTime.split("-")[0].split("/");
    var putAwayTime = widget.putAwayTime.split("-")[1].split(":");
    DateTime startDate = new DateTime(
        int.parse(putAwayDate[0]),
        int.parse(putAwayDate[1]),
        int.parse(putAwayDate[2]),
        int.parse(putAwayTime[0]),
        int.parse(putAwayTime[1]),
        int.parse(putAwayTime[2]));
    var dif = DateTime.now().difference(startDate);
    if (dif.inDays == 0) {
      return dif.inHours.toString() + "小时前";
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
                        padding: EdgeInsets.only(left: 2.0, bottom: 20.0,top: 10.0),
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
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.red),
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
                        children: <Widget>[
                          Text(
                            getTimeDifference(),
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.owner,
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
                                        value: '举报此商品', child: Text('举报此商品')),
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              //指定跳转的页面
              return ProductionPage(
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
            },
          ));
        },
      ),
    );
  }
}

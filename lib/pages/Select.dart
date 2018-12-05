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
  bool _sales = false;
  bool _distance = false;
  bool _comment = false;

  RefreshController _refreshController = new RefreshController();
  TextEditingController priceFromController = new TextEditingController();
  TextEditingController priceToController = new TextEditingController();

  String _defaultFilterText = '综合';
  String _priceFrom = '起始价格';
  String _priceTo = '最高价格';
  String _dateFrom = '起始日期';
  String _dateTo = '最后日期';

  List<ProductionCard> items = new List<ProductionCard>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upgradeItems();
  }

  void upgradeItems() async {
    Dio dio = new Dio();
    Response response = await dio
        .get("http://120.79.232.137:8080/helloSSM/dommodity/selectAll");

    Map<String, dynamic> data = response.data;
    if (response.statusCode != 200) {
      return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
        var number = int.parse(data["dommoditynumber"]);
        items = new List<ProductionCard>();

        for (int i = 0; i < number; i++) {
          Map<String, dynamic> item = data["dommoditylist"][i];
          print(item.toString());

          items.insert(0,ProductionCard(
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
      }
    }
  }

  void filterChangedTo(int filter, int subFilter) {
    switch (filter) {
      case 1:
        switch (subFilter) {
          case 1:
            _default = true;
            _sales = false;
            _distance = false;
            _comment = false;
            _defaultFilterText = '综合';
            break;
          case 2:
            _default = false;
            _sales = true;
            _distance = false;
            _comment = false;
            _defaultFilterText = '销量';
            break;
          case 3:
            _default = false;
            _sales = false;
            _distance = true;
            _comment = false;
            _defaultFilterText = '距离';
            break;
          case 4:
            _default = false;
            _sales = false;
            _distance = false;
            _comment = true;
            _defaultFilterText = '评论数';
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
        _sales = false;
        _distance = false;
        _comment = false;
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
        _sales = false;
        _distance = false;
        _comment = false;
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
          }
          else {


          }
        },
        controller: _refreshController,
        headerConfig: RefreshConfig(
          visibleRange: 75.0,
          completeDuration: 300,
        ),
        enableOverScroll: true,
        child: ListView(
          children:
            <Widget>[
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
                      '价格',
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
                      '时间',
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
                                '综合',
                                style: TextStyle(
                                    color:
                                        _default ? Colors.blue : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _default ? Colors.blue : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '综合',
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
                      children: _sales
                          ? <Widget>[
                              Text(
                                '销量',
                                style: TextStyle(
                                    color: _sales ? Colors.blue : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _sales ? Colors.blue : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '销量',
                                style: TextStyle(
                                    color: _sales ? Colors.blue : Colors.black),
                              ),
                            ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    filterChangedTo(1, 2);
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
                      children: _distance
                          ? <Widget>[
                              Text(
                                '距离由近到远',
                                style: TextStyle(
                                    color:
                                        _distance ? Colors.blue : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _distance ? Colors.blue : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '距离由近到远',
                                style: TextStyle(
                                    color:
                                        _distance ? Colors.blue : Colors.black),
                              ),
                            ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    filterChangedTo(1, 3);
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
                      children: _comment
                          ? <Widget>[
                              Text(
                                '评论数从高到低',
                                style: TextStyle(
                                    color:
                                        _comment ? Colors.blue : Colors.black),
                              ),
                              Icon(Icons.check,
                                  color: _comment ? Colors.blue : Colors.black)
                            ]
                          : <Widget>[
                              Text(
                                '评论数从高到低',
                                style: TextStyle(
                                    color:
                                        _comment ? Colors.blue : Colors.black),
                              ),
                            ],
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    filterChangedTo(1, 4);
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

  Column buildPriceFilter(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
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
                          filterChangedTo(2, 1);
                          _priceFrom = val;
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
                          filterChangedTo(2, 2);
                          _priceTo = val;
                        });
                      },
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
                              print(_dateFrom);
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
                              print(_dateTo);
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
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
                          padding: EdgeInsets.only(left: 2.0, bottom: 20.0),
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
                              widget.owner,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black45),
                            ),
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
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          height: 2.0,
          color: Colors.black12,
        ),
      ],
    );
  }
}

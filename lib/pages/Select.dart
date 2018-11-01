import 'package:flutter/material.dart';
import 'package:sustc_market/pages/Production.dart';


class SelectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectPageState();
  }
}

var sortValue;
var areaValue;

class _SelectPageState extends State<SelectPage> {
  bool _defaultActive = false;
  bool _priceActive = false;
  bool _timeActive = false;
  bool _filterActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        leading: Container(),
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
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: _defaultActive
                        ? const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.blue, width: 5.0)))
                        : const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.white, width: 5.0))),
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        setState(() {
                          _defaultActive = !_defaultActive;
                          _timeActive = false;
                          _priceActive = false;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            '综合',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: _defaultActive
                                    ? Colors.blue
                                    : Colors.black),
                          ),
                          Icon(
                              _defaultActive
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color:
                                  _defaultActive ? Colors.blue : Colors.black)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: _priceActive
                        ? const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.blue, width: 5.0)))
                        : const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.white, width: 5.0))),
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        setState(() {
                          _defaultActive = false;
                          _timeActive = false;
                          _priceActive = !_priceActive;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            '价格',
                            style: TextStyle(
                                fontSize: 16.0,
                                color:
                                    _priceActive ? Colors.blue : Colors.black),
                          ),
                          Icon(
                              _priceActive
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: _priceActive ? Colors.blue : Colors.black)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: _timeActive
                        ? const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.blue, width: 5.0)))
                        : const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.white, width: 5.0))),
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        setState(() {
                          _timeActive = !_timeActive;
                          _priceActive = false;
                          _defaultActive = false;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            '时间',
                            style: TextStyle(
                                fontSize: 16.0,
                                color:
                                    _timeActive ? Colors.blue : Colors.black),
                          ),
                          Icon(
                              _timeActive
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: _timeActive ? Colors.blue : Colors.black)
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
          ),
          Divider(),
          Column(
            children: _defaultActive
                ? <Widget>[
                    FlatButton(
                      child: Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 5.0, bottom: 5.0),
                          child: Text(
                            '综合',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Divider(),
                    FlatButton(
                      child: Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 5.0, bottom: 5.0),
                          child: Text(
                            '销量',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Divider(),
                    FlatButton(
                      child: Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 5.0, bottom: 5.0),
                          child: Text(
                            '距离由近到远',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Divider(),
                    FlatButton(
                      child: Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 5.0, bottom: 5.0),
                          child: Text(
                            '评论数从高到低',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Divider(),
                  ]
                : <Widget>[],
          ),
          Row(
            children: _priceActive
                ? <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment.center, child: Text('从'))),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '最低价',
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(90.0))),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center, child: Text('到'))),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '最高价',
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(90.0))),
                        ),
                      ),
                      flex: 2,
                    ),
                    Divider(),
                  ]
                : <Widget>[],
          ),
          Row(
            children: _timeActive
                ? <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment.center, child: Text('从'))),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          showDatePicker(
                            context: this.context,
                            initialDate: DateTime(2018, 1, 1, 0, 0, 0, 0),
                            firstDate: DateTime(2018, 1, 1, 0, 0, 0, 0),
                            lastDate: DateTime(2019, 12, 12, 0, 0, 0, 0),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Text('起始日期'),
                            Icon(Icons.date_range)
                          ],
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center, child: Text('到'))),
                    Divider(),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          showDatePicker(
                            context: this.context,
                            initialDate: DateTime(2018, 1, 1, 0, 0, 0, 0),
                            firstDate: DateTime(2018, 1, 1, 0, 0, 0, 0),
                            lastDate: DateTime(2019, 12, 12, 0, 0, 0, 0),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Text('最后日期'),
                            Icon(Icons.date_range)
                          ],
                        ),
                      ),
                      flex: 2,
                    ),
                    Divider(),
                  ]
                : <Widget>[],
          ),
          ProductionCard(
            imagePath: 'images/tempItems/p1.jpg',
            title: '出顾家北手把手教你雅思写作',
            price: '20',
            status: '',
            area: '湖畔',
            owner: '1511XXX',
          ),
          ProductionCard(
            imagePath: 'images/tempItems/p2.png',
            title: '收一个USB转串口数据线',
            price: '面议',
            status: '',
            area: '湖畔',
            owner: '1517XXX',
          ),
          ProductionCard(
            imagePath: 'images/tempItems/p3.jpg',
            title: '出外星人17r3 配置如图',
            price: '面议',
            status: '',
            area: '湖畔',
            owner: '14XXXXXX',
          ),
          ProductionCard(
            imagePath: 'images/tempItems/p5.jpg',
            title: '收这本书',
            price: '40',
            status: '',
            area: '湖畔',
            owner: '1511XXX',
          ),
          ProductionCard(
            imagePath: 'images/tempItems/p6.jpg',
            title: '出一瓶这个',
            price: '45',
            status: '',
            area: '湖畔',
            owner: '18XXXXX',
          ),
          ProductionCard(
            imagePath: 'images/tempItems/p7.png',
            title: '试收一颗这个型号的纽扣电池',
            price: '10',
            status: '',
            area: '湖畔',
            owner: '1511XXX',
          ),
          ProductionCard(
            imagePath: 'images/tempItems/p8.jpg',
            title: '代购YPL瘦腿裤薄款180秋冬加厚款210',
            price: '180',
            status: '',
            area: '湖畔',
            owner: '1627XXX',
          ),
//          ListView.builder(itemBuilder: (context, index){
//          return ProductionCard()
//          })
        ],
      ),
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
    this.area,
    this.owner,
    this.status,
  }) : super(key: key);

  final Widget child;
  final String imagePath;
  final String title;
  final String price;
  final String status;
  final String area;
  final String owner;

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
                  widget.imagePath,
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
                              style: TextStyle(fontSize: 15.0, color: Colors.red),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.price,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.red),
                                ),
                                TextSpan(
                                  text: widget.status + '   ' + widget.area,
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black45),
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
          ), onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              //指定跳转的页面
              return ProductionPage();
            },
          ));
        }
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

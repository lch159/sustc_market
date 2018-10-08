import 'package:flutter/material.dart';
import 'pages/Login.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(new MaterialApp(
    title: 'SUSTech Market',
    home: new MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  bool isCheck = false;
  var leftRightPadding = 15.0;
  var topBottomPadding = 5.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.error_outline),
            color: Colors.white,
            tooltip: 'Anno',
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) {
                  //指定跳转的页面
                  return new LoginPage();
                },
              ));
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: HomeBuilder.homeDrawer(),
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new InnerRow(
                child: new CarouselSlider(
                    items: [1, 2, 3, 4, 5].map((i) {
                      return new Builder(
                        builder: (BuildContext context) {
                          return new Container(
                              width: MediaQuery.of(context).size.width,
                              margin: new EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: new BoxDecoration(color: Colors.grey),
                              child: new Text(
                                'text $i',
                                style: new TextStyle(fontSize: 16.0),
                              ));
                        },
                      );
                    }).toList(),
                    height: 150.0,
                    autoPlay: true),
              ),
              new InnerRow(
                child: new Card(
                  elevation: 2.0,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new RaisedButton(
                                color: Colors.white12,
                                onPressed: null,
                                child: new Text("分类")),
                            new RaisedButton(
                                color: Colors.white12,
                                onPressed: null,
                                child: new Text("分类")),
                          ],
                        ),
                        flex: 1,
                      ),
                      new Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new RaisedButton(
                                color: Colors.white12,
                                onPressed: null,
                                child: new Text("分类")),
                            new RaisedButton(
                                color: Colors.white12,
                                onPressed: null,
                                child: new Text("分类")),
                          ],
                        ),
                        flex: 1,
                      ),
                      new Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new RaisedButton(
                                color: Colors.white12,
                                onPressed: null,
                                child: new Text("分类")),
                            new RaisedButton(
                                color: Colors.white12,
                                onPressed: null,
                                child: new Text("分类")),
                          ],
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                ),
              ),
              new InnerRow(
                child: new ItemCard(
                  image: "images/LOGO/1.5x/logo_hdpi.png",
                  title: "itemName",
                  price: "888888",
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBuilder.homeBottomBar(),
      floatingActionButton: HomeBuilder.homeFloatingButton(),
    );
  }
}

class HomeBuilder {
  static Widget homeProductions() {
    for (int i = 0; i < 10; i++) {}
  }

  //浮动按钮
  static Widget homeFloatingButton() {
    return new FloatingActionButton(
      child: new Icon(Icons.add),
      onPressed: null,
    );
  }

  //底部导航栏
  static Widget homeBottomBar() {
    return new BottomNavigationBar(items: [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            '主页',
          )),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.people,
          ),
          title: Text(
            '附近',
          )),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
          ),
          title: Text(
            '消息',
          )),
    ]);
  }

  //侧边栏
  static Widget homeDrawer() {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      new UserAccountsDrawerHeader(
        currentAccountPicture: new CircleAvatar(
            backgroundImage: new AssetImage("images/LOGO/4x/logo_xxxhdpi.jpg")),
        accountName: new Text(
          "UserName",
        ),
        accountEmail: new Text(
          "UserEmail@example.com",
        ),
        onDetailsPressed: () {},
      ),
      new ClipRect(
        child: new ListTile(
          leading:
              new CircleAvatar(child: new Icon(Icons.perm_contact_calendar)),
          title: new Text('我的信息'),
          onTap: () => {},
        ),
      ),
      new ListTile(
        leading: new CircleAvatar(child: new Icon(Icons.add_shopping_cart)),
        title: new Text('我的交易'),
        subtitle: new Text("我买的和我卖的"),
        onTap: () => {},
      ),
      new ListTile(
        leading: new CircleAvatar(child: new Icon(Icons.settings)),
        title: new Text('设置'),
        onTap: () => {},
      ),
      new AboutListTile(
        icon: new CircleAvatar(child: new Text("Ab")),
        child: new Text("关于"),
        applicationName: "Test",
        applicationVersion: "1.0",
        applicationLegalese: "applicationLegalese",
        aboutBoxChildren: <Widget>[
          new Text("BoxChildren"),
          new Text("box child 2")
        ],
      ),
    ]);
  }
}

class InnerRow extends StatefulWidget {
  const InnerRow({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _InnerRowState createState() => new _InnerRowState();
}

class _InnerRowState extends State<InnerRow> {
  double _leftMargin = 0.0;
  double _topMargin = 10.0;
  double _rightMargin = 0.0;
  double _bottomMargin = 10.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Expanded(
            child: new Container(),
            flex: 1,
          ),
          new Expanded(
            child: widget.child,
            flex: 30,
          ),
          new Expanded(
            child: new Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key key,
    this.child,
    this.image,
//    this.owner,
    this.price,
    this.title,
  }) : super(key: key);
  final Widget child;
  final String image;
  final String title;
  final String price;

//  final Widget owner;

  @override
  _ItemCardState createState() => new _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        height: 144.0,
        child: new Card(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                child: new Container(
                  child: new Image.asset(widget.image),
                ),
                flex: 3,
              ),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                          child: new Text(
                        widget.title,
                        style: new TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20.0,
                            color: Colors.black),
                      )),
                      flex: 1,
                    ),
                    new Expanded(
                      child: new Container(
                          child: new Text(
                        "￥" + widget.price,
                        style: new TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 25.0,
                            color: Colors.red),
                      )),
                      flex: 1,
                    ),
                  ],
                ),
                flex: 3,
              ),
              new Expanded(
                child: new Container(

                ),
                flex: 2,
              ),
            ],
          ),
        ));
  }
}

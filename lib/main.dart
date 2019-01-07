import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustc_market/pages/Chatting.dart';
import 'package:sustc_market/pages/MyOrder.dart';
import 'package:sustc_market/pages/MyPublish.dart';
import 'package:sustc_market/pages/Production.dart';
import 'package:sustc_market/pages/Search.dart';
import 'package:sustc_market/pages/Login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sustc_market/pages/Select.dart';
import 'package:sustc_market/pages/Settings.dart';
import 'package:sustc_market/pages/Upload.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
//  final channel = await IOWebSocketChannel.connect("ws://localhost:1234");
//
//  channel.stream.listen((message) {
//    channel.sink.add("received!");
//    channel.sink.close(status.goingAway);
//  });

  runApp(MaterialApp(
    title: 'SUSTech Market',
    home: MainPage(),
//    store: store,
  ));
}

class MainPage extends StatefulWidget {
  MainPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int tabIndex = 0;

  List<ItemRow> _items = new List<ItemRow>();
  List<MessageCard> _messageCardList = new List();

  var _isLogin = false;
  var _username = "";
  var _temporaryid = "";
  var _email = "";
  var _number = 10;
  WebSocketChannel _channel;

  RefreshController _refreshProductionController = new RefreshController();
  RefreshController _refreshMessageController = new RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upgradeItems(FormData.from({
      "conditions": "",
      "orders": "order by putawayTime desc",
      "number": "limit 10",
    }));

    readLoginInfo().then((loginInfo) {
//      getUnreceivedMessages();
      _loadMessagesList();
      _connectWebServer(_temporaryid);
    });
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
    _channel.sink.close();
  }

  void _loadMessagesList() async {
    _messageCardList = new List();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> messageName = preferences.getStringList("messages");
    if (messageName != null) {
      for (int i = messageName.length - 1; i > -1; i--) {
        var parsedName = messageName[i].split(",")[0].split("_");
        if (parsedName[0] == _username) {
          List<String> messages = preferences.getStringList(messageName[i]);
          if (messages.length != 0) {
            List<String> lastMessage = messages[0].split(",");
            MessageCard message = MessageCard(
              lastTime: lastMessage[3],
              lastMessage: lastMessage[2],
              senderName: lastMessage[1],
            );
            setState(() {
              _messageCardList.add(message);
            });
          }
        }
      }
    }
  }

  void _connectWebServer(String temporaryid) {
    _channel = IOWebSocketChannel.connect(
        "ws://120.79.232.137:8080/helloSSM/webSocket");
    _channel.sink.add("login," + temporaryid);
    _channel.stream.listen((message) {
      var temp = message.toString().split(",");
      print(temp.toString());
      if (temp.length == 5) {
        setState(() {
          _handleReceivedMessage(temp[1], temp[2], temp[3], temp[4]);
//          _loadMessagesList();
        });
      }
    });
  }

  void _handleReceivedMessage(
    String source,
    String destination,
    String text,
    String time,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> messageName = preferences.getStringList("messages");
    String name = source + "_" + destination;
//    String antiName = destination + "_" + source;
    List<String> newList;
    if (messageName != null) {
      if (messageName.contains(name)) {
        print("here1");
        newList = preferences.getStringList(name);
      } else {
        print("here3");

        messageName.insert(0, name);
        preferences.setStringList("messages", messageName);
        newList = new List();
        setState(() {
          MessageCard messageCard = MessageCard(
            senderName: source,
            lastMessage: text,
            lastTime: time,
          );
          _messageCardList.insert(0, messageCard);
        });
      }
    } else {
      print("here2");

      newList = new List();
      newList.insert(0, name);
      preferences.setStringList("messages", newList);
      setState(() {
        MessageCard messageCard = MessageCard(
          senderName: source,
          lastMessage: text,
          lastTime: time,
        );
        _messageCardList.insert(0, messageCard);
      });
    }
    newList.insert(
        0, source + "," + destination + "," + text + "," + time + "," + "true");
    print("here4" + newList.toString());
    preferences.setStringList(name, newList);
  }

  Future<String> readLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoginState = prefs.getString("isLogin");
    _isLogin = isLoginState == "1" ? true : false;
    if (isLoginState == "1") {
      _isLogin = true;
      _username = prefs.getString("username");
      _temporaryid = prefs.getString("temporaryid");
      _email = prefs.getString("email");
    } else {
      _isLogin = false;
    }

    return isLoginState;
  }

  Future<String> getTempID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tempID = prefs.getString("temporaryid");
    return tempID;
  }

  void upgradeItems(FormData data) async {
    Dio dio = new Dio();
    String url =
        "http://120.79.232.137:8080/helloSSM/dommodity/conditionalSelect";

    _items = new List();
    dio.interceptor.response.onSuccess = (Response response) {
      Map<String, dynamic> data = response.data;
      if (data["returncode"] == "200") {
        setState(() {
          var number = int.parse(data["dommoditynumber"]);
          _items = new List<ItemRow>();

          for (int i = number - 1; i > -1;) {
            Map<String, dynamic> ritem;
            Map<String, dynamic> litem;
            Widget leftCard;
            Widget rightCard;
            if (number % 2 == 1 && i == 0) {
              litem = data["dommoditylist"][0];
              rightCard = Container(width: 0.0, height: 0.0);
              i -= 1;
            } else {
              ritem = data["dommoditylist"][i];
              litem = data["dommoditylist"][i - 1];
              rightCard = ItemCard(
                imagePath: "images/LOGO/4x/logo_xxxhdpi.png",
                title: ritem["name"],
                description: ritem["description"],
                owner: ritem["owner"],
                status: ritem["status"],
                putAwayTime: ritem["putawayTime"],
                availableTime: ritem["availableTime"],
                price: ritem["price"],
                address: ritem["address"],
                payment: ritem["paytype"],
                operation: ritem["operation"],
                id: ritem["id"],
              );
              i -= 2;
            }
            leftCard = ItemCard(
              imagePath: "images/LOGO/4x/logo_xxxhdpi.png",
              title: litem["name"],
              description: litem["description"],
              owner: litem["owner"],
              status: litem["status"],
              putAwayTime: litem["putawayTime"],
              availableTime: litem["availableTime"],
              price: litem["price"],
              address: litem["address"],
              payment: litem["paytype"],
              operation: litem["operation"],
              id: litem["id"],
            );

            _items.insert(0, ItemRow(lchild: leftCard, rchild: rightCard));
          }
        });
      }
    };

//    dio.interceptor.response.onError = (DioError e) {
//      // 当请求失败时做一些预处理
//      print("connect error");
//      showDialog<Null>(
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text('网络未连接，请检查网络'),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('确定'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        },
//        context: null,
//      );
//
//      return e; //continue
//    };
//

    await dio.post(url, data: data);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(90.0))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.black26,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                    child: null,
                  ),
                  flex: 10,
                ),
              ],
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
        ]);
  }

  void remindLogin(BuildContext context) {
    if (!_isLogin) {
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("还未登录，点击确定进入登录页面"),
            actions: <Widget>[
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          );
        },
      );
    }
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
        child: ListView(padding: const EdgeInsets.only(), children: <Widget>[
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('images/LOGO/4x/logo_xxxhdpi.jpg')),
        accountName: Container(
          constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.0 + 10,
          ),
          child: FlatButton(
            onPressed: () {
              setState(() {
                if (!_isLogin) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  Navigator.pop(context);
                  tabIndex = 2;
                }
              });
            },
            child: Align(
              alignment: _isLogin ? Alignment.topLeft : Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(fontSize: 15.0, color: Colors.red),
                    children: <TextSpan>[
                      TextSpan(
                        text: _isLogin ? _username : '还未登录，点击登录',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      TextSpan(
                        text: _isLogin ? "\r\n$_email" : ' ',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ]),
              ),
            ),
          ),
        ),
        accountEmail: null,
      ),
      ClipRect(
        child: ListTile(
          leading: CircleAvatar(
              child: Icon(
            Icons.perm_contact_calendar,
          )),
          title: Text(
            '我的信息',
            style: TextStyle(fontSize: 15.0),
          ),
          onTap: () {
            setState(() {
              if (!_isLogin) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else {
                Navigator.pop(context);
                tabIndex = 2;
              }
            });
          },
        ),
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.add_shopping_cart)),
        title: Text(
          '我的发布',
          style: TextStyle(fontSize: 15.0),
        ),
        onTap: () {
          remindLogin(context);
          if (_isLogin) {
            Navigator.of(context).pop();
            Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
                (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
              return new MyPublishPage();
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
        },
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.settings)),
        title: Text(
          '设置',
          style: TextStyle(fontSize: 15.0),
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
              (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
            return new SettingsPage();
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
      AboutListTile(
        icon: CircleAvatar(child: Text('Ab')),
        child: Text(
          '关于',
          style: TextStyle(fontSize: 15.0),
        ),
        applicationName: 'Test',
        applicationVersion: '1.0',
        applicationLegalese: 'applicationLegalese',
        aboutBoxChildren: <Widget>[Text('BoxChildren'), Text('box child 2')],
      ),
      Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 10,
        ),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: _isLogin
                ? FlatButton(
                    onPressed: () {
                      Future<bool> logout() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var isLogin = prefs.setString("isLogin", "0");
                        prefs.setString("temporaryid", "0");
                        return isLogin;
                      }

                      logout();
                      showDialog<Null>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("退出登录成功"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("确定"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    color: Colors.red,
                    child: Text(
                      "退出登录",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    color: Colors.green,
                    child: Text(
                      "登录",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
      ),
    ]));
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              '主页',
            )),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
          ),
          title: Text(
            '消息',
          ),
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text(
              '我的',
            )),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: tabIndex,
      onTap: (index) {
        setState(() {
          tabIndex = index;
        });
      },
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      elevation: 7.0,
      highlightElevation: 14.0,
      onPressed: () {
        setState(() {
          Future<String> isLoginState = readLoginInfo();
          isLoginState.then((String isLoginState) {
            if (isLoginState == "1") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadPage()));
            } else {
              showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("上传商品需要登录账户，\n是否要现在登录"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("确定"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(new PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                            return new LoginPage();
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
            }
          });
        });
      },
    );
  }

  Widget buildBody(BuildContext context) {
    Widget bodyWidget;
    switch (tabIndex) {
      case 0:
        bodyWidget = buildMainHome(context);
        break;
      case 1:
        bodyWidget = buildMainMessage(context);
        break;
      case 2:
        bodyWidget = buildMainUserInfo(context);
        break;
    }
    return bodyWidget;
  }

  Widget _headerCreate(BuildContext context, int mode) {
    return ClassicIndicator(mode: mode);
  }

  ValueNotifier<double> topOffsetLis = new ValueNotifier(0.0);
  ValueNotifier<double> bottomOffsetLis = new ValueNotifier(0.0);

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
    if (isUp) {
      topOffsetLis.value = offset;
    } else {
      bottomOffsetLis.value = offset;
    }
  }

  Widget buildMainHome(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      controller: _refreshProductionController,
      headerBuilder: _headerCreate,
      footerBuilder: _headerCreate,
      footerConfig: new RefreshConfig(),
      onRefresh: (up) {
        if (up) {
          _number = 10;
          upgradeItems(FormData.from({
            "conditions": "",
            "orders": "order by putawayTime desc",
            "number": "limit 10"
          }));
          new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
            _refreshProductionController.sendBack(
                true, RefreshStatus.completed);
          });
        } else {
          _number += 10;
          upgradeItems(FormData.from({
            "conditions": "",
            "orders": "order by putawayTime desc",
            "number": "limit " + _number.toString(),
          }));
          new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
            _refreshProductionController.sendBack(false, RefreshStatus.noMore);
          });
        }
      },
      onOffsetChange: _onOffsetCallback,
      child: ListView(
        children: <Widget>[
          CarouselSlider(
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.asset(
                          "images/Advertisements/ad$i.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              height: 150.0,
              autoPlay: true),
          Card(
              elevation: 2.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InnerButton(
                        text: Text('书本'),
                        child: Icon(Icons.book),
                      ),
                      InnerButton(
                        text: Text('食品'),
                        child: Icon(Icons.fastfood),
                      ),
                      InnerButton(
                        text: Text('工具'),
                        child: Icon(Icons.build),
                      ),
                      InnerButton(
                        text: Text('电子产品'),
                        child: Icon(Icons.phonelink),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InnerButton(
                        text: Text('化妆品'),
                        child: Icon(Icons.local_florist),
                      ),
                      InnerButton(
                        text: Text('服饰'),
                        child: Icon(
                          FontAwesomeIcons.tshirt,
                          size: 19.0,
                        ),
                      ),
                      InnerButton(
                        text: Text('信息资源'),
                        child: Icon(Icons.compare_arrows),
                      ),
                      InnerButton(
                        text: Text('全部'),
                        child: Icon(
                          Icons.subdirectory_arrow_right,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Divider(),
          Column(
            children: _items,
          )
        ],
      ),
    );
  }

  Widget buildMainMessage(BuildContext build) {
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshMessageController,
      headerBuilder: _headerCreate,
      onRefresh: (up) {
        if (up) {
          _loadMessagesList();
          new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
            _refreshMessageController.sendBack(true, RefreshStatus.completed);
          });
        } else {}
      },
      onOffsetChange: _onOffsetCallback,
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _messageCardList.length,
        itemBuilder: (_, index) => _messageCardList[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildSingleRow(BuildContext context, String text, bool isDivided,
      VoidCallback callback) {
    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                RichText(
                  text: TextSpan(
                      text: "",
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: "",
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                        ),
                      ]),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          onPressed: callback,
        ),
        isDivided
            ? Divider(
                height: 10.0,
              )
            : Container(
                width: 0.0,
                height: 5.0,
              ),
      ],
    );
  }

  Widget buildMainUserInfo(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Container(
//              color: Colors.blue,
                        width: 72.0,
                        height: 72.0,
                        margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image.asset(
                            "images/LOGO/4x/logo_xxxhdpi.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment:
                            _isLogin ? Alignment.topLeft : Alignment.bottomLeft,
                        child: RichText(
                          text: TextSpan(
                              text: ' ',
                              style: TextStyle(fontSize: 15.0),
                              children: <TextSpan>[
                                TextSpan(
                                  text: _isLogin ? _username : '还未登录，点击登录',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                                TextSpan(
                                  text: _isLogin ? "\r\n" + _email : ' ',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    if (!_isLogin)
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: RichText(
                        text: TextSpan(
                            text: ' ',
                            style: TextStyle(fontSize: 15.0),
                            children: <TextSpan>[
                              TextSpan(
                                text: '关注数',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black87),
                              ),
                              TextSpan(
                                text: '\r\n     0',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ]),
                      ),
                      onPressed: () {
                        remindLogin(context);
                      },
                    ),
                    FlatButton(
                      child: RichText(
                        text: TextSpan(
                            text: ' ',
                            style: TextStyle(fontSize: 15.0),
                            children: <TextSpan>[
                              TextSpan(
                                text: '粉丝数',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black87),
                              ),
                              TextSpan(
                                text: '\r\n     0',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ]),
                      ),
                      onPressed: () {
                        remindLogin(context);
                      },
                    ),
                    FlatButton(
                      child: RichText(
                        text: TextSpan(
                            text: ' ',
                            style: TextStyle(fontSize: 15.0),
                            children: <TextSpan>[
                              TextSpan(
                                text: '收藏数',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black87),
                              ),
                              TextSpan(
                                text: '\r\n     0',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ]),
                      ),
                      onPressed: () {
                        remindLogin(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                buildSingleRow(
                  context,
                  "我的交易",
                  true,
                      () {
                    if (_isLogin) {
                      Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
                          (BuildContext context, Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return new MyOrderPage();
                      }, transitionsBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child,
                          ) {
                        // 添加一个平移动画
                        return createTransition(animation, child);
                      }));
                    } else {
                      remindLogin(context);
                    }
                  },
                ),
                buildSingleRow(context, "我发布的", true, () {
                  if (_isLogin) {
                    Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
                        (BuildContext context, Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                      return new MyPublishPage();
                    }, transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      // 添加一个平移动画
                      return createTransition(animation, child);
                    }));
                  } else {
                    remindLogin(context);
                  }
                }),
                buildSingleRow(context, "我卖出的", true, () {
                  remindLogin(context);
                }),
                buildSingleRow(context, "我买到的", true, () {
                  remindLogin(context);
                }),
                buildSingleRow(context, "我收藏的", true, () {
                  remindLogin(context);
                }),
                buildSingleRow(context, "我的消息", false, () {
                  setState(() {
                    tabIndex = 1;
                  });
                }),
              ],
            ),
          ),
          Card(
            child: buildSingleRow(
              context,
              "设置",
              false,
              () {
                Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
                    (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                  return new SettingsPage();
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
          ),
        ],
      ),
    );
  }

  //平移动画
  static SlideTransition createTransition(
      Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: child,
    );
  }
}

//内部分类圆形控件
class InnerButton extends StatefulWidget {
  const InnerButton({Key key, this.child, this.text}) : super(key: key);
  final Widget child;
  final Widget text;

  @override
  _InnerButtonState createState() => _InnerButtonState();
}

class _InnerButtonState extends State<InnerButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          shape: CircleBorder(),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SelectPage()));
          },
          child: widget.child,
        ),
        widget.text
      ],
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key key,
    this.id,
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
    this.operation,
  }) : super(key: key);
  final String id;
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
  final String operation;

  @override
  _ItemCardState createState() => _ItemCardState();
}

//商品卡
class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 2.0,
      child: FlatButton(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Image.asset(
                  'images/LOGO/4x/logo_xxxhdpi.png',
                  fit: BoxFit.fill,
                ),
              ),
              flex: 4,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                alignment: Alignment.center,
                child: Text('￥' + widget.price,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.red),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              flex: 1,
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
                operation: widget.operation,
                id: widget.id,
              );
            },
          ));
        },
      ),
    );
  }
}

//商品行
class ItemRow extends StatefulWidget {
  const ItemRow({Key key, this.lchild, this.rchild}) : super(key: key);
  final Widget lchild;
  final Widget rchild;

  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 220.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: widget.lchild,
            flex: 1,
          ),
          Expanded(
            child: widget.rchild,
            flex: 1,
          ),
        ],
      ),
    );
  }
}

//消息卡片
class MessageCard extends StatelessWidget {
  MessageCard({this.lastMessage, this.lastTime, this.senderName});

  final String lastMessage;
  final String lastTime;
  final String senderName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FlatButton(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(senderName),
              Text(
                lastTime,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          subtitle: Text(lastMessage),
          //之前显示icon
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                color: Colors.blue),
            width: 50.0,
            height: 50.0,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          ),

          //之后显示checkBox
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChattingPage(
                        receiver: senderName,
                        isFromProduction: false,
                      )));
        },
      ),
    );
  }
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

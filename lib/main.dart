import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustc_market/Utils/redux/Store.dart';
import 'package:sustc_market/pages/Chatting.dart';
import 'package:sustc_market/pages/Production.dart';
import 'package:sustc_market/pages/Search.dart';
import 'package:sustc_market/pages/Login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sustc_market/pages/Select.dart';
import 'package:sustc_market/pages/Upload.dart';
import 'package:sustc_market/Utils/redux/Reducer.dart';

void main() {
  runApp(MaterialApp(
    title: 'SUSTech Market',
    home: MainPage(),
//    store: store,
  ));
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int tabIndex = 0;

  List<ItemRow> itemRows = new List<ItemRow>();
  var _isLogin = false;
  var _username = "";
  var _email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upgradeItems();
    readLoginInfo();
  }

  iniLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isLogin", "0");
    prefs.setString("temporaryid", "-1");
  }

  Future<String> readLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoginState = prefs.getString("isLogin");
    _isLogin = isLoginState == "1" ? true : false;
    if (isLoginState == "1") {
      _isLogin = true;
      _username = prefs.getString("username");
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

  void upgradeItems() async {
    Dio dio = new Dio();
    Response response = await dio
        .get("http://120.79.232.137:8080/helloSSM/dommodity/selectAll");

    Map<String, dynamic> data = response.data;
    print(response.headers);
    if (response.statusCode != 200) {
      showDialog<Null>(
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
        context: null,
      );
    } else {
      if (data["returncode"] == "200") {
        setState(() {
          var number = int.parse(data["dommoditynumber"]);
          itemRows = new List<ItemRow>();

          for (int i = 0; i < number;) {
            Map<String, dynamic> ritem;
            Map<String, dynamic> litem;
            Widget leftCard;
            Widget rightCard;
            if (number % 2 == 1 && i == 0) {
              litem = data["dommoditylist"][0];
              rightCard = Container(width: 0.0, height: 0.0);
              i += 1;
            } else {
              ritem = data["dommoditylist"][i];
              litem = data["dommoditylist"][i + 1];
              rightCard = ItemCard(
                imagePath: "images/LOGO/1x/logo_mdpi.jpg",
                title: ritem["name"],
                description: ritem["description"],
                owner: ritem["owner"],
                status: ritem["status"],
                putAwayTime: ritem["putawayTime"],
                availableTime: ritem["availableTime"],
                price: ritem["price"],
                address: ritem["address"],
                payment: ritem["paytype"],
              );
              i += 2;
            }
            leftCard = ItemCard(
              imagePath: "images/LOGO/1x/logo_mdpi.jpg",
              title: litem["name"],
              description: litem["description"],
              owner: litem["owner"],
              status: litem["status"],
              putAwayTime: litem["putawayTime"],
              availableTime: litem["availableTime"],
              price: litem["price"],
              address: litem["address"],
              payment: litem["paytype"],
            );

            print(ritem.toString());
            print(litem.toString());

            itemRows.insert(0, ItemRow(lchild: leftCard, rchild: rightCard));
          }
        });
      }
    }
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
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        if (!_isLogin) {
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
        } else {
          return AlertDialog(
            title: Text("还未开放，敬请期待"),
            actions: <Widget>[
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
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
//                      TextSpan(
//                        text: _isLogin ?  '\r\n' : '',
//                      ),
                      TextSpan(
                        text: _isLogin ? "\r\n" + _email : ' ',
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
            remindLogin(context);
          },
        ),
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.add_shopping_cart)),
        title: Text(
          '我的交易',
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Text('我买的和我卖的'),
        onTap: () {
          remindLogin(context);
        },
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.settings)),
        title: Text(
          '设置',
          style: TextStyle(fontSize: 15.0),
        ),
        onTap: () => {},
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
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

  SingleChildScrollView buildMainHome(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CarouselSlider(
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                        child: Icon(Icons.accessibility),
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
            children: itemRows,
          )
        ],
      ),
    );
  }

  ListView buildMainMessage(BuildContext build) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: FlatButton(
            child: ListTile(
              title: Text('UserName'),
              subtitle: Text('Message Content'),
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
              trailing: Text(
                '18:18',
                style: TextStyle(color: Colors.grey),
              ),
              //之后显示checkBox
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChattingPage()));
            },
          ),
        );
      },
      itemCount: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
//      body: bodies[tabIndex],
      body: buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      floatingActionButton: buildFloatingActionButton(context),
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
                            "images/LOGO/1.5x/logo_hdpi.png",
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "我的交易",
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
                        ),
                        RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ]),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onPressed: () {
                      remindLogin(context);
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "我发布的",
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
                        ),
                        RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ]),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onPressed: () {
                      remindLogin(context);
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "我卖出的",
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
                        ),
                        RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ]),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onPressed: () {
                      remindLogin(context);
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "我买到的",
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
                        ),
                        RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ]),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onPressed: () {
                      remindLogin(context);
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "我收藏的",
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
                        ),
                        RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ]),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onPressed: () {
                      remindLogin(context);
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "我的消息",
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
                        ),
                        RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ]),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        tabIndex = 1;
                      });
                    },
                  ),
                ),
                Divider()
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "设置",
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "",
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                            ),
                          ]),
                    ),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
                onPressed: () {},
              ),
            ),
          ),
          _isLogin
              ? Container(
                  constraints: BoxConstraints.expand(
                    height:
                        Theme.of(context).textTheme.display1.fontSize * 1.1 +
                            10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RaisedButton(
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
                    ),
                  ),
                )
              : Container(
                  width: 0.0,
                  height: 0.0,
                )
        ],
      ),
    );
  }
}

//内部空间中行设定
class InnerRow extends StatefulWidget {
  const InnerRow({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _InnerRowState createState() => _InnerRowState();
}

class _InnerRowState extends State<InnerRow> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 0.0,
              height: 0.0,
            ),
            flex: 1,
          ),
          Expanded(
            child: widget.child,
            flex: 30,
          ),
          Expanded(
            child: Container(
              width: 0.0,
              height: 0.0,
            ),
            flex: 1,
          ),
        ],
      ),
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
                color: Colors.black12,
                child: Image.asset(
                  'images/LOGO/4x/logo_xxxhdpi.jpg',
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

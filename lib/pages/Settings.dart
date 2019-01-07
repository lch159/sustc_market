import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustc_market/main.dart';
import 'package:sustc_market/pages/SettingsChangePassword.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  var _isLogin = false;
  var _username = "";
  var _email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLoginInfo();
  }

  Future<String> readLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoginState = prefs.getString("isLogin");
    setState(() {
      if (isLoginState == "1") {
        _isLogin = true;
        _username = prefs.getString("username");
        _email = prefs.getString("email");
      } else {
        _isLogin = false;
      }
    });

    return isLoginState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                buildSingleRow(context, "个人资料", true, () {}),
                buildSingleRow(context, "我的二维码", true, () {}),
                buildSingleRow(
                  context,
                  "修改密码",
                  false,
                  () {
                    Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
                        (BuildContext context, Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                      return new SettingsChangePasswordPage(
                        name: _username,
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
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                buildSingleRow(context, "登录设置", true, () {}),
                buildSingleRow(context, "权限设置", false, () {}),
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                buildSingleRow(context, "关于", false, () {}),
              ],
            ),
          ),
          _isLogin
              ? buildLogoutRow(context)
              : Container(
                  width: 0.0,
                  height: 0.0,
                )
        ],
      )),
    );
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
        '设置',
      ),
    );
  }

  Widget buildLogoutRow(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FlatButton(
          onPressed: () {
            Future<bool> logout() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
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
                            style:
                                TextStyle(fontSize: 17.0, color: Colors.black),
                          ),
                        ]),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
            onPressed: callback),
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
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Expanded(
            child: widget.child,
            flex: 8,
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

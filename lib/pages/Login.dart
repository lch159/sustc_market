import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sustc_market/main.dart';
import 'package:sustc_market/pages/Register.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var textTips = TextStyle(fontSize: 15.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);
  static const logoPath = 'images/LOGO/1.5x/logo_hdpi.png';

  var _isRemember = false;
  var _isAuto = false;
  var _isObscure = true;
  var _isEmail = false;

  GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _loginViewKey = new GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLogInfo();
  }

  saveLogInfo(username, email, tempID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isLogin", "1");
    prefs.setString("username", username);
    prefs.setString("email", email);
    prefs.setString("temporaryid", tempID);
    if (_isRemember) {
      prefs.setString("isRemember", "1");
      prefs.setString("name", nameController.text);
      prefs.setString("password", passwordController.text);
    }
//    if (_isAuto) {
//      prefs.setString("isAuto", "1");
//      prefs.setString("name", nameController.text);
//
//    }
//    prefs.setString("username", )
  }

  readLogInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isRemember = prefs.getString("isRemember");

    if (isRemember == "1") {
      setState(() {
        nameController.text = prefs.getString("name");
        passwordController.text = prefs.getString("password");
        _isRemember = true;
      });
    }
  }

  Future<String> get() async {
    var userName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("temporaryid");
    return userName;
  }

  void _formSubmitted() async {
    var _form = _loginFormKey.currentState;

    if (_form.validate()) {
      FormData loginFormData = new FormData.from({
        "username": _isEmail ? "-1" : nameController.text,
        "email": _isEmail ? nameController.text : "-1",
        "password": passwordController.text,
      });

      _form.save();
      Dio dio = new Dio();
      Response response = await dio.get(
          "http://120.79.232.137:8080/helloSSM/user/login",
          data: loginFormData);

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
          print(data["userinfo"]["email"] );
          saveLogInfo(data["userinfo"]["username"], data["userinfo"]["email"],
              data["userinfo"]["temporaryid"]);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                //指定跳转的页面
                return MainPage();
              },
            ),
          );
        } else {
          passwordController.clear();
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('账号或密码错误'),
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
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Navigation menu',
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('登录'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.error_outline),
            color: Colors.white,
            tooltip: 'Anno',
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
          key: _loginViewKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InnerRow(child: buildLogoImage(context)),
              InnerRow(
                child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: <Widget>[
                        buildNameTextField(context),
                        buildPasswordTextField(context)
                      ],
                    )),
              ),
              InnerRow(child: buildLoginStateRow(context)),
              InnerRow(child: buildLoginButton(context)),
              InnerRow(child: buildRegisterButton(context))
            ],
          )),
    );
  }

  Container buildLogoImage(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 72.0,
      height: 72.0,
      margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
      child: Image.asset(
        logoPath,
        fit: BoxFit.cover,
      ),
    );
  }

  TextFormField buildNameTextField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      validator: (val) {
        return nameValidator(val);
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: '请输入你的用户名或邮箱',
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      validator: (val) {
        return passwordValidator(val);
      },
//      initialValue: _isRemember ? iniPassword : '',
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: '请输入你的密码',
        suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _isObscure ? Colors.black45 : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
      ),
      obscureText: _isObscure,
    );
  }

  String nameValidator(String val) {
    val = val.trim();
    RegExp regExpEmail = new RegExp(r'@mail.sustc.edu.cn$');
    RegExp regExpUsername = new RegExp(r'[^a-zA-Z0-9_]');
    if (val.length == 0)
      return "用户名不能为空";
    else if (val.contains("@")) {
      if (!regExpEmail.hasMatch(val)) {
        _isEmail = false;
        return "请输入学校提供的邮箱";
      } else
        _isEmail = true;
    } else if (val.length < 6)
      return "用户名不能小于3个汉字或6位字符";
    else if (val.length > 18)
      return "用户名不能大与9个汉字或18位字符";
    else if (regExpUsername.hasMatch(val))
      return "用户名仅支持字母数字和下划线";
    else
      return null;
  }

  String passwordValidator(String val) {
    val = val.trim();

    if (val.length == 0)
      return "密码不能为空";
    else if (val.length < 6)
      return "密码长度不能小于6位";
    else
      return null;
  }

  Row buildLoginStateRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: _isRemember,
              onChanged: (bool) {
                setState(() {
                  _isRemember = bool;
                });
              },
            ),
            Text('记住密码'),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
                value: _isAuto,
                onChanged: (bool) {
                  setState(() {
                    _isAuto = bool;
                  });
                }),
            Text('自动登录'),
          ],
        ),
      ],
    );
  }

  Container buildLoginButton(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 10,
      ),
      child: RaisedButton(
        color: Colors.green,
        onPressed: _formSubmitted,
        child: Text(
          '登录',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
    );
  }

  Container buildRegisterButton(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 10,
      ),
      child: OutlineButton(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              //指定跳转的页面
              return RegisterPage();
            },
          ));
        },
        child: Text(
          '注册',
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0),
        ),
      ),
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
  double _leftMargin = 0.0;
  double _topMargin = 10.0;
  double _rightMargin = 0.0;
  double _bottomMargin = 10.0;

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

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustc_market/main.dart';

class SettingsChangePasswordPage extends StatelessWidget {
  SettingsChangePasswordPage({
    this.name,
  });

  final String name;

  TextEditingController passwordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  void _submit() async {
    Dio dio = new Dio();
    FormData form = FormData.from({
      "username": name,
      "passwrod": passwordController.text,
      "newpassword": newPasswordController.text,
    });
    String url = "http://120.79.232.137:8080/helloSSM/user/changePassword";
    dio.interceptor.response.onSuccess = (Response response) {
      Map<String, dynamic> data = response.data;
      String text = "";
      if (data["returncode"] == "200") {
        text = "修改成功";
      } else if (data["returncode"] == "201") {
        text = "请输入正确的原始密码";
      }
      showDialog<Null>(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        context: null,
      );
    };
    await dio.post(url, data: form);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: InnerRow(
        child: Column(
          children: <Widget>[
            buildName(context),
            buildPassword(context),
            buildNewPassword(context),
            buildConfirm(context),
          ],
        ),
      ),
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
        '修改密码',
      ),
    );
  }

  TextFormField buildName(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: name,
      ),
      enabled: false,
    );
  }

  TextFormField buildPassword(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: '请输入原始密码',
      ),
      obscureText: true,
    );
  }

  TextFormField buildNewPassword(BuildContext context) {
    return TextFormField(
      controller: newPasswordController,
      validator: (val) {
        return passwordValidator(val);
      },
      decoration: InputDecoration(
        labelText: '请输入你的新密码',
      ),
      obscureText: true,
    );
  }

  String passwordValidator(String val) {
    val = val.trim();
    if (val.length == 0)
      return '密码不能为空';
    else if (val.length < 6)
      return '密码长度不能小于6位';
    else if (val.length > 18)
      return '密码长度不能大于18位';
    else if (val.length > 18)
      return '密码不能是纯数字';
    else
      return null;
  }

  Widget buildConfirm(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FlatButton(
          onPressed: _submit,
          color: Colors.green,
          child: Text(
            "确定",
            style: TextStyle(color: Colors.white),
          ),
        ),
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

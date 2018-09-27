import 'package:flutter/material.dart';
import 'package:sustc_market/pages/Register.dart';



class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  static const logoPath = "images/LOGO/1.5x/logo_hdpi.png";

  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            tooltip: 'Navigation menu',
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: new Text('登录'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.error_outline),
              color: Colors.white,
              tooltip: 'Anno',
              onPressed: null,
            ),
          ],
        ),
        body: new SingleChildScrollView(
            child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Center(child:new Container(
              alignment: Alignment.center,
              width: 72.0,
              height: 72.0,
              margin: new EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
              child: new Image.asset(
                logoPath,
                fit: BoxFit.cover,
              ),
            )),
            new Container(
              margin: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new TextField(
                style: hintTips,
                controller: _userNameController,
                decoration: InputDecoration(
//                    border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  labelText: '请输入你的用户名或邮箱',
                ),
                obscureText: true,
              ),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new TextField(
                style: hintTips,
                controller: _userPassController,
                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  labelText: '请输入你的密码',
                ),
                obscureText: true,
              ),
            ),
            new Container(
              constraints: new BoxConstraints.expand(
                height:
                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
              ),
              margin: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new RaisedButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) {
                      //指定跳转的页面
                      return new RegisterPage();
                    },
                  ));
                },
                child: new Text(
                  '登录',
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            new Container(
              constraints: new BoxConstraints.expand(
                height:
                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
              ),
              margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new OutlineButton(
                borderSide:
                    new BorderSide(color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) {
                      //指定跳转的页面
                      return new RegisterPage();
                    },
                  ));
                },
                child: new Text(
                  '注册',
                  style: new TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20.0),
                ),
              ),
            )
          ],
        ))
        ,resizeToAvoidBottomPadding:true,
    );
  }
}

import 'package:flutter/material.dart';



class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);

  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            tooltip: 'Navigation menu',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: new Text('注册'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.error_outline),
                tooltip: 'Anno',
                onPressed: null),
          ],
        ),
        body: new SingleChildScrollView(
            child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new TextField(
                style: hintTips,
                controller: _userNameController,
                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  labelText: '请输入你的用户名',
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
                controller: _userNameController,
                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  labelText: '请输入你的密码',
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
                  labelText: '重复输入密码',
                ),
                obscureText: true,
              ),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      style: hintTips,
                      controller: _userNameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail), labelText: '请输入你的邮箱'),
                    ),
                    flex: 2,
                  ),
                  new Expanded(
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
                        '点击发送验证码',
                        style: new TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.0),
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      style: hintTips,
                      controller: _userNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: '输入验证码'),
                    ),
                    flex: 4,
                  ),
                  new Expanded(
                    child: new Icon(Icons.refresh),
                    flex: 1,
                  )
                ],
              ),
            ),
            new Container(
              constraints: new BoxConstraints.expand(
                height:
                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
              ),
              margin: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) {
                      //指定跳转的页面
                      return new RegisterPage();
                    },
                  ));
                },
                color: Colors.blue,
                child: new Text(
                  '注册',
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            )
          ],
        )));
  }
}

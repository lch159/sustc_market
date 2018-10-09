import 'package:flutter/material.dart';
import 'package:sustc_market/pages/Register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var textTips = new TextStyle(fontSize: 15.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  static const logoPath = "images/LOGO/1.5x/logo_hdpi.png";

  var isRemember = false;
  var isAuto = false;

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new InnerRow(
            child: new Container(
              alignment: Alignment.center,
              width: 72.0,
              height: 72.0,
              margin: new EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
              child: new Image.asset(
                logoPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          new InnerRow(
            child: new TextField(
              style: hintTips,
              controller:  new TextEditingController(),
              decoration: InputDecoration(
//                    border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                labelText: '请输入你的用户名或邮箱',
              ),
              obscureText: true,
            ),
          ),
          new InnerRow(
            child: new TextField(
              style: hintTips,
              controller:  new TextEditingController(),
              decoration: InputDecoration(
//                    border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                labelText: '请输入你的密码',
              ),
              obscureText: true,
            ),
          ),
          new InnerRow(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Checkbox(
                        value: isRemember,
                        onChanged: (bool) {
                          setState(() {
                            isRemember = bool;
                          });
                        }),
                    new Text('记住密码'),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Checkbox(
                        value: isAuto,
                        onChanged: (bool) {
                          setState(() {
                            isAuto = bool;
                          });
                        }),
                    new Text('自动登录'),
                  ],
                ),
              ],
            ),
          ),
          new InnerRow(
              child: new Container(
            constraints: new BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 10,
            ),
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
          )),
          new InnerRow(
              child: new Container(
            constraints: new BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 10,
            ),
            child: new OutlineButton(
              borderSide: new BorderSide(color: Theme.of(context).primaryColor),
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
          ))
        ],
      )),
//      resizeToAvoidBottomPadding: true,
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
            flex: 8,
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

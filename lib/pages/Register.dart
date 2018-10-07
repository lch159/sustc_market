import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  var textTips = new TextStyle(fontSize: 15.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);

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
          children: <Widget>[
            new InnerRow(
              child: new Container(),
            ),
            new InnerRow(
              child: new TextField(
                style: hintTips,
                controller:  new TextEditingController(),
                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  labelText: '请输入你的用户名',
                ),
                obscureText: true,
              ),
            ),
            new InnerRow(
              child: new TextField(
                style: hintTips,
                controller:  new TextEditingController(),
                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  labelText: '请输入你的密码',
                ),
                obscureText: true,
              ),
            ),
            new InnerRow(
              child: new TextField(
                style: hintTips,
                controller:  new TextEditingController(),
                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  labelText: '重复输入密码',
                ),
                obscureText: true,
              ),
            ),
            new InnerRow(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      style: hintTips,
                      controller:  new TextEditingController(),
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
                        '发送验证码',
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
            new InnerRow(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      style: hintTips,
                      controller:  new TextEditingController(),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: '输入验证码'),
                    ),
                  ),
                ],
              ),
            ),
            new InnerRow(
              child: new Container(
                constraints: new BoxConstraints.expand(
                  height:
                      Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
                ),
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
              ),
            )
          ],
        )));
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

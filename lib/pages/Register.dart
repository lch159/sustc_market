import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return   _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  var textTips =   TextStyle(fontSize: 15.0, color: Colors.black);
  var hintTips =   TextStyle(fontSize: 15.0, color: Colors.black26);

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:   AppBar(
        leading:   IconButton(
          icon:   Icon(Icons.arrow_back),
          tooltip: 'Navigation menu',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:   Text('注册'),
        actions: <Widget>[
            IconButton(
              icon:   Icon(Icons.error_outline),
              tooltip: 'Anno',
              onPressed: null),
        ],
      ),
      body:   SingleChildScrollView(
          child:   Column(
        children: <Widget>[
            InnerRow(
            child:   Container(),
          ),
            InnerRow(
            child:   TextField(
              style: textTips,
              controller:   TextEditingController(),
              decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                labelText: '请输入你的用户名',
              ),

            ),
          ),
            InnerRow(
            child:   TextField(
              style: textTips,
              controller:   TextEditingController(),
              decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                labelText: '请输入你的密码',
              ),
              obscureText: true,
            ),
          ),
            InnerRow(
            child:   TextField(
              style: textTips,
              controller:   TextEditingController(),
              decoration: InputDecoration(
//                  border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                labelText: '重复输入密码',
              ),
              obscureText: true,
            ),
          ),
            InnerRow(
            child:   Row(
              children: <Widget>[
                  Expanded(
                  child:   TextField(
                    style: textTips,
                    controller:   TextEditingController(),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail), labelText: '请输入你的邮箱'),
                  ),
                  flex: 2,
                ),
                  Expanded(
                  child:   OutlineButton(
                    borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.of(context).push(  MaterialPageRoute(
                        builder: (context) {
                          //指定跳转的页面
                          return   RegisterPage();
                        },
                      ));
                    },
                    child:   Text(
                      '发送验证码',
                      style:   TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 13.0),
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
            InnerRow(
            child:   Row(
              children: <Widget>[
                  Expanded(
                  child:   TextField(
                    style: hintTips,
                    controller:   TextEditingController(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '输入验证码'),
                  ),
                ),
              ],
            ),
          ),
            InnerRow(
            child:   Container(
              constraints:   BoxConstraints.expand(
                height:
                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
              ),
              child:   RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(  MaterialPageRoute(
                    builder: (context) {
                      //指定跳转的页面
                      return   RegisterPage();
                    },
                  ));
                },
                color: Colors.blue,
                child:   Text(
                  '注册',
                  style:   TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          )
        ],
      )),
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
  _InnerRowState createState() =>   _InnerRowState();
}

class _InnerRowState extends State<InnerRow> {
  double _leftMargin = 0.0;
  double _topMargin = 10.0;
  double _rightMargin = 0.0;
  double _bottomMargin = 10.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Container(
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child:   Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Expanded(
            child:   Container(),
            flex: 1,
          ),
            Expanded(
            child: widget.child,
            flex: 8,
          ),
            Expanded(
            child:   Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sustc_market/pages/Register.dart';

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

  var isRemember = false;
  var isAuto = false;
  bool _isObscure = true;
  Color _eyeColor;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _loginViewKey = new GlobalKey<FormState>();

  String _name;
  String _password;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _forSubmitted() {
    var _form = _formKey.currentState;

    if (_form.validate()) {
      _form.save();
      print(_name);
      print(_password);
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
                    key: _formKey,
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
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: '请输入你的用户名或邮箱',
      ),
      onSaved: (val) {
        _name = val;
      },
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      validator: (val) {
        return val.length < 4 ? "密码长度错误" : null;
      },
      onSaved: (val) {
        _password = val;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: '请输入你的密码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {})),
      obscureText: true,
    );
  }

  Row buildLoginStateRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: isRemember,
              onChanged: (bool) {
                setState(() {
                  isRemember = bool;
                });
              },
            ),
            Text('记住密码'),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
                value: isAuto,
                onChanged: (bool) {
                  setState(() {
                    isAuto = bool;
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
        onPressed: _forSubmitted,
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

class Post {
  final String username;
  final String password;
  final String body;

  Post({this.username, this.password, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      username: json['username'],
      password: json['password'],
      body: json['body'],
    );
  }
}
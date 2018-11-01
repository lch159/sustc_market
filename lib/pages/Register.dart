import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  var textTips = TextStyle(fontSize: 15.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController authController = TextEditingController();

  var _name;
  var _password;
  var _repassword;
  var _email;
  var _auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          InnerRow(
            child: Form(
                child: Column(
              children: <Widget>[
                buildNameTextField(context),
                buildPasswordTextField(context),
                buildRepasswordTextField(context),
                buildEmailTextField(context),
                buildAuthTextField(context)
              ],
            )
            ),
          ),
          InnerRow(
            child: buildRegisterButton(context)
          )
        ],
      )),
    );
  }

  AppBar buildAppbar(BuildContext context){
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        tooltip: 'Navigation menu',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('注册'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.error_outline),
            tooltip: 'Anno',
            onPressed: null),
      ],
    );
  }

  TextFormField buildNameTextField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: '请输入你的用户名',
      ),
      onSaved: (val) {
        _name = val;
      },
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: '请输入你的密码',
      ),
      obscureText: true,
      onSaved: (val) {
        _password = val;
      },
    );
  }

  TextFormField buildRepasswordTextField(BuildContext context) {
    return TextFormField(
      controller: repasswordController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: '重复输入密码',
      ),
      obscureText: true,
      onSaved: (val) {
        _repassword = val;
      },
    );
  }

  Row buildEmailTextField(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail), labelText: '请输入你的邮箱'),
            onSaved: (val) {
              _email = val;
            },
          ),
          flex: 2,
        ),
        Expanded(
          child: OutlineButton(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            onPressed: () {},
            child: Text(
              '发送验证码',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 13.0),
            ),
          ),
          flex: 1,
        )
      ],
    );
  }

  Row buildAuthTextField(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: '输入验证码'),
            onSaved: (val) {
              _auth = val;
            },
          ),
        )),
      ],
    );
  }

  Container buildRegisterButton (BuildContext context){
    return Container(
      constraints: BoxConstraints.expand(
        height:
        Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
      ),
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              //指定跳转的页面
              return RegisterPage();
            },
          ));
        },
        color: Colors.blue,
        child: Text(
          '注册',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
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

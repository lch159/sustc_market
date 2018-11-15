import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sustc_market/main.dart';

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
  GlobalKey<FormState> _registerFormKey = new GlobalKey<FormState>();

  var _name;
  var _password;
  var _repassword;
  var _email;
  var _auth;

  bool _nameCorrect = false;
  bool _passwordCorrect = false;
  bool _repasswordCorrect = false;
  bool _emailCorrect = false;

  void _registerFormSubmitted() async {
    var _form = _registerFormKey.currentState;

    FormData registerFormData = new FormData.from({
      "username": _name,
      "password": _password,
      "email": _email,
    });

    if (_form.validate()) {
      _form.save();
      Dio dio = new Dio();
      Response response = await dio.get(
          "http://120.79.232.137:8080/SUSTechFM/register.jsp",
          data: registerFormData);
      if (response.statusCode != 200) {
        return showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('发送验证码失败'),
              actions: <Widget>[
                FlatButton(
                  child: Text('重新发送'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('取消'),
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

  void _authSubmitted() async {
    var _form = _registerFormKey.currentState;

    FormData registerFormData = new FormData.from({
      "username": _name,
      "password": _password,
      "email": _email,
      "auth": _auth,
    });

    if (_form.validate()) {
      _form.save();
      Dio dio = new Dio();
      Response response = await dio.get(
          "http://120.79.232.137:8080/SUSTechFM/register.jsp",
          data: registerFormData);
      if (response.statusCode != 200) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            //指定跳转的页面
            return MainPage();
          },
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          InnerRow(
            child: Form(
                key: _registerFormKey,
                child: Column(
                  children: <Widget>[
                    buildNameTextField(context),
                    buildPasswordTextField(context),
                    buildRepasswordTextField(context),
                    buildEmailTextField(context),
                    buildAuthTextField(context)
                  ],
                )),
          ),
          InnerRow(child: buildRegisterButton(context))
        ],
      )),
    );
  }

  AppBar buildAppbar(BuildContext context) {
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
            icon: Icon(Icons.error_outline), tooltip: 'Anno', onPressed: null),
      ],
    );
  }

  TextFormField buildNameTextField(BuildContext context) {
    return TextFormField(
      controller: nameController,

      validator: (val) {
        return nameValidator(val);
      },
      decoration: InputDecoration(
        prefixIcon: _nameCorrect
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : Icon(Icons.person),
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
      validator: (val) {
        return passwordValidator(val);
      },
      decoration: InputDecoration(
        prefixIcon: _passwordCorrect
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : Icon(Icons.lock),
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
      validator: (val) {
        return repasswordValidator(val);
      },
      decoration: InputDecoration(
        prefixIcon: _repasswordCorrect
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : Icon(Icons.lock),
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
            validator: (val) {
              return emailValidator(val);
            },
            decoration: InputDecoration(
                prefixIcon: _emailCorrect
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : Icon(Icons.mail),
                labelText: '请输入你的邮箱'),
            onSaved: (val) {
              _email = val;
            },
          ),
          flex: 2,
        ),
        Expanded(
          child: OutlineButton(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            onPressed: () {
              _registerFormSubmitted();
            },
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
            controller: authController,
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

  String nameValidator(String val) {
    val = val.trim();
    RegExp regExpUsername = new RegExp(r'[^a-zA-Z0-9_]');
    _nameCorrect = false;
    if (val.length == 0)
      return "用户名不能为空";
    else if (val.length < 6)
      return "用户名不能小于3个汉字或6位字符";
    else if (val.length > 18)
      return "用户名不能大与9个汉字或18位字符";
    else if (regExpUsername.hasMatch(val))
      return "用户名仅支持字母数字和下划线";
    else
      _nameCorrect = true;
    return null;
  }

  String passwordValidator(String val) {
    val = val.trim();
    _passwordCorrect = false;
    if (val.length == 0)
      return "密码不能为空";
    else if (val.length < 6)
      return "密码长度不能小于6位";
    else
      _passwordCorrect = true;
    return null;
  }

  String repasswordValidator(String val) {
    val = val.trim();
    _repasswordCorrect = false;
    if (val.length == 0)
      return "重复密码不能为空";
    else if (val.length < 6)
      return "密码长度不能小于6位";
    else if (passwordController.text != repasswordController.text)
      return "两次密码不相同";
    else
      _repasswordCorrect = true;
    return null;
  }

  String emailValidator(String val) {
    val = val.trim();
    RegExp regExpEmail = new RegExp(r'@mail.sustc.edu.cn$');
    _emailCorrect = false;
    if (val.length == 0)
      return "邮箱不能为空";
    else if (!regExpEmail.hasMatch(val))
      return "请输入学校提供的邮箱";
    else
      _emailCorrect = true;
    return null;
  }

  Container buildRegisterButton(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
      ),
      child: RaisedButton(
        onPressed: () {
          _authSubmitted();
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

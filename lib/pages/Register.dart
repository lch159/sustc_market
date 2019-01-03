import 'dart:convert';

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

  var _nameCorrect = false;
  var _passwordCorrect = false;
  var _rePasswordCorrect = false;
  var _emailCorrect = false;

  var _isPasswordObscure = true;
  var _isRePasswordObscure = true;

  var verifyText = '发送验证码';
  var waitTime = 30;

  var _isEdited = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    repasswordController.dispose();
    emailController.dispose();
    authController.dispose();
  }

  void _registerFormSubmitted() async {
    var _form = _registerFormKey.currentState;

    FormData registerFormData = new FormData.from({
      'username': nameController.text,
      'password': passwordController.text,
      'email': emailController.text,
    });

    if (_form.validate()) {
      _form.save();
      Dio dio = new Dio();
      String url = 'http://120.79.232.137:8080/helloSSM/user/register';
      dio.interceptor.response.onSuccess = (Response response) {
        Map<String, dynamic> data = response.data;
        if (data['returncode'] == '200') {
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('邮件发送成功，请前往学校邮箱查看,30s后可重新发送'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      setState(() {
                        _isEdited = false;
                        verifyText = "30s后可以重新发送";
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

          new Future.delayed(const Duration(seconds: 30), () {
            setState(() {
              verifyText = "点击发送验证码";
              _isEdited = true;
            });
          });

//          setState(() {
//            _isEdited = false;
//            for (int i = 30; i > -1; i--) {
//              new Future.delayed(const Duration(seconds: 1), () {
//                verifyText = i.toString() + "s后重新发送";
//              });
//            }
//            _isEdited = true;
//          });

        } else if (data['returncode'] == '201') {
          var textTitle = '';
          var textMessage = '';
          switch (data['report']) {
            case 'username duplicate':
              textTitle = '重填用户名';
              textMessage = '用户名已被使用,点击确定重新填写';
              break;
          }
          return showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(textMessage),
                actions: <Widget>[
                  FlatButton(
                    child: Text(textTitle),
                    onPressed: () {
                      nameController.clear();
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
      };
      dio.interceptor.response.onError = (Error e) {
        showDialog<Null>(
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
      };
      await dio.post(url, data: registerFormData);
    }
  }

  void _authSubmitted() async {
    var _form = _registerFormKey.currentState;

    FormData authFormData = new FormData.from({
      'username': nameController.text,
      'code': authController.text,
    });

    if (_form.validate()) {
      _form.save();
      Dio dio = new Dio();
      String url = 'http://120.79.232.137:8080/helloSSM/user/emailLink';
      dio.interceptor.response.onSuccess = (Response response) {
        Map<String, dynamic> data = response.data;
        if (data['returncode'] == '200') {
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              AlertDialog(
                title: Text('注册成功!'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (data['returncode'] == '201') {
          return showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('验证码错误'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('重新输入'),
                    onPressed: () {
                      authController.clear();
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
      };
      dio.interceptor.response.onError = (Error e) {
        showDialog<Null>(
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
      };
      await dio.post(url, data: authFormData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          InnerRow(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
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
          ),
          InnerRow(child: buildRegisterButton(context))
        ],
      )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black45,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        '注册',
        style: TextStyle(color: Colors.black45),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.error_outline),
            onPressed: () {},
            color: Colors.black45),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
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
//        _username = nameController.text;
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
        suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _isPasswordObscure ? Colors.black45 : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _isPasswordObscure = !_isPasswordObscure;
              });
            }),
      ),
      obscureText: _isPasswordObscure,
      onSaved: (val) {
//        _password = val;
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
        prefixIcon: _rePasswordCorrect
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : Icon(Icons.lock),
        labelText: '重复输入密码',
        suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _isRePasswordObscure ? Colors.black45 : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _isRePasswordObscure = !_isRePasswordObscure;
              });
            }),
      ),
      obscureText: _isRePasswordObscure,
      onSaved: (val) {
//        _repassword = val;
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
//              _email = val;
            },
          ),
          flex: 2,
        ),
        Expanded(
          child: Padding(
            child: OutlineButton(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              onPressed: _isEdited ? _registerFormSubmitted : null,
              child: Text(
                verifyText,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 13.0),
              ),
            ),
            padding: EdgeInsets.only(left: 5.0),
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
//              _auth = val;
            },
          ),
        )),
      ],
    );
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

  String nameValidator(String val) {
    val = val.trim();
    RegExp regExpUsername = new RegExp(r'[^a-zA-Z0-9_]');
    _nameCorrect = false;
    if (val.length == 0)
      return '用户名不能为空';
    else if (val.length < 6)
      return '用户名不能小于3个汉字或6位字符';
    else if (val.length > 18)
      return '用户名不能大与9个汉字或18位字符';
    else if (regExpUsername.hasMatch(val))
      return '用户名仅支持字母数字和下划线';
    else
      _nameCorrect = true;
    return null;
  }

  String passwordValidator(String val) {
    val = val.trim();
    _passwordCorrect = false;
    if (val.length == 0)
      return '密码不能为空';
    else if (val.length < 6)
      return '密码长度不能小于6位';
    else if (val.length > 18)
      return '密码长度不能大于18位';
    else if (val.length > 18)
      return '密码不能是纯数字';
    else
      _passwordCorrect = true;
    return null;
  }

  String repasswordValidator(String val) {
    val = val.trim();
    _rePasswordCorrect = false;
    if (val.length == 0)
      return '重复密码不能为空';
    else if (val.length < 6)
      return '密码长度不能小于6位';
    else if (passwordController.text != repasswordController.text)
      return '两次密码不相同';
    else
      _rePasswordCorrect = true;
    return null;
  }

  String emailValidator(String val) {
    val = val.trim();
    RegExp regExpEmail =
        new RegExp(r'@mail.sustc.edu.cn$|@sustc.edu.cn$|@pub.sustc.edu.cn$');
    _emailCorrect = false;
    if (val.length == 0)
      return '邮箱不能为空';
    else if (!regExpEmail.hasMatch(val))
      return '请输入学校提供的邮箱';
    else
      _emailCorrect = true;
    return null;
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

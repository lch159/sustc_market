import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sustc_market/main.dart';

class UploadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UploadPageState();
  }
}

class _UploadPageState extends State<UploadPage> {
  GlobalKey<FormState> _uploadFormKey = new GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  GlobalKey<FormState> _priceKey = new GlobalKey<FormState>();

  var _title = "";
  var _description = "";
  var _price = "";
  var _type = "";
  var _area = "";
  var _payment = "";
  var _putAwayTime = "";
  var _availableTime = "";

  File _image1;
  File _image2;
  File _image3;

  void _formSubmitted() async {
    var _form = _uploadFormKey.currentState;

    if (_form.validate()) {
      FormData uploadFormData = new FormData.from({
        "temporaryid": "1",
        "name": titleController.text,
        "description": descriptionController.text,
        "status": "SELLING",
        "putawaytime": DateTime.now().year.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().day.toString() +
            "-" +
            DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        "availabletime": _availableTime,
        "price": _price,
        "address": _area,
        "type": _type,
      });

      _form.save();
      Dio dio = new Dio();
      print(uploadFormData);
      Response response = await dio.get(
          "http://120.79.232.137:8080/helloSSM/dommodity/createDommodity",
          data: uploadFormData);
      Map data = json.decode(response.data);
      if (response.statusCode != 200) {
        return showDialog<Null>(
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
      } else {
        if (data["returncode"] == "200") {
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('商品上传成功'),
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
        } else {
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('账号或密码错误'),
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
        }
      }
    }
  }

  Future getImage1() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image1 = image;
    });
  }

  Future getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image2 = image;
    });
  }

  Future getImage3() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image3 = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _uploadFormKey,
              child: InnerRow(
                child: Column(
                  children: <Widget>[
                    buildTitleTextField(context),
                    buildDescriptionTextField(context),
                    buildImagesRow(context),
                    Container(
                      height: 10.0,
                      color: Colors.black12,
                    ),
                    buildPriceRow(context),
                    buildTypeRow(context),
                    buildAreaRow(context),
                    buildPaymentRow(context),
                    buildPutAwayRow(context),
                    buildUploadButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text("发布"),
    );
  }

  TextFormField buildTitleTextField(BuildContext context) {
    return TextFormField(
      controller: titleController,
      validator: (val) {
        val = val.trim();
        if (val.length > 30) return "标题最大长度为30";
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: '标题 请在此输入发布的标题',
      ),
      onSaved: (val) {
        _title = val;
      },
      maxLength: 30,
    );
  }

  TextFormField buildDescriptionTextField(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      validator: (val) {
        val = val.trim();
        if (val.length > 1000) return "描述长度最大为1000个字符";
      },
      decoration: InputDecoration(
        hintText: '描述 请在此描述一下所发布的物品',
      ),
      onSaved: (val) {
        _description = val;
      },
      maxLength: 1000,
      maxLines: 15,
    );
  }

  Padding buildImagesRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 96.0,
            height: 96.0,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: FlatButton(
              onPressed: getImage1,
              child: _image1 == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.add), Text("点击添加")],
                    )
                  : Image.file(
                      _image1,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Container(
            width: 96.0,
            height: 96.0,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: FlatButton(
              onPressed: getImage1,
              child: _image2 == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.add), Text("点击添加")],
                    )
                  : Image.file(
                      _image2,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Container(
            width: 96.0,
            height: 96.0,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: FlatButton(
              onPressed: getImage1,
              child: _image3 == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.add), Text("点击添加")],
                    )
                  : Image.file(
                      _image3,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildPriceRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "价格",
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                RichText(
                  text: TextSpan(
                      text: '￥',
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: _price,
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                        ),
                      ]),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
            onPressed: () {
              priceController.clear();
              return showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('请输入价格'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    children: <Widget>[
                      TextFormField(
                        key: _priceKey,
                        controller: priceController,
                        decoration:
                            InputDecoration(hintText: "仅支持0~99999999数字"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          child: Text('确定'),
                          onPressed: () {
                            if (RegExp(r'[0-9]')
                                .hasMatch(priceController.text)) {
                              _price = priceController.text;
                              Navigator.of(context).pop();
                            } else {
                              priceController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }

  Column buildTypeRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "分类",
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                Text(
                  _type,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onPressed: () {
              return showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('请选择种类'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    children: <Widget>[
                      FlatButton(
                        child: Text("书本"),
                        onPressed: () {
                          setState(() {
                            _type = "书本";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("服饰"),
                        onPressed: () {
                          setState(() {
                            _type = "服饰";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("食品"),
                        onPressed: () {
                          setState(() {
                            _type = "食品";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("书本"),
                        onPressed: () {
                          setState(() {
                            _type = "书本";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("电子产品"),
                        onPressed: () {
                          setState(() {
                            _type = "电子产品";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }

  Column buildAreaRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "位置",
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                Text(
                  _area,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onPressed: () {
              return showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('请选择所在位置'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    children: <Widget>[
                      PopupMenuButton<String>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "湖畔宿舍区",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ),
                          onSelected: (String value) {
                            setState(() {
                              _area = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                    value: '湖畔一栋', child: Text('湖畔一栋')),
                                PopupMenuItem<String>(
                                    value: '湖畔二栋', child: Text('湖畔二栋')),
                                PopupMenuItem<String>(
                                    value: '湖畔三栋', child: Text('湖畔三栋')),
                                PopupMenuItem<String>(
                                    value: '湖畔四栋', child: Text('湖畔四栋')),
                                PopupMenuItem<String>(
                                    value: '湖畔五栋', child: Text('湖畔五栋')),
                                PopupMenuItem<String>(
                                    value: '湖畔六栋', child: Text('湖畔六栋')),
                              ]),
                      PopupMenuButton<String>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "荔园宿舍区",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ),
                          onSelected: (String value) {
                            setState(() {
                              _area = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                    value: '荔园一栋', child: Text('荔园一栋')),
                                PopupMenuItem<String>(
                                    value: '荔园二栋', child: Text('荔园二栋')),
                                PopupMenuItem<String>(
                                    value: '荔园三栋', child: Text('荔园三栋')),
                                PopupMenuItem<String>(
                                    value: '荔园四栋', child: Text('荔园四栋')),
                                PopupMenuItem<String>(
                                    value: '荔园五栋', child: Text('荔园五栋')),
                                PopupMenuItem<String>(
                                    value: '荔园六栋', child: Text('荔园六栋')),
                                PopupMenuItem<String>(
                                    value: '荔园七栋', child: Text('荔园七栋')),
                                PopupMenuItem<String>(
                                    value: '荔园八栋', child: Text('荔园八栋')),
                              ]),
                      PopupMenuButton<String>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "欣园",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ),
                          onSelected: (String value) {
                            setState(() {
                              _area = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                    value: '欣园一栋', child: Text('欣园一栋')),
                                PopupMenuItem<String>(
                                    value: '欣园二栋', child: Text('欣园二栋')),
                                PopupMenuItem<String>(
                                    value: '欣园三栋', child: Text('欣园三栋')),
                                PopupMenuItem<String>(
                                    value: '欣园四栋', child: Text('欣园四栋')),
                                PopupMenuItem<String>(
                                    value: '欣园五栋', child: Text('欣园五栋')),
                                PopupMenuItem<String>(
                                    value: '欣园六栋', child: Text('欣园六栋')),
                                PopupMenuItem<String>(
                                    value: '欣园七栋', child: Text('欣园七栋')),
                                PopupMenuItem<String>(
                                    value: '欣园八栋', child: Text('欣园八栋')),
                              ]),
                      PopupMenuButton<String>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "慧园",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ),
                          onSelected: (String value) {
                            setState(() {
                              _area = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                    value: '慧园一栋', child: Text('慧园一栋')),
                                PopupMenuItem<String>(
                                    value: '慧园二栋', child: Text('慧园二栋')),
                                PopupMenuItem<String>(
                                    value: '慧园三栋', child: Text('慧园三栋')),
                                PopupMenuItem<String>(
                                    value: '慧园四栋', child: Text('慧园四栋')),
                                PopupMenuItem<String>(
                                    value: '慧园五栋', child: Text('慧园五栋')),
                                PopupMenuItem<String>(
                                    value: '慧园六栋', child: Text('慧园六栋')),
                                PopupMenuItem<String>(
                                    value: '慧园七栋', child: Text('慧园七栋')),
                                PopupMenuItem<String>(
                                    value: '慧园八栋', child: Text('慧园八栋')),
                              ]),
                      PopupMenuButton<String>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "创园",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ),
                          onSelected: (String value) {
                            setState(() {
                              _area = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                    value: '创园一栋', child: Text('创园一栋')),
                                PopupMenuItem<String>(
                                    value: '创园二栋', child: Text('创园二栋')),
                                PopupMenuItem<String>(
                                    value: '创园三栋', child: Text('创园三栋')),
                                PopupMenuItem<String>(
                                    value: '创园四栋', child: Text('创园四栋')),
                                PopupMenuItem<String>(
                                    value: '创园五栋', child: Text('创园五栋')),
                                PopupMenuItem<String>(
                                    value: '创园六栋', child: Text('创园六栋')),
                                PopupMenuItem<String>(
                                    value: '创园七栋', child: Text('创园七栋')),
                                PopupMenuItem<String>(
                                    value: '创园八栋', child: Text('创园八栋')),
                              ]),
                      PopupMenuButton<String>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "智园",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ),
                          onSelected: (String value) {
                            setState(() {
                              _area = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                    value: '智园一栋', child: Text('智园一栋')),
                                PopupMenuItem<String>(
                                    value: '智园二栋', child: Text('智园二栋')),
                                PopupMenuItem<String>(
                                    value: '智园三栋', child: Text('智园三栋')),
                                PopupMenuItem<String>(
                                    value: '智园四栋', child: Text('智园四栋')),
                                PopupMenuItem<String>(
                                    value: '智园五栋', child: Text('智园五栋')),
                                PopupMenuItem<String>(
                                    value: '智园六栋', child: Text('智园六栋')),
                                PopupMenuItem<String>(
                                    value: '智园七栋', child: Text('智园七栋')),
                                PopupMenuItem<String>(
                                    value: '智园八栋', child: Text('智园八栋')),
                              ]),
                      PopupMenuButton<String>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "教学区",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ),
                          onSelected: (String value) {
                            setState(() {
                              _area = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                PopupMenuItem<String>(
                                    value: '图书馆', child: Text('图书馆')),
                                PopupMenuItem<String>(
                                    value: '第一教学楼', child: Text('第一教学楼')),
                                PopupMenuItem<String>(
                                    value: '第二教学楼', child: Text('第二教学楼'))
                              ]),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }

  Column buildPaymentRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "交易方式",
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                Text(
                  _payment,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onPressed: () {
              return showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('请选择种类'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    children: <Widget>[
                      FlatButton(
                        child: Text("微信"),
                        onPressed: () {
                          setState(() {
                            _payment = "微信";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("支付宝"),
                        onPressed: () {
                          setState(() {
                            _payment = "支付宝";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("现金"),
                        onPressed: () {
                          setState(() {
                            _payment = "现金";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("面议"),
                        onPressed: () {
                          setState(() {
                            _payment = "面议";
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }

  Column buildPutAwayRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "上架到期时间",
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                Text(
                  _availableTime,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                locale: 'zh',
                minYear: DateTime.now().year,
                maxYear: 2020,
                initialYear: DateTime.now().year,
                initialMonth: DateTime.now().month,
                initialDate: DateTime.now().day,
                dateFormat: 'yyyy-mm-dd',
                onConfirm: (year, month, date) {
                  setState(() {
                    _availableTime = year.toString() +
                        "/" +
                        month.toString() +
                        "/" +
                        date.toString() +"-"+
                        DateTime.now().hour.toString() +
                        ":" +
                        DateTime.now().minute.toString() +
                        ":" +
                        DateTime.now().second.toString() +
                        ":";
                  });
                },
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }

  Container buildUploadButton(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
      ),
      child: RaisedButton(
        onPressed: () {
          _formSubmitted();
        },
        color: Colors.blue,
        child: Text(
          '发布',
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
  var _leftMargin = 0.0;
  var _topMargin = 10.0;
  var _rightMargin = 0.0;
  var _bottomMargin = 10.0;

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
            flex: 30,
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

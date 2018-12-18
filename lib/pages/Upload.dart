import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustc_market/main.dart';

var selectedTypeList = [];
var selectedPaymentList = [];

class UploadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UploadPageState();
  }
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  GlobalKey<FormState> _priceKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _uploadFormKey = new GlobalKey<FormState>();

  var temporaryid = "";
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

  @override
  void initState() {
    // TODO: implement initState
    selectedTypeList = [];
    selectedPaymentList = [];
    super.initState();
  }

  Future<String> getTempID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    temporaryid = prefs.getString("temporaryid");

    return temporaryid;
  }

  void _formSubmitted() async {
    var _form = _uploadFormKey.currentState;

    if (_form.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      temporaryid = prefs.getString("temporaryid");
      FormData uploadFormData = new FormData.from({
        "temporaryid": temporaryid,
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
        "type": "服饰",
        "paytype": _payment,
      });

      _form.save();
      Dio dio = new Dio();
      print(uploadFormData);
      Response response = await dio.get(
          "http://120.79.232.137:8080/helloSSM/dommodity/createDommodity",
          data: uploadFormData);
      Map data = response.data;
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
              child: Column(
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        buildTitleTextField(context),
                        buildDescriptionTextField(context),
                        buildImagesRow(context),
                      ],
                    ),
                  ),
                  Card(
                    child: buildIdentityRow(context),
                  ),
                  Card(
                    child: Column(
                      children: <Widget>[
                        buildPriceRow(context),
                        buildTypeRow(context),
                        buildPaymentRow(context),
                        buildAreaRow(context),
                        buildPutAwayRow(context),
                      ],
                    ),
                  ),
                  buildUploadButton(context),
                ],
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
                      text: _price == "" ? "" : "￥",
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
                            InputDecoration(hintText: "仅支持0~99999999数字和‘面议’"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          child: Text('确定'),
                          onPressed: () {
                            if (RegExp(r'[0-9]')
                                    .hasMatch(priceController.text) ||
                                priceController.text.trim() == "面议") {
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

  var _groupValue = 1;

  Widget buildIdentityRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "我要卖",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
              ),
              Radio(
                value: 1,
                groupValue: _groupValue,
                onChanged: (v) {
                  setState(() {
                    _groupValue = v;
                  });
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "我要买",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
              ),
              Radio(
                value: 2,
                groupValue: _groupValue,
                onChanged: (v) {
                  setState(() {
                    _groupValue = v;
                  });
                },
              )
            ],
          ),
        ],
      ),
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
                  maxLines: 1,
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
                      SelectTypeRow(
                        type: "书本",
                      ),
                      SelectTypeRow(
                        type: "服饰",
                      ),
                      SelectTypeRow(
                        type: "交通",
                      ),
                      SelectTypeRow(
                        type: "化妆",
                      ),
                      SelectTypeRow(
                        type: "服务",
                      ),
                      SelectTypeRow(
                        type: "娱乐",
                      ),
                      SelectTypeRow(
                        type: "电子",
                      ),
                      SelectTypeRow(
                        type: "食品",
                      ),
                      FlatButton(
                          child: Text(
                            "确定",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              if (selectedTypeList.length != 0) {
                                _type = "";

                                for (int i = 0;
                                    i < selectedTypeList.length - 1;
                                    i++) {
                                  _type = _type + selectedTypeList[i] + ",";
                                }
                                _type = _type +
                                    selectedTypeList[
                                        selectedTypeList.length - 1];
                                print(_type);
                                selectedTypeList = [];
                              }

                              Navigator.of(context).pop();
                            });
                          }),
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
                  "商品所在位置",
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
                      generateAddressRow(context, "湖畔", <PopupMenuItem<String>>[
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
                      generateAddressRow(context, "荔园", <PopupMenuItem<String>>[
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
                      generateAddressRow(context, "欣园", <PopupMenuItem<String>>[
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
                      generateAddressRow(context, "慧园", <PopupMenuItem<String>>[
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
                      generateAddressRow(context, "创园", <PopupMenuItem<String>>[
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
                      generateAddressRow(
                          context, "教学区", <PopupMenuItem<String>>[
                        PopupMenuItem<String>(value: '图书馆', child: Text('图书馆')),
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

  PopupMenuButton generateAddressRow(BuildContext context, String address,
      List<PopupMenuItem<String>> addresses) {
    return PopupMenuButton<String>(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            address,
          ),
        ),
      ),
      onSelected: (String value) {
        setState(() {
          _area = value;
          Navigator.of(context).pop();
        });
      },
      itemBuilder: (BuildContext context) => addresses,
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
                      SelectPaymentRow(
                        payment: "支付宝",
                      ),
                      SelectPaymentRow(
                        payment: "微信",
                      ),
                      SelectPaymentRow(
                        payment: "现金",
                      ),
                      SelectPaymentRow(
                        payment: "其他",
                      ),
                      FlatButton(
                          child: Text("确定`"),
                          onPressed: () {
                            setState(() {
                              if (selectedPaymentList.length != 0) {
                                _payment = "";

                                for (int i = 0;
                                    i < selectedPaymentList.length - 1;
                                    i++) {
                                  _payment =
                                      _payment + selectedPaymentList[i] + ",";
                                }
                                _payment = _payment +
                                    selectedPaymentList[
                                        selectedPaymentList.length - 1];
                                print(_payment);
                                selectedPaymentList = [];
                              }

                              Navigator.of(context).pop();
                            });
                          }),
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
                        date.toString() +
                        "-" +
                        DateTime.now().hour.toString() +
                        ":" +
                        DateTime.now().minute.toString() +
                        ":" +
                        DateTime.now().second.toString();
                    print(_availableTime);
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
      padding: EdgeInsets.all(4.0),
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

class SelectTypeRow extends StatefulWidget {
  const SelectTypeRow({
    Key key,
    this.child,
    this.type,
  }) : super(key: key);

  final Widget child;
  final String type;

  @override
  _SelectTypeRowState createState() => _SelectTypeRowState();
}

class _SelectTypeRowState extends State<SelectTypeRow> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.type,
            style: TextStyle(color: _isSelected ? Colors.blue : Colors.black87),
          ),
          Icon(_isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: _isSelected ? Colors.blue : Colors.black87)
        ],
      ),
      onPressed: () {
        setState(() {
          _isSelected = !_isSelected;
          if (_isSelected)
            selectedTypeList.add(widget.type);
          else
            selectedTypeList.remove(widget.type);
        });
      },
    );
  }
}

class SelectPaymentRow extends StatefulWidget {
  const SelectPaymentRow({
    Key key,
    this.child,
    this.payment,
  }) : super(key: key);

  final Widget child;
  final String payment;

  @override
  _SelectPaymentRowState createState() => _SelectPaymentRowState();
}

class _SelectPaymentRowState extends State<SelectPaymentRow> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.payment,
            style: TextStyle(color: _isSelected ? Colors.blue : Colors.black87),
          ),
          Icon(_isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: _isSelected ? Colors.blue : Colors.black87)
        ],
      ),
      onPressed: () {
        setState(() {
          _isSelected = !_isSelected;
          if (_isSelected)
            selectedPaymentList.add(widget.payment);
          else
            selectedPaymentList.remove(widget.payment);
        });
      },
    );
  }
}

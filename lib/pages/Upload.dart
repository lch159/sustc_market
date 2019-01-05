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

  var _temporaryid = "";
  var _title = "";
  var _description = "";
  var _price = "";
  var _type = "";
  var _area = "";
  var _payment = "";
  var _putAwayTime = "";
  var _availableTime = "";
  var _operation = "S";
  var _objectid = "";


  List<SelectTypeRow> _types;

  File _image1;
  File _image2;
  File _image3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllType();
    selectedTypeList = [];
    selectedPaymentList = [];
  }

  Future<String> _getTempID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _temporaryid = prefs.getString("temporaryid");

    return _temporaryid;
  }

  void _getAllType() async {
    _types = new List();
    String url = "http://120.79.232.137:8080/helloSSM/dommodity/getAllType";
    Dio dio = new Dio();
    dio.interceptor.response.onSuccess = (Response response) {
      Map<String, dynamic> data = response.data;
      if (data["returncode"] == "200") {
        for (dynamic type in data["types"]) {
          setState(() {
            _types.add(SelectTypeRow(
              type: type.toString(),
            ));
          });
        }
      }
    };

    dio.get(url);
  }

  void _imageSubmitted(File image, int index) async {
    Dio dio = new Dio();
    String url = "http://120.79.232.137:8080/helloSSM/picture/uploadPicture";
    if (image != null) {
      var suffixArr = image.path.toString().split("/");
      var filenameArr = suffixArr[suffixArr.length - 1].split(".");
      var suffix = filenameArr[filenameArr.length - 1];
      FormData imageFormData = new FormData.from({
        "objectid": _objectid,
        "name": _objectid + "_image$index",
        "pictureFile": UploadFileInfo(image, suffix),
      });
      await dio.post(url, data: imageFormData);
    }
  }

  void _formSubmitted() async {
    var _form = _uploadFormKey.currentState;

    if (_form.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _temporaryid = prefs.getString("temporaryid");
      FormData uploadFormData = new FormData.from({
        "temporaryid": _temporaryid,
        "name": titleController.text,
        "description": descriptionController.text,
        "status": "SELLING",
        "putawaytime": dateTimeToString(DateTime.now()),
        "availabletime": _availableTime,
        "price": _price,
        "address": _area,
        "type": _type,
        "paytype": _payment,
        "operation": _operation,
      });

      _form.save();
      Dio dio = new Dio();
      String url =
          "http://120.79.232.137:8080/helloSSM/dommodity/createDommodity";
      print(uploadFormData);
      dio.interceptor.response.onSuccess = (Response response) {
        Map<String, dynamic> data = response.data;
        if (data["returncode"] == "200") {
          _objectid = data["dommodityid"];
          _imageSubmitted(_image1, 1);
          _imageSubmitted(_image2, 2);
          _imageSubmitted(_image3, 3);
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
      await dio.post(url, data: uploadFormData);
    }
  }

  String dateParseToString(DateTime parseDate) {
    var month;
    var week;
    switch (parseDate.weekday) {
      case 1:
        week = "Mon";
        break;
      case 2:
        week = "Tues";
        break;
      case 3:
        week = "Wed";
        break;
      case 4:
        week = "Thur";
        break;
      case 5:
        week = "Fri";
        break;
      case 6:
        week = "Sat";
        break;
      case 7:
        week = "Sun";
        break;
    }

    switch (parseDate.month.toString()) {
      case "1":
        month = "Jan";
        break;
      case "":
        month = "Feb";
        break;
      case "3":
        month = "Mar";
        break;
      case "4":
        month = "Apr";
        break;
      case "5":
        month = "May";
        break;
      case "6":
        month = "Jun";
        break;
      case "7":
        month = "Jul";
        break;
      case "8":
        month = "Aug";
        break;
      case "9":
        month = "Sep";
        break;
      case "10":
        month = "Oct";
        break;
      case "11":
        month = "Nov";
        break;
      case "12":
        month = "Dec";
        break;
    }

    return week +
        " " +
        month +
        " " +
        parseDate.day +
        " " +
        parseDate.hour +
        ":" +
        parseDate.minute +
        ":" +
        parseDate.second +
        " CST " +
        parseDate.year;
  }

  String dateTimeToString(DateTime datetime) {
    return datetime.year.toString() +
        "/" +
        datetime.month.toString() +
        "/" +
        datetime.day.toString() +
        "-" +
        datetime.hour.toString() +
        ":" +
        datetime.minute.toString() +
        ":" +
        datetime.second.toString();
  }

  DateTime stringParseToDate(String StringTime) {
    var parseTime = StringTime.split(" ");
    var year = parseTime[5];
    var month;
    switch (parseTime[1]) {
      case "Jan":
        month = "1";
        break;
      case "Feb":
        month = "";
        break;
      case "Mar":
        month = "3";
        break;
      case "Apr":
        month = "4";
        break;
      case "May":
        month = "5";
        break;
      case "Jun":
        month = "6";
        break;
      case "Jul":
        month = "7";
        break;
      case "Aug":
        month = "8";
        break;
      case "Sep":
        month = "9";
        break;
      case "Oct":
        month = "10";
        break;
      case "Nov":
        month = "11";
        break;
      case "Dec":
        month = "12";
        break;
    }
    var day = parseTime[2];
    var putAwayTime = parseTime[3].split(":");
    DateTime date = new DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(putAwayTime[0]),
        int.parse(putAwayTime[1]),
        int.parse(putAwayTime[2]));
    return date;
  }

  void getImage(int imageIndex) {
    var image;
    showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              FlatButton(
                child: Text('拍照'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  print(image);
                  setState(() {
                    switch (imageIndex) {
                      case 1:
                        _image1 = image;
                        break;
                      case 2:
                        _image2 = image;
                        break;
                      case 3:
                        _image3 = image;
                        break;
                    }
                  });
                },
              ),
              FlatButton(
                child: Text('从相册选取'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    switch (imageIndex) {
                      case 1:
                        _image1 = image;
                        break;
                      case 2:
                        _image2 = image;
                        break;
                      case 3:
                        _image3 = image;
                        break;
                    }
                  });
                },
              ),
            ],
          );
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
//        color: Colors.black45,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "发布",
      ),
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
              onPressed: () {
                setState(() {
                  getImage(1);
                });
              },
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
              onPressed: () {
                setState(() {
                  getImage(2);
                });
              },
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
              onPressed: () {
                setState(() {
                  getImage(3);
                });
              },
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

  Widget buildSingleRow(BuildContext context, String text, bool isDivided,
      VoidCallback callback) {
    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                RichText(
                  text: TextSpan(
                      text: "",
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: "",
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                        ),
                      ]),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          onPressed: callback,
        ),
        isDivided
            ? Divider(
                height: 10.0,
              )
            : Container(
                width: 0.0,
                height: 5.0,
              ),
      ],
    );
  }

  Column buildPriceRow(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                          if (RegExp(r'[0-9]').hasMatch(priceController.text) ||
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
        Divider(height: 10.0),
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
                    _operation = "S";
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
                    _operation = "B";
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
        FlatButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          ),
          onPressed: () {
            return showDialog<Null>(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('请选择种类'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  children: <Widget>[
                    Column(
                      children: _types,
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
                                  selectedTypeList[selectedTypeList.length - 1];

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
        Divider(height: 10.0),
      ],
    );
  }

  Column buildAreaRow(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      PopupMenuItem<String>(value: '湖畔一栋', child: Text('湖畔一栋')),
                      PopupMenuItem<String>(value: '湖畔二栋', child: Text('湖畔二栋')),
                      PopupMenuItem<String>(value: '湖畔三栋', child: Text('湖畔三栋')),
                      PopupMenuItem<String>(value: '湖畔四栋', child: Text('湖畔四栋')),
                      PopupMenuItem<String>(value: '湖畔五栋', child: Text('湖畔五栋')),
                      PopupMenuItem<String>(value: '湖畔六栋', child: Text('湖畔六栋')),
                    ]),
                    generateAddressRow(context, "荔园", <PopupMenuItem<String>>[
                      PopupMenuItem<String>(value: '荔园一栋', child: Text('荔园一栋')),
                      PopupMenuItem<String>(value: '荔园二栋', child: Text('荔园二栋')),
                      PopupMenuItem<String>(value: '荔园三栋', child: Text('荔园三栋')),
                      PopupMenuItem<String>(value: '荔园四栋', child: Text('荔园四栋')),
                      PopupMenuItem<String>(value: '荔园五栋', child: Text('荔园五栋')),
                      PopupMenuItem<String>(value: '荔园六栋', child: Text('荔园六栋')),
                      PopupMenuItem<String>(value: '荔园七栋', child: Text('荔园七栋')),
                      PopupMenuItem<String>(value: '荔园八栋', child: Text('荔园八栋')),
                    ]),
                    generateAddressRow(context, "欣园", <PopupMenuItem<String>>[
                      PopupMenuItem<String>(value: '欣园一栋', child: Text('欣园一栋')),
                      PopupMenuItem<String>(value: '欣园二栋', child: Text('欣园二栋')),
                      PopupMenuItem<String>(value: '欣园三栋', child: Text('欣园三栋')),
                      PopupMenuItem<String>(value: '欣园四栋', child: Text('欣园四栋')),
                      PopupMenuItem<String>(value: '欣园五栋', child: Text('欣园五栋')),
                      PopupMenuItem<String>(value: '欣园六栋', child: Text('欣园六栋')),
                      PopupMenuItem<String>(value: '欣园七栋', child: Text('欣园七栋')),
                      PopupMenuItem<String>(value: '欣园八栋', child: Text('欣园八栋')),
                    ]),
                    generateAddressRow(context, "慧园", <PopupMenuItem<String>>[
                      PopupMenuItem<String>(value: '慧园一栋', child: Text('慧园一栋')),
                      PopupMenuItem<String>(value: '慧园二栋', child: Text('慧园二栋')),
                      PopupMenuItem<String>(value: '慧园三栋', child: Text('慧园三栋')),
                      PopupMenuItem<String>(value: '慧园四栋', child: Text('慧园四栋')),
                      PopupMenuItem<String>(value: '慧园五栋', child: Text('慧园五栋')),
                      PopupMenuItem<String>(value: '慧园六栋', child: Text('慧园六栋')),
                      PopupMenuItem<String>(value: '慧园七栋', child: Text('慧园七栋')),
                      PopupMenuItem<String>(value: '慧园八栋', child: Text('慧园八栋')),
                    ]),
                    generateAddressRow(context, "创园", <PopupMenuItem<String>>[
                      PopupMenuItem<String>(value: '创园一栋', child: Text('创园一栋')),
                      PopupMenuItem<String>(value: '创园二栋', child: Text('创园二栋')),
                      PopupMenuItem<String>(value: '创园三栋', child: Text('创园三栋')),
                      PopupMenuItem<String>(value: '创园四栋', child: Text('创园四栋')),
                      PopupMenuItem<String>(value: '创园五栋', child: Text('创园五栋')),
                      PopupMenuItem<String>(value: '创园六栋', child: Text('创园六栋')),
                      PopupMenuItem<String>(value: '创园七栋', child: Text('创园七栋')),
                      PopupMenuItem<String>(value: '创园八栋', child: Text('创园八栋')),
                    ]),
                    generateAddressRow(context, "教学区", <PopupMenuItem<String>>[
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
        Divider(height: 10.0),
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
        FlatButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
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
        Divider(height: 10.0),
      ],
    );
  }

  Column buildPutAwayRow(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "预计上架到期时间",
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                Text(
                  _availableTime,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
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
              onConfirm: (year, month, day) {
                setState(() {
                  _availableTime = year.toString() +
                      "/" +
                      month.toString() +
                      "/" +
                      day.toString() +
                      "-" +
                      DateTime.now().hour.toString() +
                      ":" +
                      DateTime.now().minute.toString() +
                      ":" +
                      DateTime.now().second.toString();
                });
              },
            );
          },
        ),
        Container(
          width: 0.0,
          height: 5.0,
        )
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

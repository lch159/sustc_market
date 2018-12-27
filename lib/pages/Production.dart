import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductionPage extends StatefulWidget {
  String owner;
  String putAwayTime;
  String availableTime;
  String address;
  String price;
  String payment;
  String title;
  String description;
  String operation;
  String id;

  ProductionPage({
    Key key,
    this.id,
    this.owner,
    this.putAwayTime,
    this.address,
    this.price,
    this.payment,
    this.title,
    this.description,
    this.operation,
    this.availableTime,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductionPageState();
  }
}

class _ProductionPageState extends State<ProductionPage> {
  bool _isFloatButton = false;

  List<Widget> _images =new List();

  String getParseInfo() {
    var parseTime = widget.putAwayTime.split(" ");
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

    return year +
        "年" +
        month +
        "月" +
        day +
        "日" +
        parseTime[3] +
        "发布于" +
        widget.address;
  }

  bool _isWechat = false;
  bool _isAlipay = false;
  bool _isCash = false;
  bool _isOthers = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parsePayment();
    _imageDownload(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: buildAppbar(context),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: _isFloatButton ? 0.5 : 0.0,
            child: GestureDetector(
              onTap: () {
                _isFloatButton = !_isFloatButton;
              },
              child: Container(
                color: Colors.black12,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              buildOwnerRow(context),
              Divider(),
              buildPriceRow(context),
              buildTitleRow(context),
              buildDescriptionRow(context),
              buildImagesRow(context),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  height: 10.0,
                  color: Colors.black12),
              buildCommentRow(context),
            ],
          ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  //生成顶部菜单栏
  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        PopupMenuButton<String>(
            icon: Icon(Icons.format_list_bulleted),
            onSelected: (String value) {
              setState(() {});
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(value: '我的信息', child: Text('我的信息')),
                  PopupMenuItem<String>(value: '我的消息', child: Text('我的消息')),
                  PopupMenuItem<String>(value: '我的订单', child: Text('我的订单'))
                ])
      ],
    );
  }

  //生成头像栏
  ListTile buildOwnerRow(BuildContext context) {
    return ListTile(
      title: Text(
        widget.owner,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
      subtitle: Text(
        getParseInfo(),
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      leading: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Colors.blue),
        width: 50.0,
        height: 50.0,
        child: Icon(
          Icons.person_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  //生成价格栏
  Row buildPriceRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: RichText(
            text: TextSpan(
              text: '￥',
              style: TextStyle(fontSize: 15.0, color: Colors.red),
              children: <TextSpan>[
                TextSpan(
                  text: widget.price,
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        _isWechat
            ? buildPaymentContainer(context, "微", Colors.green)
            : Container(),
        _isAlipay
            ? buildPaymentContainer(context, "支", Colors.blue)
            : Container(),
        _isCash ? buildPaymentContainer(context, "现", Colors.red) : Container(),
        _isOthers
            ? buildPaymentContainer(context, "+", Colors.grey)
            : Container(),
      ],
    );
  }

  //生成标题栏
  Container buildTitleRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 23.0),
      ),
    );
  }

  //生成支付Container
  Container buildPaymentContainer(
      BuildContext context, String text, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(90.0)), color: color),
      width: 30.0,
      height: 30.0,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  //生成描述栏
  Container buildDescriptionRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        widget.description,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 19.0),
      ),
    );
  }

  //生成图片部分
  Padding buildImagesRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: _images,
      ),
    );
  }

  //生成评论栏
  Column buildCommentRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "评论",
                style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w700),
              )),
        ),
        Divider(),
        ListTile(
          title: Text(
            'UserName',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
          subtitle: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Comment",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20.0,
                      color: Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("8/10   全部回复",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0)),
              )
            ],
          ),
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                color: Colors.blue),
            width: 40.0,
            height: 40.0,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void parsePayment() {
    var _payments = widget.payment.split(",");
    if (_payments.contains("微信")) _isWechat = true;
    if (_payments.contains("支付宝")) _isAlipay = true;
    if (_payments.contains("现金")) _isCash = true;
    if (_payments.contains("其他")) _isOthers = true;
  }

  void _getImage(List<String> imageNames) {


  }

  void _imageDownload(String id) async {
    Dio dio = new Dio();
    String url = "http://120.79.232.137:8080/helloSSM/picture/findAll";

//    List<String> _imagesList;
    FormData imagesData = new FormData.from({"objectid": id});
    dio.interceptor.response.onSuccess = (Response response) {
      List<dynamic> imageNames = response.data["pictureIdSet"];
      print(imageNames.toString());
      _images = new List();
      String url =
          "http://120.79.232.137:8080/helloSSM/picture/download?filename=";
      for (String image in imageNames) {
        print(image);
        setState(() {
          _images.add(Padding(
            padding: const EdgeInsets.symmetric(vertical :8.0),
            child: CachedNetworkImage(
              imageUrl: url + image,
              placeholder: CircularProgressIndicator(),
              errorWidget: Icon(Icons.error),
              fadeOutDuration: Duration(seconds: 1),
              fadeInDuration: Duration(seconds: 1),
            ),
          ));
        });
      }
      print("connect success");
    };

    await dio.post(url, data: imagesData);
  }

  Stack buildFloatingActionContainer(BuildContext context) {
    return Stack(
      children: <Widget>[],
    );
  }

  //生成浮动按钮
  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: _isFloatButton ? Icon(Icons.clear) : Icon(Icons.border_color),
      elevation: 7.0,
      highlightElevation: 14.0,
      onPressed: () {
        setState(() {
          _isFloatButton = !_isFloatButton;
        });
      },
    );
  }
}

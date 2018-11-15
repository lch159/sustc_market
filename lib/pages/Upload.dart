import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

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

  var _title;
  var _description;
  var _repassword;
  var _email;
  var _auth;

  File _image1;
  File _image2;
  File _image3;

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
          InnerRow(
            child: Form(
                key: _uploadFormKey,
                child: Column(
                  children: <Widget>[
                    buildTitleTextField(context),
                    buildDescriptionTextField(context),
                    buildImagesRow(context),
                  ],
                )),
          ),
          Container(
            height: 10.0,
            color: Colors.black12,
          ),
          InnerRow(
              child: Column(
            children: <Widget>[
              buildPriceRow(context),
              Divider(),
              buildTypeRow(context),
              Divider(),
              buildAreaRow(context),
              Divider(),
              buildPaymentRow(context),
              Divider(),
            ],
          )),
          InnerRow(
            child: buildUploadButton(context),
          )
        ],
      )),
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
      decoration: InputDecoration(
          border: UnderlineInputBorder(), hintText: '标题 请在此输入发布的标题'),
      onSaved: (val) {
        _title = val;
      },
    );
  }

  TextFormField buildDescriptionTextField(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
        hintText: '描述 请在此描述一下所发布的物品',
      ),
      onSaved: (val) {
        _description = val;
      },
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

  Container buildPriceRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: FlatButton(
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "价格",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          )),
    );
  }

  Container buildTypeRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: FlatButton(
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "分类",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          )),
    );
  }

  Container buildAreaRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: FlatButton(
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "位置",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          )),
    );
  }

  Container buildPaymentRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: FlatButton(
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "支持的交易方式",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          )),
    );
  }

  Container buildUploadButton(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 20,
      ),
      child: RaisedButton(
        onPressed: () {},
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

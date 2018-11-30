import 'package:flutter/material.dart';

class ProductionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductionPageState();
  }
}

class _ProductionPageState extends State<ProductionPage> {
  bool _isFloatButton = false;

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
        'UserName',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
      subtitle: Text(
        '2018年08月08日 18:88 发布于 湖畔三栋',
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
                  text: "6499.00",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              color: Colors.green),
          width: 30.0,
          height: 30.0,
          child: Center(
            child: Text(
              "微",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              color: Colors.blue),
          width: 30.0,
          height: 30.0,
          child: Center(
            child: Text(
              "支",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              color: Colors.red),
          width: 30.0,
          height: 30.0,
          child: Center(
            child: Text(
              "现",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  //生成标题栏
  Container buildTitleRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        "Apple/苹果 11 英寸 iPad Pro",
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 23.0),
      ),
    );
  }

  //生成描述栏
  Container buildDescriptionRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        "新一代 iPad Pro，全面新生。全新，全面屏，全方位强大。\r\n"
            "精致设计最薄的 iPad 中，深藏先进技术。Liquid 视网膜显示屏。\r\n"
            "绚丽的色彩，流畅的响应，在各种光线下阅读都舒服。\r\n"
            "面容 ID无论横向纵向，都能解锁 iPad、登录各款 App，还能扫一眼就支付。\r\n",
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 19.0),
      ),
    );
  }

  //生成图片部分
  Padding buildImagesRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Image.asset("images/TempProductionImage/pro1.jpg"),
          Image.asset("images/TempProductionImage/pro2.jpg"),
          Image.asset("images/TempProductionImage/pro3.jpg"),
          Image.asset("images/TempProductionImage/pro4.jpg"),
        ],
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
                  "能小刀吗？",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20.0,color: Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("8/10   全部回复",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0)),
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

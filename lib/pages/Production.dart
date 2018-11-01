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
      body: ListView(
        children: <Widget>[
          buildOwnerRow(context),
          Divider(),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context),

    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        PopupMenuButton<String>(
            icon: Icon(Icons.format_list_bulleted),
            onSelected: (String value) {
              setState(() {});
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuItem<String>>[
              PopupMenuItem<String>(value: '我的信息', child: Text('我的信息')),
              PopupMenuItem<String>(value: '我的消息', child: Text('我的消息')),
              PopupMenuItem<String>(value: '我的订单', child: Text('我的订单'))
            ])
      ],
    );
  }

  ListTile buildOwnerRow(BuildContext context) {
    return ListTile(
      title: Text('UserName'),
      subtitle: Text('于2018年08月08日 18:88 发布'),
      //之前显示icon
      leading: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            color: Colors.blue),
        width: 50.0,
        height: 50.0,
        child: Icon(
          Icons.person_outline,
          color: Colors.white,
        ),
      ),
      trailing: Container(
        child: Column(
          children: <Widget>[
            Icon(Icons.payment),
            Icon(Icons.payment),
            Icon(Icons.payment),
          ],
        ),
      ),
    );
  }

  Column buildTitleRow(BuildContext context) {
    return Column(
      children: <Widget>[

      ],
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: _isFloatButton ? Icon(Icons.clear) : Icon(Icons.add),
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

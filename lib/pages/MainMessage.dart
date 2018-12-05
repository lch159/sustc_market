import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InnerRow(
          child: Card(
            child: ListTile(
              title: Text('UserName'),
              subtitle: Text('Message Content'),
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
              trailing: Text(
                '18:18',
                style: TextStyle(color: Colors.grey),
              ),
              //之后显示checkBox
            ),
          ),
        );
      },
      itemCount: 20,
    );
  }
}

//内部空间中行设定
class InnerRow extends StatefulWidget {
  const InnerRow({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child; //分类ICON

  @override
  _InnerRowState createState() => _InnerRowState();
}

class _InnerRowState extends State<InnerRow> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
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

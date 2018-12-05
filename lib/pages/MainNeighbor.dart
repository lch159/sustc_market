import 'package:flutter/material.dart';

class NeighborPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InnerRow(
            child: NeighborCard(
              accountPicture: '',
              name: 'UserName',
              description: 'Description here '
                  '',
              image1: 'images/LOGO/1.5x/logo_hdpi.png',
              image2: 'images/LOGO/1.5x/logo_hdpi.png',
              image3: 'images/LOGO/1.5x/logo_hdpi.png',
            ),
          );
        },
        itemCount: 20,
      ),
    );
  }
}

class NeighborCard extends StatefulWidget {
  const NeighborCard({
    Key key,
    this.child,
    this.name,
    this.accountPicture,
    this.description,
    this.image1,
    this.image2,
    this.image3,
  }) : super(key: key);
  final Widget child;
  final String image1;
  final String image2;
  final String image3;
  final String name;
  final String description;
  final String accountPicture;

  @override
  _NeighborCard createState() => _NeighborCard();
}

class _NeighborCard extends State<NeighborCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(90.0)),
                        color: Colors.blue),
                    width: 50.0,
                    height: 50.0,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    )),
              ),
              Text(
                widget.name,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                widget.description,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: Container(
                width: 72.0,
                height: 72.0,
                child: Image.asset(widget.image1),
              )),
              Expanded(
                  child: Container(
                width: 72.0,
                height: 72.0,
                child: Image.asset(widget.image2),
              )),
              Expanded(
                  child: Container(
                width: 72.0,
                height: 72.0,
                child: Image.asset(widget.image3),
              )),
            ],
          ),
        ],
      ),
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

import 'package:flutter/material.dart';
import 'package:sustc_market/pages/Search.dart';
import 'package:sustc_market/pages/Login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sustc_market/pages/Select.dart';

void main() {
  runApp(MaterialApp(
    title: 'SUSTech Market',
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int tabIndex = 0;
  var bodies = [HomePage(), NeighborPage(), MessagePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: TextField(
            controller: TextEditingController(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0))),
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Colors.grey,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: HomeBuilder.homeDrawer(),
      ),
      body: bodies[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text(
                '主页',
              )),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
            ),
            title: Text(
              '附近',
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
              ),
              title: Text(
                '消息',
              )),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 7.0,
        highlightElevation: 14.0,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
      ),
    );
  }
}

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InnerRow(
              child: CarouselSlider(
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.blue),
                          child: Image.asset(
                            "images/Advertisements/ad$i.jpg",
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  }).toList(),
                  height: 150.0,
                  autoPlay: true),
            ),
            InnerRow(
              child: Card(
                  elevation: 2.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InnerButton(
                            text: Text('类别'),
                          ),
                          InnerButton(
                            text: Text('类别'),
                          ),
                          InnerButton(
                            text: Text('类别'),
                          ),
                          InnerButton(
                            text: Text('类别'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InnerButton(
                            text: Text('类别'),
                          ),
                          InnerButton(
                            text: Text('类别'),
                          ),
                          InnerButton(
                            text: Text('类别'),
                          ),
                          InnerButton(
                            text: Text('类别'),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
//              ListView.builder(itemBuilder: (context, index) {
//              return   InnerRow(child:   ItemRow(),);
//            },
//              itemCount: 20,),

            Divider(),
            InnerRow(
              child: ItemRow(),
            ),
            InnerRow(
              child: ItemRow(),
            ),
            InnerRow(
              child: ItemRow(),
            ),
            InnerRow(
              child: ItemRow(),
            ),
            InnerRow(
              child: ItemRow(),
            ),
            InnerRow(
              child: ItemRow(),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBuilder {
  //侧边栏
  static Widget homeDrawer() {
    return ListView(padding: const EdgeInsets.only(), children: <Widget>[
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('images/LOGO/4x/logo_xxxhdpi.jpg')),
        accountName: Text(
          'UserName',
        ),
        accountEmail: Text(
          'UserEmail@example.com',
        ),
      ),
      ClipRect(
        child: ListTile(
          leading: CircleAvatar(child: Icon(Icons.perm_contact_calendar)),
          title: Text('我的信息'),
          onTap: () {},
        ),
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.add_shopping_cart)),
        title: Text('我的交易'),
        subtitle: Text('我买的和我卖的'),
        onTap: () {},
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.settings)),
        title: Text('设置'),
        onTap: () => {},
      ),
      AboutListTile(
        icon: CircleAvatar(child: Text('Ab')),
        child: Text('关于'),
        applicationName: 'Test',
        applicationVersion: '1.0',
        applicationLegalese: 'applicationLegalese',
        aboutBoxChildren: <Widget>[Text('BoxChildren'), Text('box child 2')],
      ),
    ]);
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

//内部分类圆形控件
class InnerButton extends StatefulWidget {
  const InnerButton({Key key, this.child, this.text}) : super(key: key);
  final Widget child;
  final Widget text;

  @override
  _InnerButtonState createState() => _InnerButtonState();
}

class _InnerButtonState extends State<InnerButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          shape: CircleBorder(),
          color: Colors.blue,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SelectPage()));
          },
          child: Container(),
        ),
        widget.text
      ],
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key key,
    this.child,
    this.image,
    this.title,
    this.price,
  }) : super(key: key);
  final Widget child;
  final String image;
  final String title;
  final String price;

  @override
  _ItemCardState createState() => _ItemCardState();
}

//商品卡
class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                      color: Colors.black12,
              child: Image.asset(widget.image,fit: BoxFit.fill,),
            ),
            flex: 4,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              alignment: Alignment.center,
              child: Text('￥' + widget.price,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.red),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

//商品行
class ItemRow extends StatefulWidget {
  const ItemRow({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 220.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ItemCard(
              image: 'images/LOGO/1.5x/logo_hdpi.png',
              title: 'itemNammmmmmmmmmmmmmmmmmmme',
              price: '888888',
            ),
            flex: 1,
          ),
          Expanded(
            child: ItemCard(
              image: 'images/LOGO/1.5x/logo_hdpi.png',
              title: 'itemNammmmmmmmmmmmmmmmme',
              price: '888888',
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

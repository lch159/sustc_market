import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sustc_market/pages/Select.dart';

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
                            text: Text('书本'),
                            child: Icon(Icons.book),
                          ),
                          InnerButton(
                            text: Text('食品'),
                            child: Icon(Icons.fastfood),
                          ),
                          InnerButton(
                            text: Text('工具'),
                            child: Icon(Icons.build),
                          ),
                          InnerButton(
                            text: Text('电子产品'),
                            child: Icon(Icons.phonelink),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InnerButton(
                            text: Text('化妆品'),
                            child: Icon(Icons.local_florist),
                          ),
                          InnerButton(
                            text: Text('服饰'),
                            child: Icon(Icons.accessibility),
                          ),
                          InnerButton(
                            text: Text('信息资源'),
                            child: Icon(Icons.compare_arrows),
                          ),
                          InnerButton(
                            text: Text('集收'),
                            child: Icon(
                              Icons.pan_tool,
                            ),
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
              child: Container(
                height: 220.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ItemCard(
                        image: 'images/tempItems/p1.jpg',
                        title: '出顾家北手把手教你雅思写作',
                        price: '20',
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: ItemCard(
                        image: 'images/tempItems/p2.png',
                        title: '收一个USB转串口数据线',
                        price: '面议',
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
            InnerRow(
              child: Container(
                height: 220.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ItemCard(
                        image: 'images/tempItems/p3.jpg',
                        title: '出外星人17r3 配置如图',
                        price: '面议',
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: ItemCard(
                        image: 'images/tempItems/p5.jpg',
                        title: '收这本书',
                        price: '40',
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
            InnerRow(
              child: Container(
                height: 220.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ItemCard(
                        image: 'images/tempItems/p6.jpg',
                        title: '出一瓶这个',
                        price: '45',
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: ItemCard(
                        image: 'images/tempItems/p7.png',
                        title: '试收一颗这个型号的纽扣电池',
                        price: '10',
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
            InnerRow(
              child: Container(
                height: 220.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ItemCard(
                        image: 'images/tempItems/p8.jpg',
                        title: '代购YPL瘦腿裤薄款180秋冬加厚款210',
                        price: '180',
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: ItemCard(
                        image: 'images/LOGO/1.5x/logo_hdpi.png',
                        title: 'itemNam',
                        price: '888888',
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
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
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SelectPage()));
          },
          child: widget.child,
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
      child: FlatButton(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black12,
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.fill,
                ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
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
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SelectPage()));
        },
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
              title: 'itemNam',
              price: '888888',
            ),
            flex: 1,
          ),
          Expanded(
            child: ItemCard(
              image: 'images/LOGO/1.5x/logo_hdpi.png',
              title: 'itemNam',
              price: '888888',
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChattingPage extends StatefulWidget {
  ChattingPage({
    Key key,
    this.receiver,
    this.isFromProduction,
    this.itemId,
  }) : super(key: key);

  final String receiver;
  final bool isFromProduction;
  final String itemId;

  @override
  State<StatefulWidget> createState() {
    return _ChattingPageState();
  }
}

class _ChattingPageState extends State<ChattingPage>
    with TickerProviderStateMixin {
  List<Message> _messages = new List();
  List<String> _messagesString = new List();
  bool _isComposing = false;

  final TextEditingController _textController = TextEditingController();
  String _username = " ";
  String _temporaryid = "";
  WebSocketChannel _channel;
  bool _extraInfo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readLoginInfo().then((loginInfo) {
      _username = loginInfo["username"];
      _temporaryid = loginInfo["temporaryid"];
      _loadHistoryMessage();
      _connectWebServer(loginInfo["temporaryid"]);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _saveMessageToHistory();
    for (Message message in _messages) {
      message.animationController.dispose();
    }
    _channel.sink.close();
  }

  Future<Map<String, String>> readLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoginState = prefs.getString("isLogin");
    Map<String, String> loginInfo = new Map();
    if (isLoginState == "1") {
      loginInfo = {
        "isLogin": "true",
        "username": prefs.getString("username"),
        "temporaryid": prefs.getString("temporaryid"),
      };
    } else {
      loginInfo = {
        "isLogin": "false",
      };
    }
    return loginInfo;
  }

  void _saveMessageToHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
        _username + "_" + widget.receiver, _messagesString);
    List<String> messages = preferences.getStringList("messages");
    if (messages == null) {
      List<String> newMessages = new List();
      newMessages.add(_username + "_" + widget.receiver);
      preferences.setStringList("messages", newMessages);
    } else if (!messages.contains(_username + "_" + widget.receiver)) {
      messages.add(_username + "_" + widget.receiver);
      await preferences.setStringList("messages", messages);
    }
//    preferences.setStringList(_username + "_" + widget.receiver, new List());
//    preferences.clear();
  }

  void _loadHistoryMessage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> messageString =
        preferences.getStringList(_username + "_" + widget.receiver);
    if (messageString != null) {
      _messagesString = messageString;
      for (int i = messageString.length - 1; i > -1; i--) {
        var parsedMessage = messageString[i].split(",");
        print(parsedMessage.toString());
        var isReceive = parsedMessage[4] == "true" ? true : false;

        Message message = Message(
            source: parsedMessage[0],
            text: parsedMessage[2],
            time: parsedMessage[3],
            isReceive: isReceive,
            animationController: AnimationController(
                duration: Duration(milliseconds: 700), vsync: this));

        setState(() {
          _messages.insert(0, message);
        });
        message.animationController.forward();
      }
    }
  }

  void _connectWebServer(String temporaryid) {
    _channel = IOWebSocketChannel.connect(
        "ws://120.79.232.137:8080/helloSSM/webSocket");
    _channel.sink.add("login," + temporaryid);
    _channel.stream.listen((message) {
      var temp = message.toString().split(",");

      if (temp.length == 5) {
        setState(() {
          _handleReceivedMessage(temp[1], temp[2], temp[3], temp[4]);
        });
      }
    });
  }

  void _handleReceivedMessage(
    String source,
    String destination,
    String text,
    String time,
  ) {
    Message message = Message(
        source: source,
        text: text,
        isReceive: true,
        time: time,
        animationController: AnimationController(
            duration: Duration(milliseconds: 700), vsync: this));
    setState(() {
      _messages.insert(0, message);
      _messagesString.insert(0,
          source + "," + destination + "," + text + "," + time + "," + "true");
    });
    message.animationController.forward();
  }

  void _handleSendMessage(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    var source = _username;
    var destination = widget.receiver;
    var time =
        DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    _channel.sink.add("chat," + widget.receiver + "," + text + "," + time);

    Message message = Message(
        source: destination,
        text: text,
        isReceive: false,
        time: time,
        animationController: AnimationController(
            duration: Duration(milliseconds: 700), vsync: this));
    setState(() {
      _messages.insert(0, message);
      _messagesString.insert(0,
          source + "," + destination + "," + text + "," + time + "," + "false");
    });
    message.animationController.forward();
  }

  void _createOrder() async {
    Dio dio = new Dio();
    FormData data = FormData.from({
      "temporaryid": _temporaryid,
      "type": "B",
      "dommodityid": widget.itemId,
      "number": "1",
    });
    String url = "http://120.79.232.137:8080/helloSSM/order/create";
    dio.interceptor.response.onSuccess = (Response response) {
      _handleSendMessage("我已成功下单，请卖家即使查阅订单");
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("成功下单"),
            actions: <Widget>[
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      _extraInfo=!_extraInfo;
    };
    dio.interceptor.response.onError = (Error e) {

    };

    dio.get(url, data: data);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: _buildAppbar(context),
        body: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(context),
          )
        ]));
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      title: Center(child: Text(widget.receiver)),
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

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: _handleSendMessage,
                    decoration: InputDecoration.collapsed(hintText: '发送消息'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSendMessage(_textController.text)
                          : null),
                ),
                widget.isFromProduction
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                            icon: Icon(_extraInfo
                                ? FontAwesomeIcons.minus
                                : FontAwesomeIcons.plus),
                            onPressed: () {
                              setState(() {
                                _extraInfo = !_extraInfo;
                              });
                            }),
                      )
                    : Container(
                        width: 0.0,
                        height: 0.0,
                      ),
              ],
            ),
            _extraInfo
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildInfoCard(context, Icons.shopping_cart, "下单", () {
                        _createOrder();
                      }),
                      buildInfoCard(context, Icons.add, "", null),
                      buildInfoCard(context, Icons.add, "", null),
                    ],
                  )
                : Container(
                    width: 0.0,
                    height: 0.0,
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(
      BuildContext context, IconData icon, String text, VoidCallback callback) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon),
            Text(text),
          ],
        ),
        onTap: callback,
      ),
    );
  }
}

class Message extends StatelessWidget {
  Message(
      {this.text,
      this.animationController,
      this.isReceive,
      this.source,
      this.time});

  final String text;
  final AnimationController animationController;
  final bool isReceive;
  final String source;
  final String time;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isReceive ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              isReceive
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
                      child: CircleAvatar(child: Icon(Icons.person)),
                    )
                  : Container(
                      width: 0.0,
                      height: 0.0,
                    ),
              isReceive
                  ? Container(
                      width: 0.0,
                      height: 0.0,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(
                          time,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w200),
                        )),
                      ),
                    ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
//                          style: TextStyle(fontSize: 16.0),
                        maxLines: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              isReceive
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(
                          time,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w200),
                        )),
                      ),
                    )
                  : Container(
                      width: 0.0,
                      height: 0.0,
                    ),
              isReceive
                  ? Container(
                      width: 0.0,
                      height: 0.0,
                    )
                  : Container(
                      margin: const EdgeInsets.only(
                          left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
                      child: CircleAvatar(child: Icon(Icons.person)),
                    )
            ]));
  }
}

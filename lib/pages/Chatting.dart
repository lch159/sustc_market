import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChattingPage extends StatefulWidget {
  ChattingPage({
    Key key,
    this.channel,
    this.receiver,
  }) : super(key: key);

  final WebSocketChannel channel;
  final String receiver;

  @override
  State<StatefulWidget> createState() {
    return _ChattingPageState();
  }
}

class _ChattingPageState extends State<ChattingPage>
    with TickerProviderStateMixin {
  List<Message> _messages = new List();
  List<String> _messagesString = new List();

  final TextEditingController _textController = TextEditingController();
  String _username = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readLoginInfo().then((loginInfo) {
      _username = loginInfo["username"];
      _readMessage();
      _connectWebServer(loginInfo["temporaryid"], widget.receiver);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _saveMessage();
    for (Message message in _messages) {
      message.animationController.dispose();
    }
    widget.channel.sink.close();
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
            child: Row(children: <Widget>[
              Flexible(
                  child: TextField(
                controller: _textController,
                onSubmitted: (val) {
                  _handleMessage(_username, _textController.text,
                      DateTime.now().toLocal().hour.toString()+":"+ DateTime.now().toLocal().minute.toString(), false, false);
                },
                decoration: InputDecoration.collapsed(hintText: '发送消息'),
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleMessage(
                      _username,
                      _textController.text,
                   DateTime.now().toLocal().hour.toString()+":"+ DateTime.now().toLocal().minute.toString(),
                      false,
                      false),
                ),
              )
            ])));
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

  void _saveMessage() async {
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

  void _readMessage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> response =
        preferences.getStringList(_username + "_" + widget.receiver);
    if (response != null) {
      for (int i = response.length - 1; i > -1; i--) {
        var parsedMessage = response[i].split(",");

        var isReceive = parsedMessage[3] == "true" ? true : false;

        _handleMessage(
          parsedMessage[0],
          parsedMessage[1],
          parsedMessage[2],
          isReceive,
          true,
        );
      }
    }
  }

  void _connectWebServer(String temporaryid, receiver) async {
    widget.channel.sink.add("login," + temporaryid);
    widget.channel.stream.listen((message) {
      var temp = message.toString().split(",");
      if (temp.length == 4) {
        setState(() {
          _handleMessage(receiver, temp[2], temp[3], true, false);
        });
      }
    });
  }

  void _handleMessage(
    String name,
    String text,
    String time,
    bool isReceive,
    bool isHistory,
  ) {

    if (!isReceive && !isHistory) {
      widget.channel.sink.add(
          "chat," + widget.receiver + "," + _textController.text + "," + time);
      _textController.clear();
    }

    Message message = Message(
        text: text,
        isReceive: isReceive,
        name: name,
        time: time,
        animationController: AnimationController(
            duration: Duration(milliseconds: 700), vsync: this));
    setState(() {
      _messages.insert(0, message);
      _messagesString.insert(
          0,
          name +
              "," +
              text +
              "," +
              time +
              "," +
              isReceive.toString() +
              "," +
              isHistory.toString());
    });
    message.animationController.forward();
  }
}

class Message extends StatelessWidget {
  Message(
      {this.text,
      this.animationController,
      this.isReceive,
      this.name,
      this.time});

  final String text;
  final AnimationController animationController;
  final bool isReceive;
  final String name;
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
              isReceive?Container(width: 0.0,height: 0.0,):Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(child: Text(time,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w200),)),
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
              isReceive?Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(child: Text(time,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w200),)),
                ),
              ):Container(width: 0.0,height: 0.0,),
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

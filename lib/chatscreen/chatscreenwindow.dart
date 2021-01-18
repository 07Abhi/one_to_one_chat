import 'package:chatroom/chatscreen/chat_utils/chat_utils.dart';
import 'package:chatroom/databasesmethods/database_access_methods.dart';
import 'package:chatroom/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChatScreenWindow extends StatefulWidget {
  static const String id = "/chatScreen";
  final String username;
  final String chatRoomid;
  final String myUserName;
  final String notificationToken;

  ChatScreenWindow({
    this.username,
    this.chatRoomid,
    this.myUserName,
    this.notificationToken,
  });
  @override
  _ChatScreenWindowState createState() => _ChatScreenWindowState();
}

class _ChatScreenWindowState extends State<ChatScreenWindow> {
  TextEditingController _messageController = TextEditingController();

  Stream chatMessageStream;
  Stream chatRoomData;

  @override
  void initState() {
    Stream data =
        DatabaseMethodsAcess().getConversationMessages(widget.chatRoomid);
    Stream data1 = DatabaseMethodsAcess().getChatRoom(widget.myUserName);
    setState(() {
      chatMessageStream = data;
      chatRoomData = data1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        title: Text(widget.username),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            iconSize: 30.0,
            color: AppColor.appBarCrossColor,
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
      body: Stack(
        children: [
          ChatUtils.chatMessageList(widget.myUserName, chatMessageStream),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColor.searchPageTextFieldBorder,
                border: Border.all(
                  width: 2.0,
                  color: AppColor.textfieldColor,
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        keyboardType: TextInputType.name,
                        maxLines: 2,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.searchPageTextFieldBorder,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.searchPageTextFieldBorder,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.chat,
                            color: Colors.black45,
                            size: 30.0,
                          ),
                          hintText: 'Type Message....',
                          hintStyle: TextStyle(
                            color: AppColor.chatBarIconAndTextColor,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 30.0,
                        color: AppColor.chatBarIconAndTextColor,
                      ),
                      onPressed: () {
                        ChatUtils.sendMessages(
                          context,
                          _messageController.text,
                          widget.myUserName,
                          widget.notificationToken,
                          widget.chatRoomid,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

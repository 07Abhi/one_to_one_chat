import 'package:chatroom/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MessageTiles extends StatelessWidget {
  final String msg;
  final bool isMe;
  MessageTiles({this.msg, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isMe ? 0 : 24.0, right: isMe ? 24 : 0, top: 10.0, bottom: 10.0),
      width: MediaQuery.of(context).size.width,
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
        height: 50.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isMe ? AppColor.myUserColor : AppColor.otherUserColor,
          ),
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
        ),
        child: Text(
          msg,
          style: TextStyle(
            color: AppColor.chatMsgColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

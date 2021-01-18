import 'package:chatroom/chatscreen/chatscreenwindow.dart';
import 'package:chatroom/chatscreen/widgets/chat_widget.dart';
import 'package:chatroom/databasesmethods/database_access_methods.dart';
import 'package:chatroom/notificationservice/notification_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ChatUtils {
  static getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  static createChatRommAndStartConversation(BuildContext context,
      String username, String tokenNotifiction, String currUserName) {
    if (username != currUserName) {
      String chatRoomId = ChatUtils.getChatRoomId(username, currUserName);
      List<String> usersNames = [username, currUserName];
      Map<String, dynamic> chatRoomMap = {
        "users": usersNames,
        "chatRoomId": chatRoomId,
      };
      print(tokenNotifiction);
      DatabaseMethodsAcess().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreenWindow(
            username: username,
            chatRoomid: chatRoomId,
            myUserName: currUserName,
            notificationToken: tokenNotifiction,
          ),
        ),
      );
    } else {
      Toast.show(
        "Cant send message to own",
        context,
        duration: 2,
        gravity: Toast.BOTTOM,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
      );
    }
  }

  static Widget searchList(QuerySnapshot userData, String currentUserName) {
    return userData != null
        ? ListView.builder(
            itemCount: userData.docs.length,
            itemBuilder: (context, index) {
              return userData.docs.isEmpty
                  ? Center(
                      child: Text(
                        "No Reuslt Found",
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.grey.shade200),
                      ),
                    )
                  : ListTile(
                      tileColor: Colors.white54,
                      title: Text(userData.docs[index].data()['name']),
                      subtitle: Text(userData.docs[index].data()['email']),
                      trailing: FlatButton(
                        onPressed: () {
                          ChatUtils.createChatRommAndStartConversation(
                            context,
                            userData.docs[index].data()['name'],
                            userData.docs[index].data()['token'],
                            currentUserName,
                          );
                        },
                        child: Text(
                          "Message",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    );
            },
          )
        : Center(
            child: Text(
              "Search Users!!!!",
              style: TextStyle(fontSize: 20.0, color: Colors.grey.shade200),
            ),
          );
  }

  static Widget chatMessageList(String username, Stream chatMessageStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (context, asynSnapshot) {
        if (!asynSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white54,
              strokeWidth: 5.0,
            ),
          );
        }
        return ListView.builder(
          itemCount: asynSnapshot.data.docs.length,
          itemBuilder: (context, index) {
            return MessageTiles(
              msg: asynSnapshot.data.docs[index].data()['message'],
              isMe: asynSnapshot.data.docs[index].data()['sendBy'] == username,
            );
          },
        );
      },
    );
  }

  static sendMessages(BuildContext context, String message, String myUserName,
      String notificationToken, String chatRoomid) {
    if (message.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": message,
        "sendBy": myUserName,
        "timeStamp": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseMethodsAcess().sendChatMessages(chatRoomid, messageMap);
      sendAndRetrieveMessage(
        notificationToken,
        message: message,
        title: myUserName,
      );
    } else {
      Toast.show("Empty Message", context,
          duration: 1,
          gravity: Toast.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white);
    }
  }
}

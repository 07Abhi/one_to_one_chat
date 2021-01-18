import 'package:chatroom/chatscreen/chat_utils/chat_utils.dart';
import 'package:chatroom/databasesmethods/database_access_methods.dart';
import 'package:chatroom/utils/app_colors.dart';
import 'package:chatroom/utils/app_textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const String id = "/searchPage";
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  DatabaseMethodsAcess dbAccess = new DatabaseMethodsAcess();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  QuerySnapshot userData;
  String currentUserName;
  String currentUserEmail;
  String curentUserToken;

  Future<QuerySnapshot> initiateSearch(String name) async {
    QuerySnapshot data = await dbAccess.getUserByUserName(name);
    setState(() {
      userData = data;
    });
    return data;
  }

  //to fetch curret userdata
  getCurrentUserName() async {
    DocumentSnapshot data = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get();
    setState(() {
      currentUserName = data['name'];
      currentUserEmail = data['email'];
      curentUserToken = data['token'];
    });
  }

  @override
  void initState() {
    getCurrentUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffBackgroundColor.withOpacity(0.2),
      appBar: AppBar(
        title: Text("Search User"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              size: 30.0,
              color: AppColor.appBarCrossColor,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.name,
              style: TextStyle(fontSize: 16.0, color: AppColor.textfieldColor),
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  iconSize: 25.0,
                  color: AppColor.textfieldColor,
                  onPressed: () {},
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.searchPageTextFieldBorder,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.searchPageTextFieldBorder,
                    width: 2.0,
                  ),
                ),
                hintText: "Username......",
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: AppColor.searchPageTextFieldBorder,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ButtonTheme(
            height: 50.0,
            minWidth: MediaQuery.of(context).size.width * 0.5,
            child: FlatButton(
              onPressed: () {
                initiateSearch(_searchController.text);
                _searchController.clear();
              },
              child: Text(
                "Search",
                style: buttonStyle(),
              ),
              color: AppColor.flatButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ChatUtils.searchList(userData, currentUserName),
          )
        ],
      ),
    );
  }
}

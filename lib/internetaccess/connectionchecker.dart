import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

void checkConenctivity(BuildContext context) async {
  var internetChecker = await Connectivity().checkConnectivity();
  if (internetChecker != ConnectivityResult.mobile &&
      internetChecker != ConnectivityResult.wifi) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          "No Internet Access!!!",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    AppSettings.openWIFISettings();
                  },
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 20.0,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    exit(0);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

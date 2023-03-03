import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfiles extends StatefulWidget {
  //const UserProfile({Key? key}) : super(key: key);
  String? userid = '';
  String? displayName = '';
  String? pictureUrl = '';

  UserProfiles({this.userid, this.displayName, this.pictureUrl});
  @override
  _UserProfilesState createState() => _UserProfilesState();
}

class _UserProfilesState extends State<UserProfiles> {
  SharedPreferences? prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    getSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Line User Data"),
        actions: [
          GestureDetector(
              onTap: () async {
                try {
                  await LineSDK.instance.logout();
                  prefs?.clear();
                  Navigator.pop(context);
                  // prefs?.clear();
                } on PlatformException catch (e) {
                  print(e.message);
                }
              },
              child: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.pictureUrl!),
                        fit: BoxFit.fill,
                      ),
                      //  borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black))),
            ),
            Row(
              children: [
                Text("Username is:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.displayName!),
              ],
            ),
            Row(
              children: [
                Text("Userid is:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.userid!),
              ],
            )
          ],
        ),
      ),
    );
  }
}

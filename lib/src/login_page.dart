import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:line_login_app/src/progress.dart';
import 'package:line_login_app/src/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LineLoginPage extends StatefulWidget {
//  const LineLoginPage({Key? key}) : super(key: key);

  @override
  _LineLoginPageState createState() => _LineLoginPageState();
}

class _LineLoginPageState extends State<LineLoginPage> {
  late BuildContext _progressContext;
  SharedPreferences? prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs?.getString("logined") != null) {
      print('xxxxxxxxxxxxx');
      String userid = prefs!.getString('userid').toString();
      String displayName = prefs!.getString('displayName').toString();
      String pictureUrl = prefs!.getString('pictureUrl').toString();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfiles(
            userid: userid,
            displayName: displayName,
            pictureUrl: pictureUrl,
          ),
        ),
      );
    }
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
      appBar: AppBar(title: Text("Line Login")),
      body: Center(
        child: Container(
          height: 100,
          child: GestureDetector(
              onTap: _lineLogin,
              child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/LINE_logo.svg/480px-LINE_logo.svg.png")),
        ),
      ),
    );
  }

  _lineLogin() async {
    {
      try {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              _progressContext = context;
              return ProgressDialog();
            });

        final result = await LineSDK.instance
            .login(scopes: ["profile", "openid", "email"]);
        if (result != null) {
          Navigator.pop(_progressContext);
          print(result.userProfile?.data);
          print(result.userProfile?.pictureUrl);
          print(result.userProfile?.displayName);
          //เอาข้อมูลใส่ Shared preference
          prefs = await SharedPreferences.getInstance();
          prefs?.setString('logined', '1');
          prefs?.setString('userid', result.userProfile?.data['userId']);
          prefs?.setString(
              'displayName', result.userProfile?.data['displayName']);
          prefs?.setString(
              'pictureUrl', result.userProfile?.data['pictureUrl']);

          String userid = result.userProfile?.data['userId'];
          String displayName = result.userProfile?.data['displayName'];
          String pictureUrl = result.userProfile?.data['pictureUrl'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfiles(
                userid: userid,
                displayName: displayName,
                pictureUrl: pictureUrl,
              ),
            ),
          );
        }
      } on PlatformException catch (e) {
        // Error handling.
        print(e.stacktrace);
      }
    }
  }
}

import 'package:accountmanager/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class lock_page extends StatefulWidget {
  static SharedPreferences? prefs;

  @override
  State<lock_page> createState() => _lock_pageState();
}

class _lock_pageState extends State<lock_page> {
  TextEditingController t1 = TextEditingController();
  CircleUIConfig? circleUIConfig;
  KeyboardUIConfig? keyboardUIConfig;
  List<String>? digits;
  bool t = false;
  bool temp = false;

  String pass = "";
  String passCheck = "";

  get() async {
    lock_page.prefs = await SharedPreferences.getInstance();
    bool _passwordVisible = false;
    passCheck = lock_page.prefs!.getString('password_num') ?? "";
    (passCheck == "") ? WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        barrierDismissible: false,
        context: context, builder: (context) {
          return AlertDialog(
            actions: [
              Column(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.deepPurple,
                    alignment: Alignment.center,
                    child: Text("SET NEW PASSWORD",style: TextStyle(fontSize: 18),),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: StatefulBuilder(builder: (context, setState) {
                      return TextFormField(
                        keyboardType: TextInputType.text,
                        controller: t1,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Yopour Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      );
                    },),
                  ),
                  Text("ENTER 4 DIGIT PASSWORD !"),
                  Text(""),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          t1.text = "";
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.deepPurple,style: BorderStyle.solid),
                          ),
                          child: Text("CANCEL"),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          pass = t1.text;
                          temp = true;
                          lock_page.prefs!.setString('password_num', pass);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.white,style: BorderStyle.solid),
                          ),
                          child: Text("SET",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
      },);
    }) : null;
  }

  @override
  void initState() {
    super.initState();
    get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(lock_page == null || lock_page.prefs == null){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else{
      passCheck = lock_page.prefs!.getString("password_num") ?? pass;
      print("passCheck = $passCheck");
      double width = MediaQuery.of(context).size.width;
      return SafeArea(child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.fill,image: AssetImage("pic/splash.png"))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30,),
              Expanded(flex: 2,child: Container(
                height: double.infinity,
                width: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("pic/ic_launcher_round.png"))
                ),
              )),
              Expanded(flex: 1,child: Text("Account Manager",style: TextStyle(fontSize: 25,color: Colors.white),)),
              Expanded(flex: 1,child: Text("FORGOT PASSWORD ?",style: TextStyle(fontSize: 15,color: Colors.white),)),
              Expanded(flex: 16,child: Container(
                height: double.infinity,
                width: width,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: ScreenLock(
                  correctString: (passCheck.isNotEmpty) ? "${lock_page.prefs!.getString("password_num") ?? passCheck}" : "0000",
                  useBlur: false,
                  useLandscape: true,
                  onUnlocked: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return first();
                    },));
                },),
              )),
            ],
          ),
        ),
      ));
    }
  }
}

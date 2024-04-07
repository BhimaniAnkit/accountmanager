import 'package:flutter/material.dart';

class Dialoge_one extends StatefulWidget {
  const Dialoge_one({Key? key}) : super(key: key);

  @override
  State<Dialoge_one> createState() => _Dialoge_oneState();
}

class _Dialoge_oneState extends State<Dialoge_one> {
  TextEditingController pass = TextEditingController();
  TextEditingController q1 = TextEditingController();
  TextEditingController q2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2,color: Colors.black12),
          ),
          margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 150.0,bottom: 150.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Text('Setting',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
                TextField(
                  controller: pass,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Set Password",
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        actions: [
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                        ],
                      );
                    },);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12,width: 1),
                    ),
                    child: Text("Security Question 1         >"),
                  ),
                ),
                TextField(
                  controller: q1,
                  decoration: InputDecoration(
                    hintText: "Answer",
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        actions: [
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                          ListTile(onTap: () {
                          },title: Text("123"),),
                        ],
                      );
                    },);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.black12),
                    ),
                    child: Text("Security Question 1         >"),
                  ),
                ),
                TextField(
                  controller: q2,
                  decoration: InputDecoration(
                    hintText: "Answer",
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("Exit")),
                    TextButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Dialoge_two();
                      },));
                    }, child: Text("Set")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

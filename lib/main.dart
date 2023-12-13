import 'package:accountmanager/Controller/account_controller.dart';
import 'package:accountmanager/Controller/transaction_controller.dart';
import 'package:accountmanager/Transaction.dart';
import 'package:accountmanager/advance_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: first(),
  ));
  // runApp(MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   home: first(),
  // ));
}

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController accountNameController = TextEditingController();
  transaction_controller tc = Get.put(transaction_controller());
  var controller = Get.put(account_controller());

  @override
  Widget build(BuildContext context) {
    controller.GetDatabase()
        .then((value) => tc.GetTotaldb())
        .then((value) => controller.GetData())
        .then((value) => tc.SelectQuery());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("730099"),
        title: Text("Dashboard"),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.search)),
          IconButton(onPressed: () {

          }, icon: Icon(Icons.more_vert)),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        elevation: 8.0,
        shadowColor: Colors.deepOrange,
        width: 280,
        // shape: ShapeBorder(),
        surfaceTintColor: Colors.amber.shade400,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("pic/sidemenu_bg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: UserAccountsDrawerHeader(
                // currentAccountPictureSize: Size(50, 50),
                decoration: BoxDecoration(
                    // color: Colors.grey,
                    ),
                currentAccountPicture: Icon(
                  Ionicons.bookmarks_sharp,
                  grade: 15.0,
                  color: Colors.white,
                ),
                // currentAccountPicture: Image.asset("pic/ic_notification.png",alignment: Alignment.center,fit: BoxFit.fill,),
                // currentAccountPictureSize: Size(70, 70),
                accountName: Text(
                  "Account Manager",
                  textAlign: TextAlign.center,
                ),
                accountEmail: Text(""),
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(
                Icons.home,
              ),
            ),
            ListTile(
              title: Text("Backup"),
              leading: Icon(Icons.backup_sharp),
            ),
            ListTile(
              title: Text("Restore"),
              leading: Icon(Icons.restore_sharp),
            ),
            ListTile(
              title: Text("Change Currency"),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text("Change Password"),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text("Change Security question"),
              // leading: Icon(Icons.send_to_mobile_sharp),
              leading: Icon(Icons.app_settings_alt_outlined),
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text("Share the app"),
              leading: Icon(Icons.share_sharp),
            ),
            ListTile(
              title: Text("Rate the app"),
              leading: Icon(Icons.star_rate_sharp),
            ),
            ListTile(
              title: Text("Privacy policy"),
              // leading: Icon(Icons.privacy_tip_sharp),
              leading: Icon(Icons.policy_sharp),
            ),
            ListTile(
              title: Text("More apps"),
              leading: Icon(Icons.apps),
            ),
            ListTile(
              title: Text("Ads Free"),
              leading: Icon(Icons.block),
            ),
          ],
        ),
      ),
      // body: (controller.DataList.length != null)
      //     ? Obx(() {
      //         return ListOfAccount();
      //       })
      //     : Center(
      //         child: Icon(Icons.warning_rounded,
      //             size: 200,
      //             color: Colors.red,
      //             semanticLabel: "NO ACCOUNT ADDED"),
      //       ),
      body: Obx(() {
        return ListOfAccount();
      }),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          AddAccountDialog();
        },
        child: Icon(
          LucideIcons.copyPlus,
          size: 25,
          // color: Colors.orange,
        ),
      ),
      // child: Icon(LucideIcons.copyPlus),
    );
  }

  Widget ListOfAccount() {
    return ListView.builder(
      itemCount: controller.DataList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(Transaction(index));
          },
          child: Card(
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 150,
              width: Get.width * 0.9,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "${controller.DataList[index]['acname']}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            accountNameController.text = controller.DataList[index]['acname'];
                            UpdateDialog(index);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.purple,
                          )),
                      IconButton(
                          onPressed: () {
                            controller.DeleteData(
                                    index: controller.DataList[index]['id'])
                                .then((value) => tc.DeleteTable(index: index)
                                    .then((value) => controller.GetData().then(
                                        (value) => tc.DeleteAmount(
                                            tc.amount[index]['id']))))
                                .then((value) => tc.SelectQuery());
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.purple,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Credit(↑)",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Obx(() => Text(
                                    "₹ ${tc.amount[index]['credit']}",
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Debit(↓)",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Obx(() => Text(
                                    "₹ ${tc.amount[index]['debit']}",
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          // color: HexColor("5c0099"),
                          color: HexColor("990099"),
                          // color: Colors.purple,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Balance",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Obx(() => Text(
                                  "₹ ${tc.amount[index]['balance']}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )),
                          ],
                        ),
                      )),
                    ],
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future AddAccountDialog() {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "",
      titleStyle: TextStyle(fontSize: 0),
      onConfirm: () {
        controller.DataInsert(name: accountNameController.text).then((value) =>
            controller.GetData()
                .then((value) => tc.GetTotaldb())
                .then((value) => tc.InsertAmountData())
                .then((value) => tc.SelectQuery()));
        accountNameController.clear();
        Get.back();
      },
      textConfirm: "Add",
      confirmTextColor: Colors.white,
      onCancel: () {
        accountNameController.clear();
      },
      content: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            width: 300,
            color: Colors.purple,
            child: Text(
              "Add new account",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 280,
            child: TextField(
              controller: accountNameController,
              decoration: InputDecoration(
                label: Text("Enter Your Account Name"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future UpdateDialog(int index) {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        titleStyle: TextStyle(fontSize: 0),
        onConfirm: () {
          controller.UpdateData(
              updateName: '${accountNameController.text}',
              index: controller.DataList[index]['id']);
          accountNameController.clear();
          Get.back();
        },
        textConfirm: "SAVE",
        confirmTextColor: Colors.white,
        onCancel: () {
          accountNameController.clear();
        },
        content: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              color: Colors.purple,
              child: Text("Update account",
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              child: TextField(
                controller: accountNameController,
                decoration: InputDecoration(labelText: "Account name"),
              ),
            ),
          ],
        ));
  }
}

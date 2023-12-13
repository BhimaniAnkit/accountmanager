import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class advance_drawer extends StatefulWidget {
  const advance_drawer({Key? key}) : super(key: key);

  @override
  State<advance_drawer> createState() => _advance_drawerState();
}

class _advance_drawerState extends State<advance_drawer> {

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        backdrop: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)]),
          ),
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Advanced Drawer Example"),
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder(
                valueListenable: _advancedDrawerController,
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },),
            ),
          ),
          body: Container(),
        ),
        drawer: SafeArea(
            child: Container(
              child: ListTileTheme(
                textColor: Colors.white,
                iconColor: Colors.white,
                // horizontalTitleGap: 20,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      margin: EdgeInsets.only(top: 0.0,bottom: 0.0),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("pic/ic_notification.png"),
                    ),
                    ListTile(
                        title: Text("Home"),
                        leading: Icon(Icons.home,),
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
                      Spacer(),
                      // DefaultTextStyle(
                      //     style: TextStyle(fontSize: 12,color: Colors.white54),
                      //     child: Container(
                      //       margin: EdgeInsets.symmetric(vertical: 16.0),
                      //       child: Text("Terms Of Service | Privacy Policy"),
                      //     )
                      // ),
                    ],
                  ),
              ),
            )
        )
    );
  }
  void _handleMenuButtonPressed(){
    _advancedDrawerController.showDrawer();
  }
}

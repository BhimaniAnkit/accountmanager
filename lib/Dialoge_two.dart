import 'package:accountmanager/main.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class Dialoge_two extends StatefulWidget {
  const Dialoge_two({Key? key}) : super(key: key);

  @override
  State<Dialoge_two> createState() => _Dialoge_twoState();
}

class _Dialoge_twoState extends State<Dialoge_two> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      this.get();
    });

  }
  get()
  {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        print('Select currency: ${currency.name}');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return get();
        },));
        Navigator.pop(context);
      },
    );
  }


  //     showDialog(
//       context: context,
//       builder: (context) {
//         return AboutDialog(
//           children: [
//             Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 2, color: Colors.black),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(decoration: InputDecoration(hintText: "Set Password"),
//                   controller: pass,
//                 )),
//             Container(
//
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 2, color: Colors.black),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Text("Security Question 1")),
//
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.black)),
//
//             ),
//             Container(
//
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 2, color: Colors.black),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(decoration: InputDecoration(hintText: "Answer"),
//                   controller: pass,
//                 )),
//             Container(height: 50,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 2, color: Colors.black),
//                     borderRadius: BorderRadius.circular(10)),
//             child: Text("Security Question 2")),
//             Container(
//
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 2, color: Colors.black),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(decoration: InputDecoration(hintText: "Answer"),
//                   controller: pass,
//                 )),
//             Container(
//
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 2, color: Colors.black),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     TextButton(onPressed: () {
//
//                     }, child: Text("Exit")),
//                     TextButton(onPressed: () {
//                       m.switch_fun(1);
//
//                     }, child: Text("Set"))
//                   ],
//                 )),
//
//           ],
//         );
//       },
//     );
//   }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.yellow),
        child: ElevatedButton(onPressed: () {

          screenLock(
            context: context,
            correctString: '1234',
            canCancel: false,
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return first();
          },));
        }, child: Text("Login")),
      ),
    );;
  }
}
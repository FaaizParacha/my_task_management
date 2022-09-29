import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:my_task_management/constants/constant.dart';
import 'package:my_task_management/view/MyTasks.dart';
import 'package:my_task_management/view/myDuties.dart';
import 'package:my_task_management/view/myPayroll.dart';
import 'package:my_task_management/view/teamsAndTasks.dart';

import '../models/PunchedIn.dart';
import '../models/PunchedOut.dart';
import '../widgets/bottomappBar.dart';
import 'auth/log_in.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  String _lastSelected = 'TAB: 0';
int si=0;

   _selectedTab(int index) {
    setState(() {
      si=index;
      _lastSelected = 'TAB: $index';
    });

  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }
  Widget _buildFab(BuildContext context) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone ];
    return
      // AnchoredOverlay(
      // showOverlay: true,
      // overlayBuilder: (context, offset) {
      //   return CenterAbout(
      //     position: Offset(offset.dx, offset.dy - icons.length * 35.0),
      //     child: FabWithIcons(
      //       icons: icons,
      //       onIconTapped: _selectedFab,
      //     ),
      //   );
      // },
      // child:
      FloatingActionButton(
        onPressed: ()async{
          if(punchedIn.message=="You are successfully check in")
            {
               showAlertDialog(context);
            }
          else
            {
              await scanQR();
              //await punchIn();
              if(punchedIn.message=='You are successfully check in')
              {
                await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(punchedIn.message.toString()),
            ));
          }
        }
        },
        tooltip: 'Scan',
        elevation: 2.0,
        child: SvgPicture.asset('assets/scan.svg'),
      //),
    );
  }

  String _scanBarcode = 'success';


  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print('succesfully punchin to app');
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    await punchIn();
    setState(() {
      _scanBarcode = barcodeScanRes;

    });
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget punchOutButton = Container(
      height: 40,
      width: MediaQuery.of(context).size.width/3,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: appClr,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
          onPrimary: whiteTxtClr
        ),
          onPressed: () async{
            await punchout();
          if(punchedOut.status=='error')
          {
            await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(punchedOut.message.toString()),
            ));
          }
            // Navigator.of(context, rootNavigator: true)
            //     .pop(true);
           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                logIn()));
            await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(punchedOut.message.toString()),
            ));
          },
          child: Text('Punch-Out',style: TextStyle(
              color: whiteTxtClr
          ),)),
    );
    Widget cancelButton = Container(
      height: 40,
      width: MediaQuery.of(context).size.width/3,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: greyClrTxt,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              onPrimary: whiteTxtClr
          ),
          onPressed: (){
        Navigator.of(context, rootNavigator: true)
            .pop(false);
      },
          child: Text('Cancel',style: TextStyle(
              color: whiteTxtClr
          ),)),
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.only(left: 50,top: 20,bottom: 20),
      actionsPadding: EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 10),
      buttonPadding: EdgeInsets.only(left: 3,right: 10,top: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
      title: Center(child: Text("Punch-Out Confirmation",style: blk16boldtxtStyle,)),
      content: Text("Are you sure you want to punch-out?",style: grey13txtStyle,),
      actions: [
        cancelButton,
       punchOutButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  var punchedIn = PunchInModel();
  Future punchIn() async {
    return await http.post(Uri.parse('${baseUrl}attendance/checkin'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var punchInBody = json.decode ( response.body );
        punchedIn = PunchInModel.fromJson ( punchInBody );
        print('punchedIn message');
        print(punchedIn.message);
      })
    });
  }

  var punchedOut = PunchOutModel();
  Future punchout() async {
    return await http.post(Uri.parse('${baseUrl}attendance/checkout'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var punchoutBody = json.decode ( response.body );
        punchedOut = PunchOutModel.fromJson ( punchoutBody );
        print('punchedout message');
        print(punchedOut.message);
      })
    });
  }
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   punchIn().whenComplete(() =>  setState(() {}));
  //   punchout().whenComplete(() =>  setState(() {}));
  // }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        title:const  Text('Are you sure?'),
        content:const  Text('Do you want to exit the App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: const Text('No',style: TextStyle(color: appClr),),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
            child: const Text('Yes',style: TextStyle(color: appClr),),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          bottomNavigationBar: FABBottomAppBar(
            selectedindex: si,
            backgroundColor: whiteTxtClr,
            centerItemText:
            punchedIn.message=='You are successfully check in'?"Punch-Out":'Punch-In',
            color: Colors.grey,
            selectedColor: appClr,
            notchedShape:const CircularNotchedRectangle(),
            onTabSelected: _selectedTab,
            items: [
              FABBottomAppBarItem(iconData: 'assets/home.svg', text: 'Home',),
              FABBottomAppBarItem(iconData: 'assets/clipboardb.svg', text: 'My Tasks'),
              FABBottomAppBarItem(iconData: 'assets/calendarb.svg', text: 'my Duties'),
              FABBottomAppBarItem(iconData: 'assets/wallet.svg', text: 'My Payroll'),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFab(
              context),
        backgroundColor: backgrndClr,
          body: si==0?teamsandTasks():
          si==1?myTasks():
          si==2?myDuties():
          si==3?myPayroll():Container()
      ),
    );
  }
}



// class MyHome extends StatefulWidget {
//   @override
//   _MyHomeState createState() => _MyHomeState();
// }
//
// class _MyHomeState extends State<MyHome> {
//   int _selectedTab = 0;
//   final _pageOptions = [
//     Text('Item 1'),
//     Text('Item 2'),
//     Text('Item 3'),
//     Text('Item 4'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: Color(0xffFF5555),
//       ),
//       home: Scaffold(
//         body: _pageOptions[_selectedTab],
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: Icon(Icons.add),
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           elevation: 2.0,
//         ),
//         bottomNavigationBar: BottomAppBar(
//           notchMargin: 2.0,
//           shape: CircularNotchedRectangle(),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           child: SizedBox(
//             height: 80,
//             child: Theme(
//               data: Theme.of(context).copyWith(
//                 // sets the background color of the `BottomNavigationBar`
//                   canvasColor: Color(0xff1B213B),
//
//                   // sets the active color of the `BottomNavigationBar` if `Brightness` is light
//                   primaryColor: Color(0xffFF5555),
//                   textTheme: Theme.of(context)
//                       .textTheme
//                       .copyWith(caption: new TextStyle(color: Colors.white))),
//               child: BottomNavigationBar(
//                 type: BottomNavigationBarType.fixed,
//                 currentIndex: _selectedTab,
//                 onTap: (int index) {
//                   setState(() {
//                     _selectedTab = index;
//                   });
//                 },
//                 fixedColor: Color(0xffFF5555),
//                 items: [
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.tv), label: ''),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.card_membership), label: ''),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.share),label: ''),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.home), label: ''),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view/updatePassword.dart';
import '../view/updateProfile.dart';


final String baseUrl = 'https://shahees.com/api/';
final String BearerToken = '94|MgGaeUBANDp2K2xU06tPVCAtmDykXc1Ijg2eyGmc';
const Color appClr=  Color(0xff2E7CF9);
const Color whiteTxtClr=Color(0xffFFFFFF);
const Color blkTxtClr = Color(0xff000000);
const Color greyClrTxt = Color(0xffC4C4C4);
  Color txtfieldFilledclr = Color(0xff92A3FD).withOpacity(0.1);
 Color backgrndClr = Colors.grey.shade50;
 TextStyle apptitle = GoogleFonts.notoSans(
  color: whiteTxtClr,
   fontSize: 16,
   fontWeight: FontWeight.w500
);

TextStyle bigTitle = GoogleFonts.notoSans(
    color: whiteTxtClr,
    fontSize: 18,
    fontWeight: FontWeight.w700
);

TextStyle smallTitle = GoogleFonts.notoSans(
    color: whiteTxtClr,
    fontSize: 14,
    fontWeight: FontWeight.w300
);
TextStyle greytxtStyle = GoogleFonts.notoSans(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w300
);
TextStyle greytxtStyle14 = GoogleFonts.notoSans(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w600
);
TextStyle listtile_Title = GoogleFonts.notoSans(
    color: blkTxtClr,
    fontSize: 14,
    fontWeight: FontWeight.w500
);
TextStyle blk13txtStyle = GoogleFonts.notoSans(
    color: blkTxtClr,
    fontSize: 13,
    fontWeight: FontWeight.w400
);
TextStyle grey13txtStyle = GoogleFonts.notoSans(
    color: Colors.grey,
    fontSize: 13,
    fontWeight: FontWeight.w400
);
TextStyle blk16txtStyle = GoogleFonts.notoSans(
    color: blkTxtClr,
    fontSize: 16,
    fontWeight: FontWeight.w600
);
TextStyle blk16boldtxtStyle = GoogleFonts.notoSans(
    color: blkTxtClr,
    fontSize: 16,
    fontWeight: FontWeight.bold
);
TextStyle blk20txtStyle = GoogleFonts.notoSans(
    color: blkTxtClr,
    fontSize: 16,
    fontWeight: FontWeight.w600
);
TextStyle appclr16txtStyle = GoogleFonts.notoSans(
    color: appClr,
    fontSize: 16,
    fontWeight: FontWeight.w500
);

const SizedBox topPadding6 = SizedBox(height: 6,);
const SizedBox topPadding8 = SizedBox(height: 8,);
const SizedBox topPadding10 = SizedBox(height: 10,);
const SizedBox topPadding12 = SizedBox(height: 12,);
const SizedBox topPadding14 = SizedBox(height: 14,);
const SizedBox topPadding16 = SizedBox(height: 16,);
const SizedBox topPadding18 = SizedBox(height: 18,);
const SizedBox topPadding20 = SizedBox(height: 20,);

const SizedBox widthPadding6 = SizedBox(width: 6,);
const SizedBox widthPadding8 = SizedBox(width: 8,);
const SizedBox widthPadding10 = SizedBox(width: 10,);
const SizedBox widthPadding12 = SizedBox(width: 12,);
const SizedBox widthPadding14 = SizedBox(width: 14,);
const SizedBox widthPadding16 = SizedBox(width: 16,);
const SizedBox widthPadding18 = SizedBox(width: 18,);
const SizedBox widthPadding20 = SizedBox(width: 20,);
const SizedBox widthPadding50 = SizedBox(width: 50,);
RoundedRectangleBorder circular8 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8)
);
RoundedRectangleBorder circular10 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
);
 RoundedRectangleBorder circular12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12)
);
RoundedRectangleBorder circular14 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14)
);
RoundedRectangleBorder circular16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16)
);
RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
var prefs ;

class profileIcon extends StatefulWidget {
  const profileIcon({Key? key}) : super(key: key);

  @override
  State<profileIcon> createState() => _profileIconState();
}

class _profileIconState extends State<profileIcon> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding:
        const EdgeInsets.only(right: 5.0, top: 10, left: 8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              //color: Color(0xff2E7CF9).withOpacity(0.6),
              borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon:const Icon(Icons.person_outline),
            tooltip: 'profile Icon',
            onPressed: () {
              final action = CupertinoActionSheet(
                message:const Text(
                  "Choose your Selection",
                  style: TextStyle(fontSize: 18),
                ),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>const updateProfile()));
                    },
                    child:const Text("Update Profile"),
                  ),
                  CupertinoActionSheetAction(

                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>const updatePassword()));
                    },
                    child:const Text("Update Password"),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  child:const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
              showCupertinoModalPopup(
                  context: context, builder: (context) => action);
            },
          ),
        ));
  }
}

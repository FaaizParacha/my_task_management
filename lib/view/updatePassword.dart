import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../constants/constant.dart';
import '../models/UpdatePassModel.dart';

class updatePassword extends StatefulWidget {
  const updatePassword({Key? key}) : super(key: key);

  @override
  State<updatePassword> createState() => _updatePasswordState();
}

class _updatePasswordState extends State<updatePassword> {
  var newPassController = TextEditingController();
  var confrimPassController = TextEditingController();
  var updatePass = UpdatePasswordModel();
  GlobalKey<FormState> _formKey =  GlobalKey<FormState>();
  Future updatePasswordPost(updatePass) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${BearerToken}'
    };
    var UpdateProfilePostObject = updatePass.toJson();
    var userBody = json.encode(UpdateProfilePostObject);

    var res = await http.post(
      Uri.parse (
          '${baseUrl}user/change-password' ),
      headers: header, body: userBody,);
    print('status code');
    print(res.statusCode);
    print(res.body);
    return res.statusCode;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTxtClr,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0,top: 10,left: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: IconButton(
                    icon: Icon(Icons.person_outline),
                    tooltip: 'profile Icon',
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            leading:  Padding(
              padding:  EdgeInsets.only(top: 10,left: 8),
              child: Container(
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: IconButton(
                  icon: Icon(Icons.menu),
                  tooltip: 'Setting Icon',
                  onPressed: () {},
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset('assets/Frame.png'))
            ),
            centerTitle: true,
            backgroundColor: appClr,
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text('Update Password',style: apptitle,),
            ) ,
          )
      ),
      body:
      updatePass==null||updatePass==''?
      Container(
          height: double.infinity,
          width: double.infinity,
          color: whiteTxtClr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Container(child: Text('Loading... Please wait',style: TextStyle(
                  color: whiteTxtClr
              ),),),
              const CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: appClr,
              )
            ],
          )
      ):
      Stack(
        children: [
         Form(
           key: _formKey,
           child:  ListView(
             padding:const EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 10),
             children: [
               Text('Change Password',style: blk16txtStyle,),
               topPadding18,
               Text('New Password',style: blk13txtStyle,),
               topPadding6,
               TextFormField(
                   validator: ( value){
                     if(value!.isEmpty)
                     {
                       return 'Please enter password';
                     }
                     if(newPassController.text!=confrimPassController.text){
                       return "Password does not match";
                     }
                     if(value.length<3){
                       return 'The password must be at least 4 characters.';
                     }
                     return null;
                   },
                   controller: newPassController,
                   decoration: InputDecoration(
                       suffixIcon: IconButton(onPressed: (){},
                           icon: SvgPicture.asset('assets/Lock.svg')),
                       hintText: 'Enter New Password',
                       border: OutlineInputBorder(
                         borderSide:const BorderSide(
                           width: 0,
                           style: BorderStyle.none,
                         ),
                         borderRadius: BorderRadius.circular(14.0),
                       ),
                       fillColor: txtfieldFilledclr,
                       filled: true
                   )
               ),
               topPadding8,
               Text('Confirm Password',style: blk13txtStyle,),
               topPadding6,
               TextFormField(
                   validator: ( value){
                     if(value!.isEmpty)
                     {
                       return 'Please re-enter password';
                     }
                     if(newPassController.text!=confrimPassController.text){
                       return "Password does not match";
                     }
                     return null;
                   },
                 controller: confrimPassController,
                   decoration: InputDecoration(
                       suffixIcon: IconButton(onPressed: (){},
                           icon: SvgPicture.asset('assets/Lock.svg')),
                       border: OutlineInputBorder(
                         borderSide:const BorderSide(
                           width: 0,
                           style: BorderStyle.none,
                         ),
                         borderRadius: BorderRadius.circular(14.0),
                       ),
                       hintText: 'Confirm your new password',
                       fillColor: txtfieldFilledclr,
                       filled: true
                   )
               ),
             ],
           ),
         ),

          Positioned(
            bottom: 5,
            child: Container(
              padding: EdgeInsets.only(left: 7,right: 7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/16,
              child: ElevatedButton(
                onPressed: () async{
                  UpdatePasswordModel updatePassobj;
                  updatePassobj=UpdatePasswordModel(
                    password: newPassController.text
                  );
                  final isValid = _formKey.currentState!.validate();
                  if(isValid)
                    {
                      updatePasswordPost(updatePassobj);
                      ScaffoldMessenger.of(context)
                          .showSnackBar( const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content:Text("Password updated successfully"),));
                    }
                  else{
                    ScaffoldMessenger.of(context)
                        .showSnackBar( const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content:Text("Please fill form correctly"),));
                  }

                },
                style: ElevatedButton.styleFrom(
                    primary: appClr, // background
                    onPrimary: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14))
                    )// foreground
                ),
                child: const Text("Update Password"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

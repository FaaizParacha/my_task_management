import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_task_management/constants/constant.dart';
import 'package:my_task_management/models/LoginModel.dart';
import 'package:my_task_management/models/UpdatePassModel.dart';
import 'package:my_task_management/view/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/update-Profile.dart';



class logIn extends StatefulWidget {
  const logIn({Key? key}) : super(key: key);

  @override
  State<logIn> createState() => _logInState();
}

class _logInState extends State<logIn> {
  bool _isChecked=false;
  final _form = GlobalKey<FormState>();
  bool? _passwordVisible = true;
  int textLength = 0;

  var PassController = TextEditingController();
  var emailController = TextEditingController();
  var logInPostModelObj = LoginModel();
  Future logInPost(logInObj) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${BearerToken}'
    };
    var loginOBJToJson = logInObj.toJson();
    var userBody = json.encode(loginOBJToJson);
    var res = await http.post(
      Uri.parse (
          '${baseUrl}login' ),
      headers: header, body: userBody,);
    var jsonResponse = json.decode(res.body);
    logInPostModelObj =  LoginModel.fromJson(jsonResponse);
    print('status code');
    print(res.statusCode);
    print(res.body);
    return res.statusCode;
  }


  _onChanged(bool? value) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = value!;
      prefs.setBool("check", _isChecked);
      prefs.setString("username", emailController.text);
      prefs.setString("password", PassController.text);
      prefs.commit();
      getCredential();
    });
  }

  getCredential() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = prefs.getBool("check");
      if (_isChecked != null) {
        if (_isChecked) {
          emailController.text = prefs.getString("email");
          PassController.text = prefs.getString("password");
        } else {
          //userNameController.clear();
          PassController.clear();
          prefs.clear();
        }
      } else {
        _isChecked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:whiteTxtClr,
      body:
      // logInPostModelObj==null||logInPostModelObj==''?
      // Container(
      //     height: double.infinity,
      //     width: double.infinity,
      //     color: whiteTxtClr,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Container(),
      //         Container(child: Text('Loading... Please wait',style: TextStyle(
      //             color: whiteTxtClr
      //         ),),),
      //         const CircularProgressIndicator(
      //           backgroundColor: Colors.grey,
      //           color: appClr,
      //         )
      //       ],
      //     )
      // ):
      Form(
          key: _form,
          child: ListView(
        padding:const EdgeInsets.all(15),
        children:  [
         const SizedBox(
            height: 30,
          ),
          // const Text('Place Holder',style: TextStyle(
          //     color: appClr,
          //     fontSize: 25,
          //     fontFamily: 'EncodeSans',
          //     fontWeight: FontWeight.w700
          // ),),
           SizedBox(
            height: MediaQuery.of(context).size.height/6,
          ),
          const Text('Login',style: TextStyle(
              color: appClr,
              fontSize: 25,
              fontFamily: 'EncodeSans',
              fontWeight: FontWeight.w700
          ),),
          topPadding14,
          Card(
            elevation: 5,
            shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(15))
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (text) {
                      if ( text!.isEmpty) {
                        return "Enter valid email";
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(text)){
                        return 'Please enter a valid Email';
                      }
                    },
                    onChanged: (text){
                      setState(() {
                        textLength = text.length;
                      });
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(textLength > 7
                            ? Icons.check
                            : Icons.cancel, color: textLength > 7
                            ? Colors.green : Colors.red),
                        focusedBorder:const UnderlineInputBorder(
                          borderSide:  BorderSide(color: appClr,
                              width: 2.0),
                        ),
                        labelText: 'Email',
                       // labelStyle: labelTextStyle
                    ),
                  ),
                  topPadding8,
                  TextFormField(
                    controller: PassController,
                    validator: (text) {
                      if (!(text!.length > 4) && text.isEmpty) {
                        return "Enter password of length 4 characters!";
                      }
                    },
                    obscureText: _passwordVisible!,
                    decoration: InputDecoration(
                        suffixIconColor:appClr,
                        suffixIcon: IconButton (
                          color:appClr,
                          icon: Icon ( _passwordVisible!
                              ? MdiIcons.eyeOffOutline
                              : MdiIcons.eyeOutline ),
                          onPressed: () {
                            setState ( () {
                              _passwordVisible =
                              !_passwordVisible!;
                            } );
                          },
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(color: appClr, width: 2.0),
                        ),
                        labelText: 'Password',
                        //labelStyle: labelTextStyle
                    ),
                  ),

                  topPadding8,
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    checkboxShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5))
                    ),
                    activeColor: appClr,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _isChecked,
                    onChanged: _onChanged,
                    title:const Text('Keep me logged in',
                      style: TextStyle(
                          fontFamily: 'EncodeSans',
                          color: blkTxtClr,
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),topPadding8,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/14,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: appClr,
                          onPrimary: whiteTxtClr,
                          shape:const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24))
                          )
                      ),
                      onPressed:  ()async{
                        LoginModel LoginModelObj;
                        LoginModelObj = LoginModel(
                            email: emailController.text,
                            password: PassController.text
                        );
                        final isValid = _form.currentState!.validate();
                        if (isValid) {
                          await logInPost(LoginModelObj);
                          if (logInPostModelObj.status == 'success') {
                           await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const home()));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login successfully"),
                                ));
                          }
                          else {
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("Invalid Credentials"),));
                          }
                        }
                        else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text("Invalid Credentials"),));
                        }
                        //if(logInPostModelObj.status=='success'){
                        //   Navigator.of(context).push(
                        //       MaterialPageRoute(builder: (context)=>const home()));
                        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //     behavior: SnackBarBehavior.floating,
                        //     content: Text("Login successfully"),
                        //   ));
                        // }
                        //  else{
                        //    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //      behavior: SnackBarBehavior.floating,
                        //      content: Text("Invalid Credentials"),
                        //    ));
                        //  }
                      },
                      child:const Text('Login'),
                    ),
                  ),
                  topPadding8,
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: InkWell(
                  //     onTap: (){
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>const forgotPassword()));
                  //     },
                  //     child:const Text('Forgot Password?',style: TextStyle(
                  //         color: blkTxtClr,
                  //         fontSize: 15
                  //     ),),
                  //   ),
                  // ),

                ],),
            ),
          ),
          // const SizedBox(
          //   height: 50,
          // ),
          // Row(
          //     children: const[
          //       Expanded(
          //           child: Divider()
          //       ),
          //
          //       Text('or continue with',style: TextStyle(
          //           color: blkTxtClr,
          //           fontFamily: 'EncodeSans',
          //           fontSize: 15
          //       ),),
          //
          //       Expanded(
          //           child: Divider()
          //       ),
          //     ]
          // ),
          // topPadding10,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SvgPicture.asset(
          //       'assets/google.svg',),
          //     SvgPicture.asset(
          //       'assets/fb.svg',),
          //     widthPadding12,
          //     SvgPicture.asset(
          //       'assets/Apple.svg',),
          //   ],),
          // topPadding14,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text('Already have an account?',style: TextStyle(
          //         color: blkTxtClr,
          //         fontSize: 15
          //     ),),
          //     InkWell(
          //         onTap: (){
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) =>const signUp()));
          //         },
          //         child:const Text('Sign Up',
          //           style: TextStyle(
          //               color: appClr,
          //               fontSize: 15
          //           ),))
          //   ],)
        ],))
    );
  }
}

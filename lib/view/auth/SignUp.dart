import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_task_management/constants/constant.dart';

import 'log_in.dart';



class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _form = GlobalKey<FormState>();
  bool _isChecked=false;
  bool _isChecked1=false;
  bool? _passwordVisible = false;
  int textLengthofuserName = 0;
  int textLengthofemail = 0;
  int textLengthofphone = 0;
  String? _chosenValue;
  void signUpButtonNavigation(){
     final isValid = _form.currentState!.validate();
   if(isValid){
     ScaffoldMessenger.of(context)
         .showSnackBar(const  SnackBar(
       content: Text("Account created successfully"),));
     Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) =>const logIn()));
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:whiteTxtClr,
        body: Form(
          key: _form,
            child: ListView(
              padding:const EdgeInsets.all(15),
              children:  [
                const SizedBox(
                  height: 70,
                ),
                const Text('Registration',style: TextStyle(
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
                        TextFormField(
                          onChanged: (text){
                            setState(() {
                              textLengthofuserName = text.length;
                            });
                          },
                          validator: (text) {
                            if (!(text!.length > 5) && text.isEmpty) {
                              return "Enter User name of more then 5 characters!";
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(textLengthofuserName > 5 ? Icons.check
                                  : Icons.cancel, color: textLengthofuserName > 5
                                  ? Colors.green : Colors.red),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:  BorderSide(color: appClr,
                                    width: 2.0),
                              ),
                              labelText: 'User Name',
                              //labelStyle: labelTextStyle
                          ),
                        ),topPadding8,
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text){
                            setState(() {
                              textLengthofemail = text.length;
                            });
                          },
                          validator: (value){
                            if(value!.isEmpty&& value.length>5)
                            {
                              return 'Please Enter your proper email';
                            }
                            if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                              return 'Please enter a valid Email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(textLengthofemail > 5
                                  ? Icons.check
                                  : Icons.cancel, color: textLengthofemail > 5
                                  ? Colors.green : Colors.red),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:  BorderSide(color: appClr,
                                    width: 2.0),
                              ),
                              labelText: 'Email',
                              //labelStyle: labelTextStyle
                          ),
                        ),topPadding8,
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (text) {
                            if (!(text!.length > 5) && text.isEmpty) {
                              return "Enter phone no of more then 5 characters!";
                            }
                          },
                          onChanged: (text){
                            setState(() {
                              textLengthofphone = text.length;
                            });
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(textLengthofphone > 5 ? Icons.check
                                  : Icons.cancel, color: textLengthofphone > 5
                                  ? Colors.green : Colors.red),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:  BorderSide(color: appClr,
                                    width: 2.0),
                              ),
                              labelText: 'Phone Number (Optional)',
                              //labelStyle: labelTextStyle
                          ),
                        ),
                        topPadding8,
                        TextFormField(
                          validator: (text) {
                            if (!(text!.length > 5) && text.isEmpty) {
                              return "Enter password of more then 5 characters!";
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
                        DropdownButton<String>(
                          underline: Text(''),
                          icon: Icon(CupertinoIcons.chevron_down,color: appClr,),
                          isExpanded: true,
                          focusColor:Colors.white,
                          value: _chosenValue,
                          //elevation: 5,
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor:Colors.black,
                          items: <String>[
                            'Android',
                            'IOS',
                            'Flutter',
                            'Node',
                            'Java',
                            'Python',
                            'PHP',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint:const Text(
                            "Select Category",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),

                          onChanged: (String? value) {
                            setState(() {
                              _chosenValue = value;
                            });
                          },
                        ),
                        CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            checkboxShape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))
                            ),
                            activeColor: appClr,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _isChecked,
                            onChanged: (value){
                              setState(() {
                                _isChecked=value ??false;
                              });
                            },
                            title:Row(
                              children: const[
                                Text('I agree with ',
                                  style: TextStyle(
                                      fontFamily: 'EncodeSans',
                                      color: blkTxtClr,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                InkWell(
                                  child: Text('The Terms & The Conditions',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'EncodeSans',
                                        color: appClr,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                )
                              ],)
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          checkboxShape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5))
                          ),
                          activeColor: appClr,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _isChecked1,
                          onChanged: (value){
                            setState(() {
                              _isChecked1=value!;
                            });
                          },
                          title:const Text('I do not want to receive newsletter',
                            style: TextStyle(
                                fontFamily: 'EncodeSans',
                                color: blkTxtClr,
                                fontSize: 15,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
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
                            onPressed:
                              _isChecked ?
                              signUpButtonNavigation
                                  :null,
                            child:const Text('Signup'),
                          ),
                        ),
                        topPadding8,

                      ],),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                    children: const[
                      Expanded(
                          child: Divider()
                      ),

                      Text('or continue with',style: TextStyle(
                          color: blkTxtClr,
                          fontFamily: 'EncodeSans',
                          fontSize: 15
                      ),),

                      Expanded(
                          child: Divider()
                      ),
                    ]
                ),
                topPadding10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/google.svg',),
                    SvgPicture.asset(
                      'assets/fb.svg',),
                    widthPadding12,
                    SvgPicture.asset(
                      'assets/Apple.svg',),
                  ],),
                topPadding14,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',style: TextStyle(
                        color: blkTxtClr,
                        fontSize: 15
                    ),),
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>const logIn()));
                        },
                        child:const Text('Sign In',
                          style: TextStyle(
                              color: appClr,
                              fontSize: 15
                          ),))
                  ],),

              ],))
    );
  }
}

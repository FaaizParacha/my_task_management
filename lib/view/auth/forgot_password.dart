import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import 'SignUp.dart';



class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  bool _isChecked=false;
  bool? _passwordVisible = false;
  int textLength = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:whiteTxtClr,
        body: ListView(
          padding:const EdgeInsets.all(15),
          children:  [
            const SizedBox(
              height: 70,
            ),
            const Text('Recover Password',style: TextStyle(
                color: appClr,
                fontSize: 25,
                fontFamily: 'EncodeSans',
                fontWeight: FontWeight.w700
            ),),
            const SizedBox(
              height: 70,
            ),
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
                    const Text('Enter You Email to recover password',style: TextStyle(
                        color: blkTxtClr,
                        fontFamily: 'EncodeSans',

                    ),),
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Please Enter your email';
                        }
                        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          suffixIcon: Icon(textLength > 5
                              ? Icons.check
                              : Icons.cancel, color: textLength > 5
                              ? Colors.green : Colors.red),
                          focusedBorder:const UnderlineInputBorder(
                            borderSide:  BorderSide(color: appClr,
                                width: 2.0),
                          ),
                          labelText: 'Email',
                          //labelStyle: labelTextStyle
                      ),
                    ),
                    topPadding14, topPadding14,
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
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>const signUp()));
                        },
                        child:const Text('Recover'),
                      ),
                    ),
                    topPadding14,
                  ],),
              ),
            ),
          ],)
    );
  }
}

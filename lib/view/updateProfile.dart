import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../models/update-Profile.dart';

class updateProfile extends StatefulWidget {
  const updateProfile({Key? key}) : super(key: key);

  @override
  State<updateProfile> createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  TextEditingController first_name= TextEditingController();
  TextEditingController last_name= TextEditingController();
  TextEditingController phone= TextEditingController();
  UpdateProfile UpdateProfilePost=UpdateProfile(user: User());
  GlobalKey<FormState> _formKey =  GlobalKey<FormState>();
  Future updateProfilePost(firstName,lastName,phoneNumber) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${BearerToken}'
    };
    var UpdateProfilePostObject = UpdateProfilePost.toJson();
    var userBody = json.encode(UpdateProfilePostObject);

    var res = await http.post(
      Uri.parse (
          '${baseUrl}user/change-profile?first_name=$firstName&last_name=$lastName&phone=$phoneNumber' ),
      headers: header, body: userBody,);
    print('status code');
    print(res.statusCode);
    return res.statusCode;
  }
  _getprofile() async{
    return await http.post(Uri.parse('${baseUrl}user/profile'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var jsonResponse = json.decode(response.body);
        UpdateProfilePost =  UpdateProfile.fromJson(jsonResponse);

        if(UpdateProfilePost!=null){
          first_name.text = UpdateProfilePost.user.first_name.toString ();
          last_name.text= UpdateProfilePost.user.last_name.toString ();
          phone.text=UpdateProfilePost.profile!.phone.toString();

        }
      })
    });
  }


  @override
  void initState() {
    super.initState();
    updateProfilePost(first_name.text,last_name.text,phone.text).whenComplete(() =>  setState(() {}));
    _getprofile().whenComplete(() =>  setState(() {}));
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
              child: Text('Update Profile',style: apptitle,),
            ) ,
          )
      ),
      body:
      UpdateProfilePost==null||UpdateProfilePost==''
          ||
        UpdateProfilePost.user==null||UpdateProfilePost.profile==null?
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
      )
          :
      Stack(
        children: [
          ListView(
            padding:const EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 10),
            children: [
              Text('James',style: blk16txtStyle,),
              topPadding18,
              Text('First Name',style: blk13txtStyle,),
              topPadding6,
              TextFormField(
                controller: first_name,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed: (){},
                          icon: Icon(Icons.person_outline,color: appClr,)),
                      hintText: 'First Name',
                      border: OutlineInputBorder(
                        borderSide:const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      labelText: UpdateProfilePost.user.first_name.toString(),
                      fillColor: txtfieldFilledclr,
                      filled: true
                  )
              ),
              topPadding8,
              Text('Last Name',style: blk13txtStyle,),
              topPadding6,
              TextFormField(
                controller: last_name,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed: (){},
                          icon: Icon(Icons.person_outline,color: appClr,)),
                      border: OutlineInputBorder(
                        borderSide:const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      labelText: UpdateProfilePost.user.last_name.toString(),
                      hintText: 'Last Name',
                      fillColor: txtfieldFilledclr,
                      filled: true
                  )
              ),
              topPadding8,
              Text('Phone Number',style: blk13txtStyle,),
              topPadding6,
              TextFormField(
                controller: phone,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed: (){},
                          icon: Icon(Icons.phone_outlined,color: appClr,)),
                      border: OutlineInputBorder(
                        borderSide:const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      labelText: UpdateProfilePost.profile!.phone.toString(),
                      hintText: '+971-12345678',
                      fillColor: txtfieldFilledclr,
                      filled: true
                  )
              ),
            ],
          ),

          Positioned(
            bottom: 5,
            child: Container(
              padding: EdgeInsets.only(left: 7,right: 7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/16,
              child: ElevatedButton(
                onPressed: () async{
                  updateProfilePost(first_name.text,last_name.text,phone.text).whenComplete(() =>  setState(() {}));

                      ScaffoldMessenger.of(context)
                          .showSnackBar( SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content:Text("Profile updated Successfully")));
                  },
                style: ElevatedButton.styleFrom(
                    primary: appClr, // background
                    onPrimary: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14))
                    )// foreground
                ),
                child: const Text("Update Profile"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

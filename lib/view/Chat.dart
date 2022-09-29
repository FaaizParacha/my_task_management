import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants/constant.dart';

class chatting extends StatefulWidget {
  const chatting({Key? key}) : super(key: key);

  @override
  State<chatting> createState() => _chattingState();
}

class _chattingState extends State<chatting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child:  AppBar(
          title: Text('Chats',style: apptitle,) ,
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset('assets/Frame.png'))
          ), //FlexibleSpaceBar
          backgroundColor: appClr,
          leading:  Padding(
            padding: const EdgeInsets.only(top: 10,left: 8),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  //color: Color(0xff2E7CF9).withOpacity(0.96),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: IconButton(
                icon: Icon(Icons.menu),
                tooltip: 'Setting Icon',
                onPressed: () {},
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0,top: 10,left: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    //color: Color(0xff2E7CF9).withOpacity(0.6),
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed: (){},
                          icon: Icon(Icons.search,color: appClr,)),
                      border: OutlineInputBorder(
                        borderSide:const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      hintText: 'Search Chat',
                      fillColor: whiteTxtClr,
                      filled: true
                  )
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context,index)
      {
        return Card(
          elevation: 0,
          color: whiteTxtClr,
          child: ListTile(
              leading: Image.asset(
                'assets/person.png',
              ),
              title: Text('Name',style: listtile_Title,),
              subtitle: Text('Position',style: greytxtStyle,)
          ),
        );
      }
      ),
    );
  }
}

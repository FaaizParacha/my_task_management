import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_task_management/constants/constant.dart';
import 'package:http/http.dart' as http;

import '../models/Details/AnnouncementDetailModel.dart';
class announcementDetail extends StatefulWidget {
  final int? id;
  const announcementDetail({Key? key, this.id}) : super(key: key);

  @override
  State<announcementDetail> createState() => _announcementDetailState();
}

class _announcementDetailState extends State<announcementDetail> {
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

  var announcementsDetailList = AnnouncementsDetailModel(task: AnnouncementsDetailModelTask());

  Future loadAnnouncementsDetail() async {
    return await http.post(Uri.parse('${baseUrl}task/viewdetail?id=${widget.id}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var jsonResponse = json.decode(response.body);
        announcementsDetailList =  AnnouncementsDetailModel.fromJson(jsonResponse);
      })
    });
  }
  @override
  void initState() {
    super.initState();
    loadAnnouncementsDetail().whenComplete(() =>  setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTxtClr,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            leading:  Padding(
              padding:  EdgeInsets.only(top: 10,left: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: IconButton(
                    icon:const Icon(CupertinoIcons.chevron_back,color: whiteTxtClr,),
                    tooltip: 'back Icon',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
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
              child: Text('Announcements',style: apptitle,),
            ) ,
          )
      ),
      body:
      announcementsDetailList==null
          ||announcementsDetailList.task.title==null||widget.id==null
          ||announcementsDetailList.task.user==null||announcementsDetailList.task.accepted==null
          ?
      Container(
          height: double.infinity,
          width: double.infinity,
          color: whiteTxtClr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Container(child:const Text('Loading... Please wait',style: TextStyle(
                  color: appClr
              ),),),
              const CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: appClr,
              )
            ],
          )
      )
          :
      ListView(
        padding:const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
        children: [
          Text(announcementsDetailList.task.title.toString(),style: blk16txtStyle),
          topPadding6,
          Row(
            children: [
             const Icon(Icons.person_outline,size: 15,),
              widthPadding6,
              Text(announcementsDetailList.task.user.toString(),style: blk13txtStyle),
              widthPadding20,  widthPadding20,
              SvgPicture.asset('assets/calendar.svg',
                color: Colors.grey,
                height: 15,
              ),
              widthPadding6,
              Text(announcementsDetailList.task.accepted!.substring(0,10).toString()),
            ],
          ),
          topPadding8,
          Text(
      announcementsDetailList.task.post==null?'':
            announcementsDetailList.task.post!.replaceAll(exp, '').replaceAll('&nbsp', ''),style: grey13txtStyle,),
          topPadding8,

          //hardcoded
          BulletedList(
            style: blk13txtStyle,
            bulletColor: blkTxtClr,
            listItems:const[
              'The photos on your local cloud are viewable when you are on the local network.',
              'You can view your media pretty much everywhere - just upgrade to AcmePhoto\'s Cloud service',
              'You can also choose to use your own Amazon AWS or Google Cloud accounts'
            ],
            listOrder: ListOrder.ordered,
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_task_management/constants/constant.dart';
import 'package:http/http.dart' as http;

import '../models/Details/NewsDetailsModel.dart';


class newsDetail extends StatefulWidget {
  final int id;
  const newsDetail({Key? key,required this.id}) : super(key: key);


  @override
  State<newsDetail> createState() => _newsDetailState();
}

class _newsDetailState extends State<newsDetail> {
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  //final String? text = loremIpsum(words: 120, paragraphs: 2, initWithLorem: true);

  var newsDetailList = NewsDetailModel(task: newsTask());

  Future loadNewsDetail() async {
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
        newsDetailList =  NewsDetailModel.fromJson(jsonResponse);
      })
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadNewsDetail().whenComplete(() => setState(() {}));
    super.initState();
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
                    icon: Icon(CupertinoIcons.chevron_back,color: whiteTxtClr,),
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
              child: Text('News',style: apptitle,),
            ) ,
          )
      ),
      body:
      newsDetailList==null
          ||newsDetailList.task.title==null||widget.id==null
          ||newsDetailList.task.post==null
          ||newsDetailList.task.user==null||newsDetailList.task.accepted==null?
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
        padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
        children: [
          Text(newsDetailList.task.title.toString(),style: blk16txtStyle),
          topPadding6,
          Row(
            children: [
              Icon(Icons.person_outline,size: 15,),
              widthPadding6,
              Text(newsDetailList.task.user.toString(),style: blk13txtStyle),
              widthPadding20,  widthPadding20,
              SvgPicture.asset('assets/calendar.svg',
                color: Colors.grey,
                height: 15,
              ),
              widthPadding6,
              Text(newsDetailList.task.accepted!.substring(0,10).toString()),
            ],
          ),
          topPadding8,
          Text(newsDetailList.task.post!.replaceAll(exp, '').replaceAll('&nbsp;', ' '),style: grey13txtStyle,),
          topPadding8,
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

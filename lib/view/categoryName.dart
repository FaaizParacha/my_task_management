import 'dart:convert';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_task_management/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:my_task_management/models/Details/learning-management-categories-detail.dart';
class categoryName extends StatefulWidget {
  final int id;
  const categoryName({Key? key,required this.id}) : super(key: key);

  @override
  State<categoryName> createState() => _categoryNameState();
}

class _categoryNameState extends State<categoryName> {
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  //final String? text = loremIpsum(words: 120, paragraphs: 2, initWithLorem: true);

 var learningManagementList = LearningManagementDetailModel(task: categoryTask());
  //var learningManagementList1 = LearningManagementDetailModel();
  //Map<String, dynamic> task={};
  Future loadLearningManagementDetail() async {
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
        learningManagementList =  LearningManagementDetailModel.fromJson(jsonResponse);
        // print('learningManagementList body');
        // print(response.body);
        // print("faaiz  ${response.statusCode}");
        // print(response.body);

        // learningManagementList1 =
        // jsonResponse['forms']= LearningManagementDetailModel.fromJson ( jsonResponse ) ;
        // Map<String, dynamic> map = json.decode(response.body);
        // task = map['task'];
        // print('learningManagementList----1 body');
        // print(response.body);
      })
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    loadLearningManagementDetail().whenComplete(() => setState(() {}));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final document = parse(
    //     learningManagementList.task.post);
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
                    tooltip: 'Setting Icon',
                    onPressed: () {
                      Navigator.of(context).pop();
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
              child: Text('Category Name',style: apptitle,),
            ) ,
          )
      ),
      body:
      learningManagementList==null
          ||learningManagementList.task.title==null||widget.id==null
      ||learningManagementList.task.post==null
      ||learningManagementList.task.user==null||learningManagementList.task.accepted==null
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
        padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
        children: [
          Text(learningManagementList.task.title.toString(),style: blk16txtStyle),
          topPadding6,
          Row(
            children: [
             const Icon(Icons.person_outline,size: 15,),
              widthPadding6,
              Text(learningManagementList.task.user.toString(),style: blk13txtStyle),
              widthPadding20,  widthPadding20,
              SvgPicture.asset('assets/calendar.svg',
                color: Colors.grey,
                height: 15,
              ),
              widthPadding6,
              Text(learningManagementList.task.accepted!.substring(0,10).toString()),
            ],
          ),
          topPadding8,
          Text(learningManagementList.task.post!.replaceAll(exp, ''),style: grey13txtStyle,),
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

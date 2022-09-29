import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_task_management/view/categoryName.dart';
import 'package:readmore/readmore.dart';

import '../constants/constant.dart';


class learningManagementCard extends StatefulWidget {
  final String imageUrl,message,description,date;
  final int id;
  const learningManagementCard({required this.imageUrl,required this.id,
    required this.message,required this.date,required this.description,
    Key? key}) : super(key: key);

  @override
  State<learningManagementCard> createState() => _learningManagementCardState();
}

class _learningManagementCardState extends State<learningManagementCard> {
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>categoryName(id: widget.id,)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height:  MediaQuery.of(context).size.height/8.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(22),topRight: Radius.circular(22)),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                          widget.imageUrl
                        )
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10),
              child: Row(
                children: [
                  Text(widget.message,style: blk13txtStyle,),
                  widthPadding10,
                  Icon(Icons.circle,color: appClr,size: 8,),
                  widthPadding10,
                  Text(widget.date,style: blk13txtStyle,)
                ],),
            ),
             Padding(
              padding:  EdgeInsets.only(left:15.0,right: 15,top: 10,bottom: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: ReadMoreText(
                  widget.description,
                  trimLines: 2,
                  style: TextStyle(color: blkTxtClr),
                  colorClickableText: appClr,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Read more',
                  trimExpandedText: ' Less',
                ),
              ),
            )
          ],
        )
    );
  }
}
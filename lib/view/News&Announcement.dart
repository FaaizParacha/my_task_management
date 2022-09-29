import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_task_management/view/announcementDetail.dart';
import 'package:http/http.dart' as http;
import 'package:my_task_management/view/newsDetails.dart';
import '../constants/constant.dart';

class announcements extends StatefulWidget {
  const announcements({Key? key}) : super(key: key);

  @override
  State<announcements> createState() => _announcementsState();
}

class _announcementsState extends State<announcements> {
  final String name = 'James';
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  // List<Color> leadingcolorsNews = const[Color(0xffA02EF9), Color(0xff00BDB2),Color(0xffE73700),];
  // List<Color> leadingContainerNews = [Colors.purple.shade50, Colors.green.shade50,Colors.red.shade50,];
  //
  //  List<Color> leadingcolorsAnnouncements = const[Color(0xff00BDB2), Color(0xffE700C2),Color(0xffE7DE00)];
  //  List<Color> leadingContainerAnnouncements= [Colors.green.shade50,Colors.purple.shade50,
  //    Colors.yellow.shade50];

  List newsList=[];
  List announcementList=[];
  Future loadNews() async {
    return await http.post(Uri.parse('${baseUrl}news'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var convertDataToJson= json.decode(response.body);
        newsList =convertDataToJson['list'];
      })
    });
  }

  Future loadAnnouncement() async {
    return await http.post(Uri.parse('${baseUrl}announcement'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var convertDataToJson= json.decode(response.body);
        announcementList =convertDataToJson['list'];
      })
    });
  }

  @override
  void initState() {
    super.initState();
    loadNews().whenComplete(() =>  setState(() {}));
    loadAnnouncement().whenComplete(() =>  setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            actions: <Widget>[
              profileIcon()
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
              child: Text('News/Announcements',style: apptitle,),
            ) ,
          )
      ),
      body:
      newsList.isEmpty||announcementList.isEmpty?
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
      ):
      ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
              primary: false,
              itemCount: newsList.length,
              itemBuilder: (context,index)
              {
                var document = parse(
                    newsList[index]['description']);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topPadding8,index==0?topPadding8:Container(),
                    index==0?
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15),
                      child: Text('News',style: blk16txtStyle),
                    ):Container(),
                    index==0?topPadding8:Container(),
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15,top: 5),
                      child: Card(
                        margin: EdgeInsets.only(right: 2),
                        elevation: 0.3,
                        shape: circular16,
                        color: whiteTxtClr,
                        child: ListTile(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context)=> newsDetail(
                                      id: newsList[index]['id']
                                    )));
                          },
                            trailing: IconButton(
                              onPressed: (){

                              },
                              icon: Icon(CupertinoIcons.chevron_right,color: appClr,),
                            ),
                            leading: Card(
                              color: Colors.red.shade50,
                              shape: circular16,
                              child: IconButton(
                                  onPressed: (){},
                                  icon:SvgPicture.asset(
                                    'assets/news.svg',
                                    color: Color(0xffE73700),
                                  )
                              ),
                            ),
                            title: Text(newsList[index]['message'],style: listtile_Title,),
                            subtitle: Row(
                              children: [
                                SvgPicture.asset('assets/calendar.svg',
                                  color: Colors.grey,
                                  height: 15,
                                ),
                                widthPadding6,
                                Text(newsList[index]['dated'].toString().substring(0,10)),
                              ],
                            )
                        ),
                      ),
                    ),


                  ],
                );
              }
          ),
          ListView.builder(
            shrinkWrap: true,
              primary: false,
              itemCount: announcementList.length,
              itemBuilder: (context,index)
              {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topPadding8,index==0?topPadding8:Container(),
                    index==0?
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15),
                      child: Text('Announcements',style: blk16txtStyle),
                    ):Container(),
                    index==0?topPadding8:Container(),
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15,top: 5),
                      child: Card(
                        margin: EdgeInsets.only(right: 2),
                        elevation: 0.3,
                        shape: circular16,
                        color: whiteTxtClr,
                        child: ListTile(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context)=> announcementDetail(
                                      id: announcementList[index]['id'],
                                    )));
                          },
                            trailing: IconButton(
                              onPressed: (){},
                              icon: Icon(CupertinoIcons.chevron_right,color: appClr,),
                            ),
                            leading: Card(
                              color: Colors.green.shade50,
                              shape: circular16,
                              child: IconButton(
                                  onPressed: (){},
                                  icon:SvgPicture.asset(
                                    'assets/announcement.svg',
                                    color:Color(0xff00BDB2),
                                  )
                              ),
                            ),
                            title: Text(announcementList[index]['message'],style: listtile_Title,),
                            subtitle: Row(
                              children: [
                                SvgPicture.asset('assets/calendar.svg',
                                  color: Colors.grey,
                                  height: 15,
                                ),
                                widthPadding6,
                                Text(announcementList[index]['dated'].toString().substring(0,10)),
                              ],
                            )
                        ),
                      ),
                    ),
                    index==announcementList.length-1? SizedBox(height: 100,):Container()
                  ],
                );
              }
          ),
        ],
      )
    );
  }
}

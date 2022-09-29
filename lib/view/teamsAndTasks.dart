import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_task_management/constants/constant.dart';
import 'package:my_task_management/view/MyTasks.dart';
import 'package:my_task_management/view/News&Announcement.dart';
import 'package:my_task_management/view/categoryName.dart';
import 'package:my_task_management/view/learningManagement.dart';
import 'package:my_task_management/view/taskDetail.dart';
import 'package:my_task_management/view/updatePassword.dart';
import 'package:my_task_management/view/updateProfile.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;
import '../models/update-Profile.dart';
import '../widgets/fabWithIcon.dart';
import '../widgets/layout.dart';
import 'announcementDetail.dart';

class teamsandTasks extends StatefulWidget {
  const teamsandTasks({Key? key}) : super(key: key);

  @override
  State<teamsandTasks> createState() => _teamsandTasksState();
}

class _teamsandTasksState extends State<teamsandTasks> {
  //final String name = 'James';
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  // List<Color> leadingcolorsTasks = const[Color(0xffA02EF9), Color(0xff00BDB2)];
  // List<Color> leadingContainerTasks = [Colors.purple.shade50, Colors.green.shade50];
  //List<Tasks> tasks=[];
  List tasks=[];
  List announcementsList=[];
  List learningManagementList=[];
  String dutiesApiEndPointDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
  String upcomingDate = DateFormat('yyyy-MM-dd').format(
      DateTime.now().toUtc().add(Duration(days: 1)));
  Future loadTasks() async {
    return await http.post(Uri.parse('${baseUrl}tasks'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
    setState(() {
    var convertDataToJson= json.decode(response.body);
    tasks =convertDataToJson['list'];
    })
    });
  }
  Future loadAnnouncements() async {
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
        announcementsList =convertDataToJson['list'];
        // print('my tasksss');
        // print(tasks);
      })
    });
  }
  Future loadLearningManagement() async {
    return await http.post(Uri.parse('${baseUrl}learning-management'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var convertDataToJson= json.decode(response.body);
        learningManagementList =convertDataToJson['list'];
      })
    });
  }

  List myDutiesList=[];
  Future loadmyDutiesList(datetime) async {
    return await http.post(Uri.parse('${baseUrl}user/shiftschedule?dated=$datetime'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var convertDataToJson= json.decode(response.body);
        myDutiesList =convertDataToJson['list'];
        print('code');
        print(response.statusCode);
      })
    });
  }
  final icons = [ Icons.sms, Icons.mail ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTasks();
    loadLearningManagement().whenComplete(() =>  setState(() {}));
    loadAnnouncements().whenComplete(() =>  setState(() {}));
    loadmyDutiesList(formatted).whenComplete(() =>  setState(() {}));
    _getprofile();
  }

  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return
    tasks.isEmpty ||learningManagementList.isEmpty
        ||announcementsList.isEmpty?
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
      CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        SliverAppBar(
          title: Text('Teams & Tasks',style: apptitle,) ,
          centerTitle: true,
          snap: false,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset('assets/Frame.png'))
          ), //FlexibleSpaceBar
          expandedHeight: 170,
          backgroundColor: appClr,
          leading:  Padding(
            padding: EdgeInsets.only(top: 8,left: 10),
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
          actions:const <Widget>[
            profileIcon()
                ],
          bottom: PreferredSize(
            preferredSize:const Size.fromHeight(50),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome, '+UpdateProfilePost.user.first_name.toString(),
                      style: smallTitle,),
                    Text('What do you want to do today?',style: bigTitle,),
                    topPadding18,
                  ],
                ),
              ),
            ),
          ),
        ),
       SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: tasks.length,
                  (context, index) =>
                  Column(
                    children: [
                      topPadding8,index==0?topPadding8:Container(),
                      index==0?
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Coming Tasks',style: blk16txtStyle),
                            InkWell(
                              child: Text('View All',style: appclr16txtStyle),
                              onTap: (){
                                Navigator.of(context,rootNavigator: false).push(
                                    MaterialPageRoute(builder: (context)=>myTasks()));
                              },
                            )
                          ],),
                      ):Container(),
                      index==0?topPadding8:Container(),
                      tasks[index]['dated'].substring(0,10)!=upcomingDate
                         ?index==0? Text('No upcoming tasks',style: greytxtStyle14,)
                          :Container()
                          :
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15,top: 5),
                        child: Card(
                          margin:const EdgeInsets.only(right: 2),
                          elevation: 0.3,
                          shape: circular16,
                          color: whiteTxtClr,
                          child: ListTile(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>taskDetailScreen(
                                    key: Key(''),
                                    id:tasks[index]['id']==null
                                        ||tasks[index]['id']==''?"": tasks[index]['id'],
                                  )));
                            },
                              trailing: IconButton(
                                onPressed: (){},
                                icon: Icon(CupertinoIcons.chevron_right,color: appClr,),
                              ),
                              leading: Card(
                                color: Colors.purple.shade50,
                                shape: circular16,
                                child: IconButton(
                                    onPressed: (){},
                                    icon:SvgPicture.asset(
                                      'assets/clipboard.svg',
                                      color: Color(0xffA02EF9),
                                    )
                                ),
                              ),
                              title: Text(tasks[index]['message'].toString(),
                                style: listtile_Title,),
                              subtitle: Row(
                                children: [
                                  SvgPicture.asset('assets/calendar.svg',
                                    color: Colors.grey,
                                    height: 15,
                                  ),
                                  widthPadding6,
                                  Text(tasks[index]['dated'].toString().substring(0,10)),
                                ],
                              )
                          ),
                        ),
                      ),
                    ],
                  )
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: 2,
                  (context, index) =>
                  Column(
                    children: [
                      topPadding8,
                      index==0?topPadding8:Container(),
                      index==0?
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Upcoming Duties',style: blk16txtStyle),
                            InkWell(
                              child: Text('View All',style: appclr16txtStyle),
                              onTap: (){},
                            )
                          ],),
                      ):Container(),
                      index==0?topPadding8:Container(),
                      myDutiesList==null
                          ||myDutiesList[index]['dated'].substring(0,10)!=upcomingDate
                          ?index==0? Text('No upcoming duties',style: greytxtStyle14,)
                          :Container()
                          :
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15,top: 5),
                        child: Card(
                          margin: EdgeInsets.only(right: 2),
                          elevation: 0.3,
                          shape: circular16,
                          color: whiteTxtClr,
                          child: ListTile(
                              trailing: IconButton(
                                onPressed: (){},
                                icon: Icon(CupertinoIcons.chevron_right,color: appClr,),
                              ),
                              leading: Card(
                                color: Colors.red.shade50,
                                shape: circular16,
                                child: IconButton(
                                    onPressed: (){},
                                    icon:SvgPicture.asset(
                                      'assets/calendar.svg',
                                      color:Color(0xffE73700),
                                    )
                                ),
                              ),
                              title: Text(myDutiesList[index]['message'],style: listtile_Title,),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.location_on_outlined,color: Colors.grey,size: 15),
                                  widthPadding6,
                                  Text(dutiesApiEndPointDate.toString()),
                                ],
                              )
                          ),
                        ),
                      ),
                    ],
                  )
          ),
        ),
        SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Learning Management',style: blk16txtStyle),
                      InkWell(
                        child: Text('View All',style: appclr16txtStyle),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>learningManagement()));
                        },
                      )
                    ],),
                ),
                topPadding8,
                Container(
                  height: 200.0,
                  width: 150,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: learningManagementList.length,
                    itemBuilder: (context, index) {
                      var document = parse(
                          learningManagementList[index]['description']);
                      return Container(
                        width: 350.0,
                        child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>
                                            categoryName(
                                          id: learningManagementList[index]['id'],
                                        )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:  MediaQuery.of(context).size.height/8.6,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(22),
                                            topRight: Radius.circular(22)),
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: NetworkImage(
                                                learningManagementList[index]['image']
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10),
                                  child: Row(
                                    children: [
                                      Text(learningManagementList[index]['message'],style: blk13txtStyle,),
                                      widthPadding10,
                                      Icon(Icons.circle,color: appClr,size: 8,),
                                      widthPadding10,
                                      Text(learningManagementList[index]['dated'].toString().substring(0,10),
                                        style: blk13txtStyle,)
                                    ],),
                                ),
                                  Padding(
                                  padding:  EdgeInsets.only(left:15.0,right: 15,top: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: ReadMoreText(
                                      document.body!.text,
                                      // 'The Flutter framework builds its layout via the composition of widgets, '
                                      //     'everything that you construct programmatically is a widget and these '
                                      //     'are compiled together to create the user interface. ',
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
                        ),
                      );
                    },
                  ),
                ),
                topPadding8,
              ],
            )
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: announcementsList.length,
                  (context, index) =>
                  Column(
                    children: [
                      topPadding8,index==0?topPadding8:Container(),
                      index==0?
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Announcements',style: blk16txtStyle),
                            InkWell(
                              child: Text('View All',style: appclr16txtStyle),
                              onTap: (){
                                Navigator.of(context,rootNavigator: false).push(
                                    MaterialPageRoute(builder: (context)=>announcements()));
                              },
                            )
                          ],),
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
                                    MaterialPageRoute(builder: (context)=>announcementDetail(
                                      key: Key(''),
                                      id:announcementsList[index]['id']==null||
                                          announcementsList[index]['id']==''?"": announcementsList[index]['id'],
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
                                      'assets/clipboard.svg',
                                      color: Color(0xff00BDB2),
                                    )
                                ),
                              ),
                              title: Text(announcementsList[index]['message'].toString(),
                                style: listtile_Title,),
                              subtitle: Row(
                                children: [
                                  SvgPicture.asset('assets/calendar.svg',
                                    color: Colors.grey,
                                    height: 15,
                                  ),
                                  widthPadding6,
                                  Text(announcementsList[index]['dated'].toString().substring(0,10)),
                                ],
                              )
                          ),
                        ),
                      ),
                    ],
                  )
          ),
        ),
      ],
    );
  }
  UpdateProfile UpdateProfilePost=UpdateProfile(user: User());
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

      })
    });
  }
}
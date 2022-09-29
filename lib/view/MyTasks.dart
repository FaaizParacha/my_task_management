import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_task_management/view/taskDetail.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';

class myTasks extends StatefulWidget {
  const myTasks({Key? key}) : super(key: key);

  @override
  State<myTasks> createState() => _myTasksState();
}

class _myTasksState extends State<myTasks> with SingleTickerProviderStateMixin{
  final String name = 'James';
  DateTime date =  DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day);
  List<Color> leadingcolorsTasks = const[Color(0xffA02EF9), Color(0xff00BDB2)];
  List<Color> leadingContainerTasks = [Colors.purple.shade50, Colors.green.shade50];

  List<Color> leadingcolorsDuties = const[Color(0xffE73700), Color(0xff00B152)];
  List<Color> leadingContainerDuties = [Colors.red.shade50, Colors.green.shade50];
  TabController? _tabController;
  FocusNode myFocusNode= FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController!.addListener(_handleTabIndex);
    _tabController!.notifyListeners();
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            actions: <Widget>[
              profileIcon()
            ],
            leading:  Padding(
              padding:  EdgeInsets.only(top: 10,left: 8),
              child: Container(
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
            title: Text('My Tasks',style: apptitle,) ,
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              labelColor: whiteTxtClr,
              labelStyle: TextStyle(
                  fontSize: 12
              ),
              //labelPadding: EdgeInsets.only(left:2,right: 2),
              unselectedLabelColor: Colors.white24,
              indicatorColor: whiteTxtClr,
              tabs:const  <Widget>[
                Tab(
                  text: "MY TASKS",
                ),

                Tab(
                  text: "PENDING",
                ),
                Tab(
                  text: "COMPLETED",
                ),
              ],
            ),
          )
        ),
        body:
        TabBarView(
            controller: _tabController,
            children: [
          tasksList(),
              tasksListPending(),
              tasksListCompleted()
        ]),
      )
    );
  }
}


class tasksList extends StatefulWidget {
  const tasksList({Key? key}) : super(key: key);

  @override
  State<tasksList> createState() => _tasksListState();
}

class _tasksListState extends State<tasksList> {
  //final String name = 'James';
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  // List<Color> leadingcolorsTasks = const[Color(0xffA02EF9), Color(0xff00BDB2),
  //   Color(0xffE73700), Color(0xff00B152)
  // ];
  // List<Color> leadingContainerTasks = [Colors.purple.shade50, Colors.green.shade50,
  //   Colors.red.shade50, Colors.green.shade50
  // ];
  List tasks=[];
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
        print('my tasksss');
        print(tasks);
      })
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTasks().whenComplete(() =>  setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return
      tasks.isEmpty?
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
      ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context,index){
      return  Padding(
        padding: const EdgeInsets.only(left:15.0,right: 15,top: 10),
        child: Card(
          margin: EdgeInsets.only(right: 2),
          elevation: 0.3,
          shape: circular16,
          color: whiteTxtClr,
          child: ListTile(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context)=> taskDetailScreen(
                        key: Key(''),
                        id:tasks[index]['id']==null||tasks[index]['id']==''?"": tasks[index]['id'],

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
              title: Text(tasks[index]['message'].toString(),style: listtile_Title,),
              subtitle: Row(
                children: [
                  SvgPicture.asset('assets/calendar.svg',
                    color: Colors.grey,
                    height: 15,
                  ),
                  widthPadding6,
                  Text(tasks[index]['dated'].toString().substring(0,10)),
                  widthPadding6,
                  tasks[index]['status'] == 'pending'
                      ? Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 5,
                  )
                      : tasks[index]['status'] == 'active'? Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 5,
                  ):Icon(
                    Icons.circle,
                    color: Colors.blue,
                    size: 5,
                  )
                ],
              )
          ),
        ),
      );
    });
  }
}


class tasksListPending extends StatefulWidget {
  const tasksListPending({Key? key}) : super(key: key);

  @override
  State<tasksListPending> createState() => _tasksListPendingState();
}

class _tasksListPendingState extends State<tasksListPending> {
  //final String name = 'James';
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  // List<Color> leadingcolorsTasks = const[Color(0xffA02EF9), Color(0xff00BDB2),
  //   Color(0xffE73700), Color(0xff00B152)
  // ];
  // List<Color> leadingContainerTasks = [Colors.purple.shade50, Colors.green.shade50,
  //   Colors.red.shade50, Colors.green.shade50
  // ];
  List tasksPending=[];
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
        tasksPending =convertDataToJson['list'];
        print('my tasksPending');
        print(tasksPending);
      })
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTasks().whenComplete(() =>  setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return
      tasksPending.isEmpty?
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
      ListView.builder(
          itemCount: tasksPending.length,
          itemBuilder: (context,index){
            return
              tasksPending[index]['status']=="pending"?
              Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15,top: 10),
              child: Card(
                margin: EdgeInsets.only(right: 2),
                elevation: 0.3,
                shape: circular16,
                color: whiteTxtClr,
                child: ListTile(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context)=> taskDetailScreen(
                                key: Key(''),
                                id:tasksPending[index]['id']==null||tasksPending[index]['id']==''?"":
                                tasksPending[index]['id'],

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
                    title: Text(tasksPending[index]['message'].toString(),style: listtile_Title,),
                    subtitle: Row(
                      children: [
                        SvgPicture.asset('assets/calendar.svg',
                          color: Colors.grey,
                          height: 15,
                        ),
                        widthPadding6,
                        Text(tasksPending[index]['dated'].toString().substring(0,10)),
                        widthPadding6,
                        tasksPending[index]['status'] == 'pending'
                            ? Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 5,
                        )
                            : tasksPending[index]['status'] == 'active'? Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 5,
                        ):Icon(
                          Icons.circle,
                          color: Colors.blue,
                          size: 5,
                        )
                      ],
                    )
                ),
              ),
            )
            :Center(child: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child:index==0 ?Text('No Pending tasks',style: blk20txtStyle,):Container(),
            ))
            ;
          });
  }
}


class tasksListCompleted extends StatefulWidget {
  const tasksListCompleted({Key? key}) : super(key: key);

  @override
  State<tasksListCompleted> createState() => _tasksListCompletedState();
}

class _tasksListCompletedState extends State<tasksListCompleted> {
  //final String name = 'James';
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  // List<Color> leadingcolorsTasks = const[Color(0xffA02EF9), Color(0xff00BDB2),
  //   Color(0xffE73700), Color(0xff00B152)
  // ];
  // List<Color> leadingContainerTasks = [Colors.purple.shade50, Colors.green.shade50,
  //   Colors.red.shade50, Colors.green.shade50
  // ];
  List tasksCompleted=[];
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
        tasksCompleted =convertDataToJson['list'];
        print('my tasksPending');
        print(tasksCompleted);
      })
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTasks().whenComplete(() =>  setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return
      tasksCompleted.isEmpty?
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
      ListView.builder(
          itemCount: tasksCompleted.length,
          itemBuilder: (context,index){
            return
              tasksCompleted[index]['status']=="completed"?
              Padding(
                padding: const EdgeInsets.only(left:15.0,right: 15,top: 10),
                child: Card(
                  margin: EdgeInsets.only(right: 2),
                  elevation: 0.3,
                  shape: circular16,
                  color: whiteTxtClr,
                  child: ListTile(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=> taskDetailScreen(
                                  key: Key(''),
                                  id:tasksCompleted[index]['id']==null||tasksCompleted[index]['id']==''?"":
                                  tasksCompleted[index]['id'],

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
                      title: Text(tasksCompleted[index]['message'].toString(),style: listtile_Title,),
                      subtitle: Row(
                        children: [
                          SvgPicture.asset('assets/calendar.svg',
                            color: Colors.grey,
                            height: 15,
                          ),
                          widthPadding6,
                          Text(tasksCompleted[index]['dated'].toString().substring(0,10)),
                          widthPadding6,
                          tasksCompleted[index]['status'] == 'pending'
                              ? Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 5,
                          )
                              : tasksCompleted[index]['status'] == 'active'? Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 5,
                          ):Icon(
                            Icons.circle,
                            color: Colors.blue,
                            size: 5,
                          )
                        ],
                      )
                  ),
                ),
              )
                  :Center(child: Padding(
                padding: const EdgeInsets.only(top:8.0),
                child:index==0 ?Text("You haven't completed any tasks",style: blk20txtStyle,):Container(),
              ))
            ;
          });
  }
}
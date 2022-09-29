import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../widgets/learningManagementCard.dart';

class learningManagement extends StatefulWidget {
  const learningManagement({Key? key}) : super(key: key);

  @override
  State<learningManagement> createState() => _learningManagementState();
}

class _learningManagementState extends State<learningManagement> with SingleTickerProviderStateMixin{
  final List<String> imageUrl=[
    'assets/RectangleL.png',
    'assets/RectangleL2.png',
    'assets/RectangleL3.png',
    'assets/RectangleL4.png',
    'assets/RectangleL.png',
  ];
  late TabController _tabController;
  FocusNode myFocusNode= FocusNode();
List learningManagementList=[];

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
        // print('my learningManagementList');
        // print(learningManagementList);
      })
    });
  }

  @override
  void initState() {
    super.initState();
    loadLearningManagement().whenComplete(() =>  setState(() {}));
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    //if(widget.isNew==false){

    // }
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _tabController.notifyListeners();
  }
  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
    });
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
              child: Text('Learning Management',style: apptitle,),
            ) ,
          )
      ),
      body:
      learningManagementList.isEmpty?
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
      TabBarView(
        controller: _tabController,
        children: [
          NestedTabBar(
          tabbarbarLength: 4,
              nestedTabbarView: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                    itemCount: learningManagementList.length,
                    itemBuilder: (context,index)
                    {
                      var document = parse(
                          learningManagementList[index]['description']);
                      return ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: [
                          learningManagementCard(
                            id: learningManagementList[index]['id'],
                            imageUrl: learningManagementList[index]['image'],
                            message: learningManagementList[index]['message'],
                            description: document.body!.text,
                            date: learningManagementList[index]['dated'].toString().substring(0,10),
                          ),
                         index==learningManagementList.length-1? SizedBox(height: 200,):Container()
                        ],
                      );
                    }
                ),
               Container(child:const Text('category 1'),),
                Container(child:const Text('category 2'),),
                Container(child:const Text('category 3'),),

              ],
            )
        ],
      )
    );
  }
}


class NestedTabBar extends StatefulWidget {
  final List<Widget> nestedTabbarView;
  final int tabbarbarLength;
  NestedTabBar({Key? key,required this.nestedTabbarView,
    required this.tabbarbarLength
  }) : super(key: key);
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}
class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<NestedTabBar> {

  late TabController _tabController;
  FocusNode myFocusNode= FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    _tabController = TabController(length: widget.tabbarbarLength, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _tabController.notifyListeners();
  }
  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: <Widget>[
        topPadding10,
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Container(
              width: 50,
              height: 30,
              padding:const EdgeInsets.only(left: 5,right: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: _tabController.index==0?appClr:Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                color: _tabController.index==0?appClr:Colors.grey.shade50
              ),
              child: Tab(
                child: Text('All',style: TextStyle(
                  color: _tabController.index==0?whiteTxtClr:blkTxtClr,
                ),),
              ),
            ),
            Container(
              width: 90,
              height: 30,
              padding:const EdgeInsets.only(left: 5,right: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: _tabController.index==1?appClr:Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                  color: _tabController.index==1?appClr:Colors.grey.shade50
              ),
              child: Tab(
                child: Text('Category 1',style: TextStyle(
                  color: _tabController.index==1?whiteTxtClr:blkTxtClr,
                ),),
              ),
            ),
            Container(
              width: 90,
              height: 30,
              padding:const EdgeInsets.only(left: 5,right: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: _tabController.index==2?appClr:Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                  color: _tabController.index==2?appClr:Colors.grey.shade50
              ),
              child: Tab(
                child: Text('Category 2',style: TextStyle(
                  color: _tabController.index==2?whiteTxtClr:blkTxtClr,
                ),),
              ),
            ),
            Container(
              width: 90,
              height: 30,
              padding:const EdgeInsets.only(left: 5,right: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: _tabController.index==3?appClr:Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                  color: _tabController.index==3?appClr:Colors.grey.shade50
              ),
              child: Tab(
                child: Text('Category 3',style: TextStyle(
                  color: _tabController.index==3?whiteTxtClr:blkTxtClr,
                ),),
              ),
            ),
          ],
        ),
        Container(
            height: screenHeight * 0.99,
            width: double.infinity,
            //margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: TabBarView(
              controller: _tabController,
              children: widget.nestedTabbarView,
            )
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
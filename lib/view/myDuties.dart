import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../constants/constant.dart';
import '../models/myPayroll.dart';


class myDuties extends StatefulWidget {
  const myDuties({Key? key}) : super(key: key);

  @override
  State<myDuties> createState() => _myDutiesState();
}

class _myDutiesState extends State<myDuties> {
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
  String _date = DateFormat('yyyy-MM-dd').format(
      DateTime.now().toUtc()).toString();
  var selecteddate;
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
        print('duties');
        print(myDutiesList);
      })
    });
  }
  Future selectionChanged(DateRangePickerSelectionChangedArgs args) async{
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        var temp_date =args.value;
        _date = DateFormat('yyyy-MM-dd').format(temp_date);

        selecteddate=DateFormat('yyyy-MM-dd').format(temp_date);
        loadmyDutiesList(selecteddate).then((value) => setState((){})).whenComplete(() => setState((){}));
      });
    });
    return 'success';
  }
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().toUtc().subtract(Duration(days: 30))) &&
        day.isBefore(DateTime.now().toUtc()))) {
      return true;
    }
    return false;
  }
  final DateRangePickerController _controller = DateRangePickerController();
  @override
  void initState() {
    super.initState();
    loadmyDutiesList(formattedDate).whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: AppBar(
                actions: <Widget>[
                  profileIcon()
                ],
                leading: Padding(
                  padding: EdgeInsets.only(top: 10, left: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
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
                        child: Image.asset('assets/Frame.png'))),
                centerTitle: true,
                backgroundColor: appClr,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'My Duties',
                    style: apptitle,
                  ),
                ),
              )),
          body:
          myDutiesList==null||myDutiesList.isEmpty
              ?
          Container(
              height: double.infinity,
              width: double.infinity,
              color: whiteTxtClr,
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: Colors.blue.shade50,
                    child: SfDateRangePicker(
                      headerStyle: DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: blk20txtStyle
                      ),
                      onViewChanged: (DateRangePickerViewChangedArgs  v){
                      },
                      selectableDayPredicate: _decideWhichDayToEnable,
                      selectionColor: appClr,
                      selectionShape: DateRangePickerSelectionShape.rectangle,
                      view: DateRangePickerView.month,
                      initialSelectedDate: DateTime.now(),
                      controller: _controller,
                      onSelectionChanged: selectionChanged,

                    ),
                  ),
                  topPadding20,topPadding20,
                  Text('No Duties available',style: blk20txtStyle,)
                ],
              )
          ):
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: myDutiesList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  index == 0 ? Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: Colors.blue.shade50,
                    child: SfDateRangePicker(
                      headerStyle: DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: blk20txtStyle
                      ),
                      onViewChanged: (DateRangePickerViewChangedArgs  v){
                      },
                      selectableDayPredicate: _decideWhichDayToEnable,
                      selectionColor: appClr,
                      selectionShape: DateRangePickerSelectionShape.rectangle,
                      view: DateRangePickerView.month,
                      initialSelectedDate: DateTime.parse(_date),
                      controller: _controller,
                      onSelectionChanged: selectionChanged,

                    ),
                  )
                      : Container(),

                  Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 0.3,
                    shape: circular16,
                    color: whiteTxtClr,
                    child: ListTile(
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.chevron_right,
                            color: appClr,
                          ),
                        ),
                        leading: Card(
                          color: Colors.purple.shade50,
                          shape: circular16,
                          child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/walletfilled.svg',
                                color: Color(0xffA02EF9),
                              )),
                        ),
                        title: Text(
                          myDutiesList[index]['message'],
                          style: listtile_Title,
                        ),
                        subtitle: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/calendar.svg',
                              color: Colors.grey,
                              height: 15,
                            ),
                            widthPadding6,
                            Text(_date.toString()),
                            widthPadding6,
                            myDutiesList[index]['status'] == 'pending'
                                ? Icon(
                              Icons.circle,
                              color: Colors.red,
                              size: 5,
                            )
                                : myDutiesList[index]['status'] == 'active'? Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 5,
                            ):Container()
                          ],
                        )),
                  )
                ],
              );
            },));

  }
}
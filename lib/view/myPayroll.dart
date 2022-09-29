
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


class myPayroll extends StatefulWidget {
  const myPayroll({Key? key}) : super(key: key);

  @override
  State<myPayroll> createState() => _myPayrollState();
}

class _myPayrollState extends State<myPayroll> {
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc().subtract(Duration(days: 1)));
  String _date = DateFormat('yyyy-MM-dd').format(
      DateTime.now().toUtc()).toString();
  var selecteddate;
  List payrollList=[];
  Future loadPayrolls(datetime) async {
    return await http.post(Uri.parse('${baseUrl}user/payroll?dated=$datetime'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var convertDataToJson= json.decode(response.body);
        payrollList =convertDataToJson['list'];
        print('payrolllsss');
        print(payrollList);
      })
    });
  }

  String _dateno = DateFormat('dd').format(
      DateTime.now().toUtc().subtract(Duration(days: 1))
  ).toString();
  String _datemnth = DateFormat('MMM').format(
      DateTime.now().toUtc()).toString();
  Future selectionChanged(DateRangePickerSelectionChangedArgs args) async{
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        var temp_date =args.value;
        _date = DateFormat('yyyy-MM-dd').format(temp_date);
        _dateno = DateFormat('dd').format(temp_date);
        _datemnth = DateFormat('MMM').format(temp_date);
        selecteddate=DateFormat('yyyy-MM-dd').format(temp_date);
        loadPayrolls(selecteddate).then((value) => setState((){})).whenComplete(() => setState((){}));
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
    loadPayrolls(formattedDate).whenComplete(() => setState(() {}));
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
                  'My Payroll',
                  style: apptitle,
                ),
              ),
            )),
        body:
   payrollList==null||payrollList.isEmpty
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
                    initialSelectedDate: DateTime.now(),//DateTime.parse(_date),
                    controller: _controller,
                    onSelectionChanged: selectionChanged,

                  ),
                ),
              topPadding20,topPadding20,
               SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: appClr,
                    //value: 1, // Change this value to update the progress
                  ),
                ),
              ],
            )
        ):
         ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: payrollList.length,
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
                 payrollList==null?
                     Text('this is no payrolls for selected date'):
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
                         payrollList[index]['message'],
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
                           Text(selecteddate.toString()),
                           widthPadding6,
                           payrollList[index]['status'] == 'pending'
                               ? Icon(
                             Icons.circle,
                             color: Colors.red,
                             size: 5,
                           )
                               : payrollList[index]['status'] == 'success'? Icon(
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

// class TableComplexExample extends StatefulWidget {
//   @override
//   _TableComplexExampleState createState() => _TableComplexExampleState();
// }
//
// class _TableComplexExampleState extends State<TableComplexExample> {
//   late final PageController _pageController;
//   late final ValueNotifier<List<Event>> _selectedEvents;
//   final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
//   final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
//     equals: isSameDay,
//     hashCode: getHashCode,
//   );
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc().subtract(Duration(days: 1)));
//   List payrollList=[];
//   Future loadPayrolls(datetime) async {
//     return await http.post(Uri.parse('${baseUrl}user/payroll?dated=$datetime'),
//         headers: {
//           'Content-type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer ${BearerToken}'
//         }
//     ).then((response) =>
//     {
//       setState(() {
//         var convertDataToJson= json.decode(response.body);
//         payrollList =convertDataToJson['list'];
//       })
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadPayrolls(formattedDate).whenComplete(() => setState(() {}));
//     _selectedDays.add(_focusedDay.value);
//     _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
//   }
//
//   @override
//   void dispose() {
//     _focusedDay.dispose();
//     _selectedEvents.dispose();
//     super.dispose();
//   }
//
//   bool get canClearSelection =>
//       _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;
//
//   List<Event> _getEventsForDay(DateTime day) {
//     return kEvents[day] ?? [];
//   }
//
//   List<Event> _getEventsForDays(Iterable<DateTime> days) {
//     return [
//       for (final d in days) ..._getEventsForDay(d),
//     ];
//   }
//
//   List<Event> _getEventsForRange(DateTime start, DateTime end) {
//     final days = daysInRange(start, end);
//     return _getEventsForDays(days);
//   }
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       if (_selectedDays.contains(selectedDay)) {
//         _selectedDays.remove(selectedDay);
//       } else {
//         _selectedDays.add(selectedDay);
//       }
//
//       _focusedDay.value = focusedDay;
//       _rangeStart = null;
//       _rangeEnd = null;
//       _rangeSelectionMode = RangeSelectionMode.toggledOff;
//     });
//
//     _selectedEvents.value = _getEventsForDays(_selectedDays);
//   }
//
//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _focusedDay.value = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _selectedDays.clear();
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });
//
//     if (start != null && end != null) {
//       _selectedEvents.value = _getEventsForRange(start, end);
//     } else if (start != null) {
//       _selectedEvents.value = _getEventsForDay(start);
//     } else if (end != null) {
//       _selectedEvents.value = _getEventsForDay(end);
//     }
//   }
//   final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
//   List<Color> leadingcolorsTasks = const[Color(0xffA02EF9), Color(0xff00BDB2)];
//   List<Color> leadingContainerTasks = [Colors.purple.shade50, Colors.green.shade50];
//
//   List<Color> leadingcolorsDuties = const[Color(0xffE73700), Color(0xff00B152)];
//   List<Color> leadingContainerDuties = [Colors.red.shade50, Colors.green.shade50];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           ValueListenableBuilder<DateTime>(
//             valueListenable: _focusedDay,
//             builder: (context, value, _) {
//               return _CalendarHeader(
//                 focusedDay: value,
//                 clearButtonVisible: canClearSelection,
//                 onTodayButtonTap: () {
//                   setState(() => _focusedDay.value = DateTime.now());
//                 },
//                 onClearButtonTap: () {
//                   setState(() {
//                     _rangeStart = null;
//                     _rangeEnd = null;
//                     _selectedDays.clear();
//                     _selectedEvents.value = [];
//                   });
//                 },
//                 onLeftArrowTap: () {
//                   _pageController.previousPage(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeOut,
//                   );
//                 },
//                 onRightArrowTap: () {
//                   _pageController.nextPage(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeOut,
//                   );
//                 },
//               );
//             },
//           ),
//           Card(
//             elevation: 0,
//             color: Colors.blue.shade50,
//             child: TableCalendar<Event>(
//               calendarBuilders: CalendarBuilders(
//                 dowBuilder: (context, day) {
//                   if (day.weekday == DateTime.sunday) {
//                     final text = DateFormat.E().format(day);
//
//                     return Center(
//                       child: Text(
//                         text,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               firstDay: kFirstDay,
//               lastDay: kLastDay,
//               focusedDay: _focusedDay.value,
//               headerVisible: false,
//               selectedDayPredicate: (day) => _selectedDays.contains(day),
//               rangeStartDay: _rangeStart,
//               rangeEndDay: _rangeEnd,
//               calendarFormat: _calendarFormat,
//               rangeSelectionMode: _rangeSelectionMode,
//               eventLoader: _getEventsForDay,
//               holidayPredicate: (day) {
//                 // Every 20th day of the month will be treated as a holiday
//                 return day.day == 20;
//               },
//               onDaySelected: _onDaySelected,
//               onRangeSelected: _onRangeSelected,
//               onCalendarCreated: (controller) => _pageController = controller,
//               onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
//               onFormatChanged: (format) {
//                 if (_calendarFormat != format) {
//                   setState(() => _calendarFormat = format);
//                 }
//               },
//               calendarStyle: CalendarStyle(
//                   markerSize: 6,
//                   selectedDecoration: BoxDecoration(
//                       color: appClr,borderRadius: BorderRadius.circular(5)
//                   )
//               ),
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           payrollList.isEmpty?
//               Text('No tasks here')
//               : Expanded(
//             child: ValueListenableBuilder<List<Event>>(
//               valueListenable: _selectedEvents,
//               builder: (context, value, _) {
//                 return ListView.builder(
//                   itemCount: payrollList.length,
//                   itemBuilder: (context, index) {
//                     return
//                       //   Container(
//                       //   margin: const EdgeInsets.symmetric(
//                       //     horizontal: 12.0,
//                       //     vertical: 4.0,
//                       //   ),
//                       //   decoration: BoxDecoration(
//                       //     border: Border.all(),
//                       //     borderRadius: BorderRadius.circular(12.0),
//                       //   ),
//                       //   child: ListTile(
//                       //     onTap: () => print('${value[index]}'),
//                       //     title: Text('${value[index]}'),
//                       //   ),
//                       // );
//                       Padding(
//                         padding: const EdgeInsets.only(left:15.0,right: 15,top: 5),
//                         child: Card(
//                           margin:const EdgeInsets.only(right: 2),
//                           elevation: 0.3,
//                           shape: circular16,
//                           color: whiteTxtClr,
//                           child: ListTile(
//                               trailing: IconButton(
//                                 onPressed: (){},
//                                 icon:const Icon(CupertinoIcons.chevron_right,color: appClr,),
//                               ),
//                               leading: Card(
//                                 color: Colors.purple.shade50,
//                                 shape: circular16,
//                                 child: IconButton(
//                                     onPressed: (){},
//                                     icon:SvgPicture.asset(
//                                       'assets/walletfilled.svg',
//                                       color:Color(0xffA02EF9),
//                                     )
//                                 ),
//                               ),
//                               title: Text('${value[index]}',style: listtile_Title,),
//                               subtitle: Row(
//                                 children: [
//                                   SvgPicture.asset('assets/calendar.svg',
//                                     color: Colors.grey,
//                                     height: 15,
//                                   ),
//                                   widthPadding6,
//                                   Text(formattedDate.toString()),
//                                   widthPadding6,
//                                   payrollList[index]['status']=='pending'?
//                                   Icon(Icons.circle, color: Colors.red, size: 5,)
//                                       :
//                                   Icon(Icons.circle, color: Colors.green, size: 5,)
//                                 ],
//                               )
//                           ),
//                         ),
//                       );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CalendarHeader extends StatelessWidget {
//   final DateTime focusedDay;
//   final VoidCallback onLeftArrowTap;
//   final VoidCallback onRightArrowTap;
//   final VoidCallback onTodayButtonTap;
//   final VoidCallback onClearButtonTap;
//   final bool clearButtonVisible;
//
//   const _CalendarHeader({
//     Key? key,
//     required this.focusedDay,
//     required this.onLeftArrowTap,
//     required this.onRightArrowTap,
//     required this.onTodayButtonTap,
//     required this.onClearButtonTap,
//     required this.clearButtonVisible,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final headerText = DateFormat.yMMM().format(focusedDay);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Card(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)
//             ),
//             color: Colors.grey.shade50,
//             margin: EdgeInsets.only(left: 15,),
//             child: IconButton(
//               icon: Icon(Icons.chevron_left),
//               onPressed: onLeftArrowTap,
//             ),
//           ),
//           Spacer(),
//           Text(
//             headerText,
//             style: blk20txtStyle,
//           ),
//           if (clearButtonVisible)
//             IconButton(
//               icon: Icon(Icons.clear, size: 20.0),
//               visualDensity: VisualDensity.compact,
//               onPressed: onClearButtonTap,
//             ),
//           const Spacer(),
//           Card(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)
//             ),
//             margin: EdgeInsets.only(right: 15,),
//             color: Colors.grey.shade50,
//             child: IconButton(
//               icon: Icon(Icons.chevron_right),
//               onPressed: onRightArrowTap,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class Event {
//   final String title;
//
//   const Event(this.title);
//
//   @override
//   String toString() => title;
// }
//
// /// Example events.
// ///
// /// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);
//
// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll({
//     kToday: [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });
//
// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }
//
// /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
// List<DateTime> daysInRange(DateTime first, DateTime last) {
//   final dayCount = last.difference(first).inDays + 1;
//   return List.generate(
//     dayCount,
//         (index) => DateTime.utc(first.year, first.month, first.day + index),
//   );
// }
//
// final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
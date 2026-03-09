import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  DateTime focusedDay = DateTime(2026,3,1);

  final List<DateTime> holidays = [
    DateTime(2026,3,3),
    DateTime(2026,3,9),
    DateTime(2026,3,15),
    DateTime(2026,3,21),
    DateTime(2026,3,28),
  ];

  bool isHoliday(DateTime day){
    return holidays.any((holiday)=>
    holiday.year==day.year &&
        holiday.month==day.month &&
        holiday.day==day.day);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Calendar",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// LEFT FILTER
                  SizedBox(
                    width:200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical:12,horizontal:20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Add Event",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        const SizedBox(height:20),

                        const Text("My Calendars"),

                        const SizedBox(height:15),

                        _checkItem("Work"),
                        _checkItem("Personal"),
                        _checkItem("Important"),
                        _checkItem("Travel"),
                        _checkItem("Friends"),

                      ],
                    ),
                  ),

                  const SizedBox(width:30),

                  /// CALENDAR
                  Expanded(
                    child: Column(
                      children: [

                        /// TOP BAR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Row(
                              children: [

                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        focusedDay = DateTime(
                                            focusedDay.year,
                                            focusedDay.month-1);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_back_ios)
                                ),

                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        focusedDay = DateTime(
                                            focusedDay.year,
                                            focusedDay.month+1);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)
                                ),

                                const SizedBox(width:10),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:12,vertical:6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text("today"),
                                )
                              ],
                            ),

                            Text(
                              "${_monthName(focusedDay.month)} ${focusedDay.year}",
                              style: const TextStyle(
                                fontSize:22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Row(
                              children: [
                                _modeBtn("month",true),
                                _modeBtn("week",false),
                                _modeBtn("day",false),
                                _modeBtn("list",false),
                              ],
                            )
                          ],
                        ),

                        const SizedBox(height:20),

                        /// CALENDAR
                        TableCalendar(

                          firstDay: DateTime.utc(2020),
                          lastDay: DateTime.utc(2030),
                          focusedDay: focusedDay,

                          calendarBuilders: CalendarBuilders(

                            defaultBuilder: (context,day,focusedDay){

                              if(isHoliday(day)){
                                return Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("${day.day}"),
                                );
                              }

                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _checkItem(String text){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:6),
      child: Row(
        children: [
          Checkbox(value:false,onChanged:(v){}),
          Text(text),
        ],
      ),
    );
  }

  Widget _modeBtn(String text,bool active){
    return Container(
      margin: const EdgeInsets.only(left:6),
      padding: const EdgeInsets.symmetric(horizontal:12,vertical:6),
      decoration: BoxDecoration(
        color: active?Colors.blue.shade300:Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text),
    );
  }

  String _monthName(int m){
    const months=[
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return months[m-1];
  }
}
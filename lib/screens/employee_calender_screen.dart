//calender.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  DateTime focusedDay = DateTime.now();
  bool showHolidayOnly = false;
  String viewMode = "month";

  /// Same holidays every month
  final List<int> holidayDates = [3,9,15,21,28];

  bool isHoliday(DateTime day){
    return holidayDates.contains(day.day);
  }

  @override
  Widget build(BuildContext context) {

    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
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

                  child: isMobile
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _calendarFilter(),
                      const SizedBox(height:20),
                      _calendarView(),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _calendarFilter(),
                      const SizedBox(width:30),
                      Expanded(child: _calendarView()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////

  Widget _calendarFilter(){
    return SizedBox(
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

          const SizedBox(height:10),

          Row(
            children: [
              Checkbox(
                value: showHolidayOnly,
                onChanged: (v){
                  setState(() {
                    showHolidayOnly = v!;
                  });
                },
              ),
              const Text("Holiday")
            ],
          )
        ],
      ),
    );
  }

////////////////////////////////////////////////////////

  Widget _calendarView(){

    Widget view;

    if(viewMode == "week"){
      view = _weekView();
    } else {
      view = _monthView();
    }

    return Column(
      children: [

        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
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
                _modeBtn("month"),
                _modeBtn("week"),
                _modeBtn("day"),
                _modeBtn("list"),
              ],
            )
          ],
        ),

        const SizedBox(height:20),

        view
      ],
    );
  }

////////////////////////////////////////////////////////

  Widget _monthView(){
    return TableCalendar(
      firstDay: DateTime.utc(2003),
      lastDay: DateTime.utc(2030),
      focusedDay: focusedDay,

      calendarBuilders: CalendarBuilders(

        defaultBuilder: (context,day,focusedDay){

          if(showHolidayOnly && !isHoliday(day)){
            return const SizedBox();
          }

          if(isHoliday(day)){
            return Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                "${day.day}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          return null;
        },
      ),
    );
  }

////////////////////////////////////////////////////////

  Widget _weekView(){
    return SizedBox(
      height:400,
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount:24,
          itemBuilder:(context,index){

            return Container(
              height:40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal:10),
              alignment: Alignment.centerLeft,
              child: Text("${index+1}:00"),
            );

          },
        ),
      ),
    );
  }

////////////////////////////////////////////////////////

  Widget _modeBtn(String text){

    bool active = viewMode == text;

    return GestureDetector(
      onTap: (){
        setState(() {
          viewMode = text;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left:6),
        padding: const EdgeInsets.symmetric(horizontal:12,vertical:6),
        decoration: BoxDecoration(
          color: active?Colors.blue.shade300:Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text),
      ),
    );
  }

////////////////////////////////////////////////////////

  String _monthName(int m){
    const months=[
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return months[m-1];
  }

}
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class AnimatedDashboard extends StatefulWidget {
  const AnimatedDashboard({super.key});

  @override
  State<AnimatedDashboard> createState() => _AnimatedDashboardState();
}

class _AnimatedDashboardState extends State<AnimatedDashboard> {
  bool isLoaded = false;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text("Premium Charts UI",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildChartCard("Bar Chart with Line", _barLineChart()),
            const SizedBox(height: 20),
            _buildChartCard("Graph Line Chart", advancedGraphChart()),
            const SizedBox(height: 20),
            _buildChartCard("Line Chart Performance", _dualLineChart()),
            const SizedBox(height: 20),
            _buildChartCard("Pie Chart", const AnimatedPieChart()),
            _buildChartCard("Area Line Chart", areaLineChart()),
            _buildChartCard("Pie Chart", const RosePieChart()),
            _buildChartCard("Sunburst Chart", const SunburstChart()),
          ],
        ),
      ),
    );
  }

  // ---------------- CARD ----------------
  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey)),
          const SizedBox(height: 25),
          SizedBox(height: 250, child: chart),
        ],
      ),
    );
  }

  // ---------------- BAR + LINE (OLD SAME) ----------------
  Widget _barLineChart() {
    return Stack(
      children: [
        BarChart(
          BarChartData(
            maxY: 25,
            alignment: BarChartAlignment.spaceAround,
            titlesData: _buildTitles(),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
            barGroups: [
              _groupData(0, isLoaded ? 11 : 0, isLoaded ? 10 : 0),
              _groupData(1, isLoaded ? 14 : 0, isLoaded ? 14 : 0),
              _groupData(2, isLoaded ? 8 : 0, isLoaded ? 10 : 0),
              _groupData(3, isLoaded ? 16 : 0, isLoaded ? 15 : 0),
              _groupData(4, isLoaded ? 11 : 0, isLoaded ? 9 : 0),
            ],
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Colors.white,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final sales = group.barRods[0].toY.toInt();
                  final profit = group.barRods[1].toY.toInt();
                  final growth = profit - sales;

                  return BarTooltipItem(
                    "201${group.x + 4}\n\n",
                    const TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "● sales $sales\n",
                        style: const TextStyle(color: Color(0xFFA376FF)),
                      ),
                      TextSpan(
                        text: "● profit $profit\n",
                        style: const TextStyle(color: Color(0xFF2CB9FF)),
                      ),
                      TextSpan(
                        text: "● growth $growth",
                        style: const TextStyle(color: Color(0xFFFF9F1C)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        // LINE overlay
        LineChart(
          LineChartData(
            maxY: 25,
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: isLoaded
                    ? [
                  const FlSpot(0.4, 10),
                  const FlSpot(1.4, 7),
                  const FlSpot(2.4, 17),
                  const FlSpot(3.4, 11),
                  const FlSpot(4.4, 15),
                ]
                    : List.generate(5, (i) => FlSpot(i + 0.4, 0)),
                isCurved: true,
                color: const Color(0xFF2CB9FF),
                barWidth: 4,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- GRAPH ----------------
  Widget advancedGraphChart() {
    return BarChart(
      BarChartData(
        maxY: 90,
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, m) {
                const y = ["2000","2001","2002","2003","2004","2005"];
                return Text(y[v.toInt()]);
              },
            ),
          ),
        ),
        barGroups: [
          _graphBar(0, 22, 35),
          _graphBar(1, 54, 45),
          _graphBar(2, 37, 47),
          _graphBar(3, 23, 10),
          _graphBar(4, 25, 35),
          _graphBar(5, 76, 70),
        ],
      ),
    );
  }

  // ---------------- LINE ----------------
  Widget _dualLineChart() {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.white,
            getTooltipItems: (spots) {
              final spot = spots.last;

              String label;
              Color color;

              if (spot.barIndex == 0) {
                label = "Sales";
                color = const Color(0xFF2CB9FF);
              } else {
                label = "Profit";
                color = const Color(0xFFFF9F1C);
              }

              return [
                LineTooltipItem(
                  "201${spot.x.toInt() + 4}\n\n",
                  const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "● $label: ",
                      style: TextStyle(color: color),
                    ),
                    TextSpan(
                      text: "${spot.y.toInt()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ];
            },
          ),
        ),
        titlesData: _buildTitles(),
        lineBarsData: [
          _lineStyle([
            const FlSpot(0,15),const FlSpot(1,22),
            const FlSpot(2,14),const FlSpot(3,31),
            const FlSpot(4,17)
          ], const Color(0xFF2CB9FF)),
          _lineStyle([
            const FlSpot(0,8),const FlSpot(1,12),
            const FlSpot(2,28),const FlSpot(3,10),
            const FlSpot(4,10)
          ], const Color(0xFFFF9F1C)),
        ],
      ),
    );
  }

  // ---------------- UTIL ----------------
  BarChartGroupData _groupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: const Color(0xFFA376FF)),
        BarChartRodData(toY: y2, color: const Color(0xFFFF9F1C)),
      ],
    );
  }

  BarChartGroupData _graphBar(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: const Color(0xFFA376FF)),
        BarChartRodData(toY: y2, color: const Color(0xFF3DB2D3)),
      ],
    );
  }

  LineChartBarData _lineStyle(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: isLoaded ? spots : spots.map((e)=>FlSpot(e.x,0)).toList(),
      isCurved: true,
      color: color,
      barWidth: 4,
      dotData: FlDotData(show: true),
    );
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (v,m){
            const y=["2014","2015","2016","2017","2018"];
            return Text(y[v.toInt()]);
          },
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
    );
  }
}

// ---------------- PIE ----------------
class AnimatedPieChart extends StatefulWidget {
  const AnimatedPieChart({super.key});

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 50,
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
            });
          },
        ),
        sections: List.generate(5, (i) => _section(i)),
      ),
    );
  }

  PieChartSectionData _section(int i) {
    final isTouched = i == touchedIndex;

    final data = [400,300,200,150,548];
    final colors = [
      Color(0xFF5B5F7A),
      Color(0xFFD96C57),
      Color(0xFFD6B41F),
      Color(0xFF6FB27F),
      Color(0xFF5AA6D1),
    ];

    return PieChartSectionData(
      value: data[i].toDouble(),
      color: colors[i],
      radius: isTouched ? 70 : 60,
      title: isTouched ? "${data[i]}" : "",
    );
  }
}
Widget areaLineChart() {
  return LineChart(
    LineChartData(
      maxY: 1500,

      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,

        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => Colors.white,
          tooltipRoundedRadius: 10,
          tooltipPadding: const EdgeInsets.all(10),

          getTooltipItems: (spots) {
            final spot = spots.last; // 👈 ONLY CURRENT LINE

            String label;
            Color color;

            if (spot.barIndex == 0) {
              label = "Intent";
              color = const Color(0xFF2CB9FF);
            } else if (spot.barIndex == 1) {
              label = "Pre-order";
              color = const Color(0xFFFF5A5F);
            } else {
              label = "Deal";
              color = const Color(0xFF7B61FF);
            }

            return [
              LineTooltipItem(
                _dayLabel(spot.x.toInt()),
                const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "\n● $label: ",
                    style: TextStyle(color: color),
                  ),
                  TextSpan(
                    text: "${spot.y.toInt()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ];
          },
        ),
      ),

      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(_dayLabel(value.toInt()));
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),

      borderData: FlBorderData(show: false),

      lineBarsData: [
        // 🔵 Intent
        _areaLine([
          const FlSpot(0, 1300),
          const FlSpot(1, 1100),
          const FlSpot(2, 600),
          const FlSpot(3, 234),
          const FlSpot(4, 150),
          const FlSpot(5, 100),
          const FlSpot(6, 50),
        ], const Color(0xFF2CB9FF)),

        // 🔴 Pre-order
        _areaLine([
          const FlSpot(0, 50),
          const FlSpot(1, 200),
          const FlSpot(2, 400),
          const FlSpot(3, 791),
          const FlSpot(4, 350),
          const FlSpot(5, 50),
          const FlSpot(6, 20),
        ], const Color(0xFFFF5A5F)),

        // 🟣 Deal
        _areaLine([
          const FlSpot(0, 10),
          const FlSpot(1, 10),
          const FlSpot(2, 20),
          const FlSpot(3, 54),
          const FlSpot(4, 300),
          const FlSpot(5, 850),
          const FlSpot(6, 700),
        ], const Color(0xFF7B61FF)),
      ],
    ),
  );
}
LineChartBarData _areaLine(List<FlSpot> spots, Color color) {
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    color: color,
    barWidth: 3,
    dotData: FlDotData(show: true),

    belowBarData: BarAreaData(
      show: true,
      color: color.withValues(alpha: 0.3), // 👈 area fill
    ),
  );
}
String _dayLabel(int x) {
  const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  return days[x];
}
class RosePieChart extends StatelessWidget {
  const RosePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 0,
            sections: _sections(),
          ),
        ),

        // 👇 Labels + lines
        Positioned.fill(
          child: CustomPaint(
            painter: PieLabelPainter(),
          ),
        ),

        // 👇 Legend bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: List.generate(8, (i) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _colors[i],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text("rose ${i + 1}"),
                ],
              );
            }),
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> _sections() {
    final values = [40, 35, 30, 28, 25, 20, 18, 15];

    return List.generate(8, (i) {
      return PieChartSectionData(
        value: values[i].toDouble(),
        color: _colors[i],
        radius: values[i].toDouble() + 40, // 👈 rose effect
        title: "",
      );
    });
  }
}

final List<Color> _colors = [
  Color(0xFF5470C6),
  Color(0xFF91CC75),
  Color(0xFF5A5F7A),
  Color(0xFFF7944D),
  Color(0xFF2CB9FF),
  Color(0xFFFAC515),
  Color(0xFFEF5A7A),
  Color(0xFF7A60A6),
];
class PieLabelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 100;

    final paint = Paint()
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14 / 180;

      final start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      final end = Offset(
        center.dx + (radius + 30) * cos(angle),
        center.dy + (radius + 30) * sin(angle),
      );

      paint.color = _colors[i];

      canvas.drawLine(start, end, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: "rose ${i + 1}",
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          end.dx + (cos(angle) > 0 ? 5 : -40),
          end.dy,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class SunburstChart extends StatefulWidget {
  const SunburstChart({super.key});

  @override
  State<SunburstChart> createState() => _SunburstChartState();
}

class _SunburstChartState extends State<SunburstChart> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          selectedIndex = (selectedIndex + 1) % 6; // demo cycle
        });
      },
      child: CustomPaint(
        size: const Size(double.infinity, 250),
        painter: SunburstPainter(selectedIndex),
      ),
    );
  }
}

class SunburstPainter extends CustomPainter {
  final int selectedIndex;

  SunburstPainter(this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final levels = [
      ["Grandpa"],
      ["Father", "Uncle Leo"],
      ["Me", "Brother", "Cousin Ben", "Cousin Jack"],
    ];

    final colors = [
      const Color(0xFF5470C6),
      const Color(0xFF91CC75),
      const Color(0xFF5A5F7A),
      const Color(0xFFF7944D),
      const Color(0xFF2CB9FF),
      const Color(0xFF7B61FF),
    ];

    double startAngle = -pi / 2;

    int index = 0;

    for (int level = 0; level < levels.length; level++) {
      final radius = 40.0 + level * 40;
      final sweep = (2 * pi) / levels[level].length;

      for (int i = 0; i < levels[level].length; i++) {
        final paint = Paint()
          ..color = index == selectedIndex
              ? colors[index % colors.length]
              : colors[index % colors.length].withValues(alpha: 0.2);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          true,
          paint,
        );

        // 👇 TEXT
        final textPainter = TextPainter(
          text: TextSpan(
            text: levels[level][i],
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        final angle = startAngle + sweep / 2;

        final offset = Offset(
          center.dx + (radius - 20) * cos(angle),
          center.dy + (radius - 20) * sin(angle),
        );

        textPainter.paint(canvas, offset);

        startAngle += sweep;
        index++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
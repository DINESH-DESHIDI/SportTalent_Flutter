import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Sample chart data
  List<FlSpot> _generateChartData() {
    return [
      FlSpot(0, 78),
      FlSpot(1, 80),
      FlSpot(2, 85),
      FlSpot(3, 82),
      FlSpot(4, 90),
    ];
  }

  Widget _metricCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minWidth: 120),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF34495e))),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _achievementBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        border: Border.all(color: const Color(0xFFF39C12)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD35400)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Header
              const Text(
                "Athlete Dashboard",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Graph Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFBBBBBB), width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Colors.white,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine: (value) => FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              final labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];
                              if (value.toInt() < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(labels[value.toInt()],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54)),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text("${value.toInt()}",
                                  style: const TextStyle(fontSize: 12, color: Colors.black54));
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateChartData(),
                          isCurved: true,
                          gradient: LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)]),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF27AE60).withOpacity(0.3),
                                Colors.transparent
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Metrics
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFC),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Key Metrics",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metricCard("Stamina", "78%", const Color(0xFF27AE60)),
                        const SizedBox(width: 12),
                        _metricCard("Strength", "85%", const Color(0xFF27AE60)),
                        const SizedBox(width: 12),
                        _metricCard("Speed", "72%", const Color(0xFF27AE60)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Achievements
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFC),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Achievements",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    _achievementBadge("🥉 Bronze Push-up Champion"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

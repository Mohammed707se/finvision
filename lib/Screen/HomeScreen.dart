// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'AddOrder.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Color(0xff4318FF), // Dark blue section
        value: 63, // Adjust the value as needed
        title: '',
        radius: 50, // Adjust the size of the section
      ),
      PieChartSectionData(
        color: Color(0xffEFF4FB), // White section
        value: 25,
        title: '',
        radius: 50,
      ),
    ];
  }

  bool isContentChanged = false;

  void changeContent() {
    setState(() {
      isContentChanged = true;
    });
  }

  void revertContent() {
    setState(() {
      isContentChanged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: isContentChanged
          ? AddOrder(onBack: revertContent)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: changeContent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFF702DFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'اضافة طلب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  title: 'الإيرادات الشهرية',
                                  value: '42%+',
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatCard(
                                  title: 'المصارف التشغيلية',
                                  value: '10%+',
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatCard(
                                  title: 'صافي الأرباح',
                                  value: '33%-',
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 230,
                            child: DebtToAssetsGraph(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 220,
                      height: 340,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 4,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'مستوى المخاطر المالية',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: showingSections(),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Indicator(
                                    color: Color(0xff4318FF),
                                    text: 'مخاطر السيولة',
                                    isSquare: true,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '63%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xff4318FF),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Indicator(
                                    color: Color(0xffEFF4FB),
                                    text: 'مخاطر الائتمان',
                                    isSquare: true,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '25%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xff4318FF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pie chart and risk level section
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 400, // Provide fixed height for the pie chart
                        child: FinancialRiskTable(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
            borderRadius: BorderRadius.circular(180),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Container(
        // Removed fixed width to make it responsive
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffF4F7FE),
                borderRadius: BorderRadius.circular(180),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/png/shart.png',
                  width: 15,
                  height: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialRiskTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'جدول تقييم المخاطر المالية',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2B3674),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF4F7FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.more_horiz),
                  ),
                ),
              ],
            ),
          ),
          // Data Table with Tooltips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('نوع المخاطر')),
                DataColumn(label: Text('التاريخ')),
                DataColumn(label: Text('مستوى الخطر')),
                DataColumn(label: Text('الجهة المسؤولة')),
                DataColumn(label: Text('حالة الخطر')),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    // نوع المخاطر
                    DataCell(
                      Tooltip(
                        message:
                            'يشير إلى المخاطر المتعلقة بتدفق النقود في الشركة.',
                        child: Text('مخاطر التدفق النقدي'),
                      ),
                    ),
                    // التاريخ
                    DataCell(
                      Tooltip(
                        message: 'تاريخ تقييم هذا المخطر.',
                        child: Text('19 Jan 2024'),
                      ),
                    ),
                    // مستوى الخطر
                    DataCell(
                      Tooltip(
                        message: 'يُظهر مستوى الخطر الحالي بنسبة مئوية.',
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          value: 0.9,
                          color: Colors.red,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    // الجهة المسؤولة
                    DataCell(
                      Tooltip(
                        message: 'الجهة المسؤولة عن مراقبة وإدارة هذا المخطر.',
                        child: Text('الإدارة المالية'),
                      ),
                    ),
                    // حالة الخطر
                    DataCell(
                      Tooltip(
                        message:
                            'يوضح حالة الخطر الحالية سواء كانت مستقرة أو نشطة.',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(
                              width: 10,
                            ),
                            Text('مستقر'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    // نوع المخاطر
                    DataCell(
                      Tooltip(
                        message:
                            'يشير إلى المخاطر المرتبطة بالتركيز الائتماني.',
                        child: Text('مخاطر الائتمان'),
                      ),
                    ),
                    // التاريخ
                    DataCell(
                      Tooltip(
                        message: 'تاريخ تقييم هذا المخطر.',
                        child: Text('18 Apr 2024'),
                      ),
                    ),
                    // مستوى الخطر
                    DataCell(
                      Tooltip(
                        message: 'يُظهر مستوى الخطر الحالي بنسبة مئوية.',
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          value: 0.3,
                          color: Colors.green,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    // الجهة المسؤولة
                    DataCell(
                      Tooltip(
                        message: 'الجهة المسؤولة عن مراقبة وإدارة هذا المخطر.',
                        child: Text('الإدارة المالية'),
                      ),
                    ),
                    // حالة الخطر
                    DataCell(
                      Tooltip(
                        message:
                            'يوضح حالة الخطر الحالية سواء كانت مستقرة أو نشطة.',
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(
                              width: 10,
                            ),
                            Text('نشط'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    // نوع المخاطر
                    DataCell(
                      Tooltip(
                        message:
                            'يشير إلى المخاطر الناتجة عن تغييرات القوانين واللوائح.',
                        child: Text('مخاطر السيولة'),
                      ),
                    ),
                    // التاريخ
                    DataCell(
                      Tooltip(
                        message: 'تاريخ تقييم هذا المخطر.',
                        child: Text('20 May 2024'),
                      ),
                    ),
                    // مستوى الخطر
                    DataCell(
                      Tooltip(
                        message: 'يُظهر مستوى الخطر الحالي بنسبة مئوية.',
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          value: 0.8,
                          color: Colors.red,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    // الجهة المسؤولة
                    DataCell(
                      Tooltip(
                        message: 'الجهة المسؤولة عن مراقبة وإدارة هذا المخطر.',
                        child: Text('الإدارة التشغيلية'),
                      ),
                    ),
                    // حالة الخطر
                    DataCell(
                      Tooltip(
                        message:
                            'يوضح حالة الخطر الحالية سواء كانت مستقرة أو نشطة.',
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(
                              width: 10,
                            ),
                            Text('تمت المراقبة'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    // نوع المخاطر
                    DataCell(
                      Tooltip(
                        message:
                            'يشير إلى المخاطر المتعلقة بتدفق النقود في الشركة.',
                        child: Text('مخاطر الائتمان'),
                      ),
                    ),
                    // التاريخ
                    DataCell(
                      Tooltip(
                        message: 'تاريخ تقييم هذا المخطر.',
                        child: Text('12 Jul 2024'),
                      ),
                    ),
                    // مستوى الخطر
                    DataCell(
                      Tooltip(
                        message: 'يُظهر مستوى الخطر الحالي بنسبة مئوية.',
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          value: 0.6,
                          color: Colors.yellow,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    // الجهة المسؤولة
                    DataCell(
                      Tooltip(
                        message: 'الجهة المسؤولة عن مراقبة وإدارة هذا المخطر.',
                        child: Text('قسم التسويق'),
                      ),
                    ),
                    // حالة الخطر
                    DataCell(
                      Tooltip(
                        message:
                            'يوضح حالة الخطر الحالية سواء كانت مستقرة أو نشطة.',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(
                              width: 10,
                            ),
                            Text('مستقر'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    // نوع المخاطر
                    DataCell(
                      Tooltip(
                        message:
                            'يشير إلى المخاطر التي لا تندرج تحت التصنيفات الأخرى.',
                        child: Text('مخاطر أخرى'),
                      ),
                    ),
                    // التاريخ
                    DataCell(
                      Tooltip(
                        message: 'تاريخ تقييم هذا المخطر.',
                        child: Text('12 Jul 2024'),
                      ),
                    ),
                    // مستوى الخطر
                    DataCell(
                      Tooltip(
                        message: 'يُظهر مستوى الخطر الحالي بنسبة مئوية.',
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          value: 0.6,
                          color: Colors.yellow,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    // الجهة المسؤولة
                    DataCell(
                      Tooltip(
                        message: 'الجهة المسؤولة عن مراقبة وإدارة هذا المخطر.',
                        child: Text('الإدارة التشغيلية'),
                      ),
                    ),
                    // حالة الخطر
                    DataCell(
                      Tooltip(
                        message:
                            'يوضح حالة الخطر الحالية سواء كانت مستقرة أو نشطة.',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(
                              width: 10,
                            ),
                            Text('مستقر'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DebtToAssetsGraph extends StatefulWidget {
  @override
  _DebtToAssetsGraphState createState() => _DebtToAssetsGraphState();
}

class _DebtToAssetsGraphState extends State<DebtToAssetsGraph>
    with SingleTickerProviderStateMixin {
  final List<Color> gradientColors1 = [
    const Color(0xff6a11cb),
    const Color(0xff2575fc),
  ];

  final List<Color> gradientColors2 = [
    const Color(0xffff8a00),
    const Color(0xffff5200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'نسبة المديونية إلى الأصول',
                style: TextStyle(
                  color: Color(0xff213A7B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: LineChart(
              mainData(),
              // إزالة swapAnimationDuration و swapAnimationCurve لأنهما غير معرفين في الإصدار 0.69.0
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 2,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              String text;
              switch (value.toInt()) {
                case 0:
                  text = 'Jan';
                  break;
                case 2:
                  text = 'Feb';
                  break;
                case 4:
                  text = 'Mar';
                  break;
                case 6:
                  text = 'Apr';
                  break;
                case 8:
                  text = 'May';
                  break;
                case 10:
                  text = 'Jun';
                  break;
                case 12:
                  text = 'Jul';
                  break;
                default:
                  return Container();
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(text, style: style),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              return Text('${value.toInt()}k', style: style);
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        // الخط الأول
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2, 2),
            FlSpot(4, 5),
            FlSpot(6, 3.1),
            FlSpot(8, 4),
            FlSpot(10, 3),
            FlSpot(12, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors1,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: gradientColors1.last,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors1
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        // الخط الثاني
        LineChartBarData(
          spots: [
            FlSpot(0, 2),
            FlSpot(2, 3),
            FlSpot(4, 2.5),
            FlSpot(6, 4),
            FlSpot(8, 3),
            FlSpot(10, 4),
            FlSpot(12, 3),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors2,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: gradientColors2.last,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors2
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
      // تفعيل تلميحات اللمس
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.x.toInt()}月: ${spot.y}k',
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// Placeholder for risk level section
class RiskLevelSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text('Risk Level Section Placeholder'),
      ),
    );
  }
}

// Placeholder for risk evaluation table
class RiskEvaluationTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'جدول تقييم المخاطر المالية',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Placeholder for table content
          Text('Table Placeholder'),
        ],
      ),
    );
  }
}

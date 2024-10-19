// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart'; // مكتبة الرسوم البيانية

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // الجذر الأساسي للتطبيق
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تحليل المخاطر المالية',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddOrder(onBack: () {}),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddOrder extends StatefulWidget {
  final VoidCallback onBack;

  const AddOrder({super.key, required this.onBack});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  int currentStep = 0;
  bool isLoading = false;
  Map<String, dynamic>? reportData;

  void nextStep() {
    setState(() {
      if (currentStep < 3) {
        currentStep++;
      }
    });
  }

  void beforeStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
      }
    });
  }

  Widget buildStepContent() {
    switch (currentStep) {
      case 0:
        return Part1(
          onNextStep: handleNextStep,
          onPreviousStep: beforeStep,
        );
      case 1:
        // يمكنك إضافة خطوات إضافية هنا إذا لزم الأمر
        return Center(child: Text('خطوة ثانية (غير مضافة)'));
      case 2:
        return FinalReport(data: reportData);
      case 3:
        return RecommendationsWidget(data: reportData?['financialRisks']);
      default:
        return Center(child: Text('محتوى غير معروف'));
    }
  }

  Widget buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildStepIndicatorItem("1", "تحميل البيانات", currentStep >= 0),
        buildStepArrow(),
        buildStepIndicatorItem("2", "تحليل البيانات المالية", currentStep >= 1),
        buildStepArrow(),
        buildStepIndicatorItem("3", "التقرير المالي", currentStep >= 2),
        buildStepArrow(),
        buildStepIndicatorItem("4", "التوصيات المخصصة", currentStep >= 3),
      ],
    );
  }

  Widget buildStepIndicatorItem(String number, String title, bool isActive) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: isActive ? Color(0xffF28B26) : Color(0xffCED4DA),
          radius: 10,
          child: Text(
            number,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Color(0xffF28B26) : Color(0xff6C757D),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget buildStepArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Icon(
        Icons.keyboard_arrow_left_rounded,
        color: Colors.grey[400],
        size: 30,
      ),
    );
  }

  List<UploadedFile> _uploadedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'csv', 'xlsx'],
    );

    if (result != null) {
      setState(() {
        _uploadedFiles = result.files
            .map((file) => UploadedFile(
                  name: file.name,
                  bytes: file.bytes,
                ))
            .toList();
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  // دالة لمعالجة الضغط على زر التالي في الخطوة الأولى
  Future<void> handleNextStep() async {
    if (_uploadedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى رفع الملفات قبل المتابعة')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // تشفير محتويات الملفات إلى Base64
      List<Map<String, String>> filesData = [];
      for (var file in _uploadedFiles) {
        if (file.bytes != null) {
          String base64File = base64Encode(file.bytes!);
          filesData.add({
            'filename': file.name,
            'content': base64File,
          });
        } else {
          // التعامل مع الملفات الكبيرة أو الملفات بدون بيانات بايت
          filesData.add({
            'filename': file.name,
            'content': 'File too large to encode',
          });
        }
      }

      // بناء جسم الطلب باستخدام jsonEncode لضمان تنسيق JSON صحيح
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "أنت API توفر بيانات المخاطر المالية مع الرسوم البيانية بصيغة JSON لتستخدم في تطبيق Flutter Dart. يجب أن تتبع الردود البنية المحددة بشكل صارم كما هو موضح في السكيما."
            },
            {
              "role": "user",
              "content":
                  "أريد بيانات المخاطر المالية بصيغة JSON معيار ISO 31000 ، معيار COSO (Committee of Sponsoring Organizations of the Treadway Commission) ، معيار Basel III ، معيار IFRS 9 (International Financial Reporting Standard 9) ، معيار Solvency II ، ISO 22301 ، ISO 27001 ،معيار COBIT (Control Objectives for Information and Related Technologies) ، معيار SOX (Sarbanes-Oxley Act) ، معيار GRC (Governance, Risk Management, and Compliance) التي تتضمن مخاطر السيولة ومخاطر الديون، مع الوصف، مستوى التأثير، ثلاث توصيات، وقائمة بالحسابات المتأثرة تظهر قيم الدائن والمدين. بالإضافة إلى ذلك، أريد بيانات الرسوم البيانية بما في ذلك المخططات الدائرية والخطية، ويجب أن يتوافق الرد مع السكيما أدناه، واذا لم توجد احدى البيانات في الملف المرسل لك لا تكتبها وايضاً قم باتباع "
            },
            {
              "role": "user",
              "content":
                  "إليك السكيما المتوقعة للرد:\n\n${jsonEncode(expectedSchema)}\n\nتأكد من أن الرد يتبع هذه البنية بالضبط بدون تغيير ترتيب أو مفاتيح البيانات. يرجى تقديم الرد بصيغة JSON فقط بدون أي شرح أو تنسيقات إضافية."
            },
            {
              "role": "user",
              "content":
                  "الملفات المرفوعة:\n${filesData.map((file) => 'Filename: ${file['filename']}, Content: ${file['content']}').join('\n')}"
            }
          ]
        }),
      );

      // فك تشفير الجسم باستخدام UTF-8
      String decodedBody = utf8.decode(response.bodyBytes);
      print('Response Body: $decodedBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        print(data);
        final replyContent = data['choices'][0]['message']['content'];

        // التحقق من أن الرد ليس رسالة خطأ
        if (replyContent.contains('عذرًا') ||
            replyContent.contains('لا أستطيع')) {
          // عرض رسالة خطأ للمستخدم
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('الملفات غير صحيحة أو غير مفهومة ماليًا')),
          );
        } else {
          try {
            final parsedData = jsonDecode(replyContent);
            setState(() {
              reportData = parsedData;
              currentStep = 2;
            });
          } catch (e) {
            // محاولة استخراج JSON من داخل كتل الشيفرة إذا كان موجودًا
            final regex = RegExp(r'```json\s*([\s\S]*?)\s*```');
            final match = regex.firstMatch(replyContent);
            if (match != null && match.groupCount >= 1) {
              try {
                final jsonString = match.group(1)!;
                final parsedData = jsonDecode(jsonString);
                setState(() {
                  reportData = parsedData;
                  currentStep = 2;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('فشل في تحليل JSON من الرد')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('لم يتم العثور على JSON صالح في الرد')),
              );
            }
          }
        }
      } else {
        // التعامل مع الأخطاء من API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في الحصول على البيانات من API')),
        );
        print('Error: ${decodedBody}');
      }
    } catch (e) {
      // التعامل مع الاستثناءات العامة
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // تعريف السكيما المتوقعة
  final Map<String, dynamic> expectedSchema = {
    "riskReport": {
      "riskSize": {
        "title": "تقرير حجم المخاطر",
        "months": ["يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو"],
        "values": [0, 0, 0, 0, 0, 0],
        "highlightValue": {"month": "string", "percentage": 0}
      },
      "circularCharts": {
        "liquidityRisk": {"label": "مخاطر السيولة", "percentage": 0},
        "creditRisk": {"label": "مخاطر الديون", "percentage": 0}
      }
    },
    "liquidityDecline": {
      "title": "انخفاض السيولة",
      "percentage": 0,
      "cashFlow": 0,
      "timePeriods": [
        "string",
        "string",
        "string",
        "string",
        "string",
        "string",
        "string"
      ],
      "values": [0, 0, 0, 0, 0, 0, 0]
    },
    "riskTable": [
      {"riskType": "تدفق نقدي", "riskLevel": "مرتفع", "riskStatus": "حالي"},
      {"riskType": "سيولة", "riskLevel": "متوسط", "riskStatus": "مراقب"},
      {"riskType": "تأمين", "riskLevel": "منخفض", "riskStatus": "مستقبلي"}
    ],
    "financialRisks": [
      {"title": "string", "department": "string", "details": "string"},
      {"title": "string", "department": "string", "details": "string"},
      {"title": "string", "department": "string", "details": "string"}
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: IconButton(
                  onPressed: widget.onBack,
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'البدء بتحليل مالي جديد',
                  style: TextStyle(
                    color: Color(0xff1B2559),
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildStepIndicator(),
              SizedBox(height: 20),
              Row(
                children: [
                  if (currentStep < 2)
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: 100, // تم إزالة هذا السطر لأنه غير ضروري مع استخدام Expanded
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'بيانات التقرير',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    // يمكنك إضافة وظائف إضافية هنا إذا لزم الأمر
                                    // مثلاً: زر تحرير البيانات أو عرض تفاصيل إضافية
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 40),
                              GestureDetector(
                                onTap: _pickFiles,
                                child: Container(
                                  padding: EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Color(0xffFAFCFE),
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/png/upload.png', // تأكد من وجود الصورة
                                          width: 60,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'ارفع الملفات',
                                          style: TextStyle(
                                            color: Color(0xff702DFF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'PDF, CSV and XLSX files are allowed',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              if (_uploadedFiles.isNotEmpty) ...[
                                Text(
                                  'عدد الملفات المرفوعة: ${_uploadedFiles.length}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _uploadedFiles.length,
                                  itemBuilder: (context, index) {
                                    final file = _uploadedFiles[index];
                                    return ListTile(
                                      leading: Icon(Icons.insert_drive_file,
                                          color: Color(0xff702DFF)),
                                      title: Text(file.name),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _removeFile(index),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildStepContent(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

class FinalReport extends StatelessWidget {
  final Map<String, dynamic>? data;

  const FinalReport({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Center(child: Text('لا توجد بيانات لعرضها'));
    }

    // استخراج البيانات من السكيما
    final riskReport = data!['riskReport'];
    final liquidityDecline = data!['liquidityDecline'];
    final riskTable = data!['riskTable'];
    final financialRisks = data!['financialRisks'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التقرير النهائي للمخاطر المالية',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // عرض تقارير المخاطر المالية
            if (riskReport != null) ...[
              RiskReportWidget(riskReport: riskReport),
              SizedBox(height: 20),
            ],

            // عرض انخفاض السيولة
            if (liquidityDecline != null) ...[
              LiquidityDeclineWidget(data: liquidityDecline),
              SizedBox(height: 20),
            ],

            // عرض جدول المخاطر
            if (riskTable != null) ...[
              RiskTableWidget(data: riskTable),
              SizedBox(height: 20),
            ],

            // عرض المخاطر المالية
            if (financialRisks != null && financialRisks.isNotEmpty) ...[
              FinancialRisksWidget(data: financialRisks),
              SizedBox(height: 20),
            ],

            // زر عرض التقرير كامل وحفظه
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('عرض التقرير كامل'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xff702DFF),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xff702DFF)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: Text(
                    'رفع وحفظ التقرير',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff702DFF),
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

class RiskTableWidget extends StatelessWidget {
  final List<dynamic> data;

  const RiskTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Text('لا توجد بيانات لعرض جدول المخاطر');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'جدول المخاطر:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        DataTable(
          columns: [
            DataColumn(label: Text('نوع الخطر')),
            DataColumn(label: Text('مستوى الخطر')),
            DataColumn(label: Text('حالة الخطر')),
          ],
          rows: data.map<DataRow>((risk) {
            return DataRow(
              cells: [
                DataCell(Text(risk['riskType'] ?? '')),
                DataCell(Text(risk['riskLevel'] ?? '')),
                DataCell(Text(risk['riskStatus'] ?? '')),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class RiskReportWidget extends StatelessWidget {
  final Map<String, dynamic> riskReport;

  const RiskReportWidget({super.key, required this.riskReport});

  @override
  Widget build(BuildContext context) {
    final riskSize = riskReport['riskSize'];
    final circularCharts = riskReport['circularCharts'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تقرير المخاطر المالية',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        // عرض المخطط الخطي لحجم المخاطر
        if (riskSize != null) _buildRiskSizeChart(riskSize),

        SizedBox(height: 20),

        // عرض المخططات الدائرية
        if (circularCharts != null) _buildCircularCharts(circularCharts),
      ],
    );
  }

  // دالة لعرض مخطط حجم المخاطر
  Widget _buildRiskSizeChart(Map<String, dynamic> riskSize) {
    List<dynamic> months = riskSize['months'] ?? [];
    List<dynamic> values = riskSize['values'] ?? [];

    if (months.isEmpty || values.isEmpty) {
      return Text('لا توجد بيانات لعرض حجم المخاطر');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(riskSize['title'] ?? 'حجم المخاطر'),
        SizedBox(height: 10),
        _buildLineChart(months, values),
      ],
    );
  }

  // دالة لعرض المخططات الدائرية
  Widget _buildCircularCharts(Map<String, dynamic> circularCharts) {
    final liquidityRisk = circularCharts['liquidityRisk'];
    final creditRisk = circularCharts['creditRisk'];

    if (liquidityRisk == null || creditRisk == null) {
      return Text('لا توجد بيانات لعرض مخاطر السيولة والديون');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مخاطر السيولة والديون:'),
        SizedBox(height: 10),
        _buildPieChart(
          (liquidityRisk['percentage'] ?? 0).toDouble(),
          (creditRisk['percentage'] ?? 0).toDouble(),
          liquidityRisk['label'] ?? 'مخاطر السيولة',
          creditRisk['label'] ?? 'مخاطر الديون',
        ),
      ],
    );
  }

  // دالة لإنشاء مخطط خطي
  Widget _buildLineChart(List<dynamic> months, List<dynamic> values) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index < 0 || index >= months.length) return Text('');
                  return Text(months[index]);
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: values.asMap().entries.map((entry) {
                int index = entry.key;
                double value = (entry.value is int)
                    ? entry.value.toDouble()
                    : (entry.value is double)
                        ? entry.value
                        : 0.0;
                return FlSpot(index.toDouble(), value);
              }).toList(),
              isCurved: true,
              color: Colors.orange,
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  // دالة لإنشاء مخطط دائري
  Widget _buildPieChart(double liquidityRisk, double creditRisk,
      String liquidityLabel, String creditLabel) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.blue,
              value: liquidityRisk,
              title: '$liquidityLabel\n${liquidityRisk.toStringAsFixed(1)}%',
              radius: 80,
              titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: creditRisk,
              title: '$creditLabel\n${creditRisk.toStringAsFixed(1)}%',
              radius: 80,
              titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class LiquidityDeclineWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const LiquidityDeclineWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<dynamic> timePeriods = data['timePeriods'] ?? [];
    List<dynamic> values = data['values'] ?? [];

    if (timePeriods.isEmpty || values.isEmpty) {
      return Text('لا توجد بيانات لعرض انخفاض السيولة');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data['title'] ?? 'انخفاض السيولة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('النسبة: ${data['percentage'] ?? 0}%'),
        Text('التدفق النقدي: ${data['cashFlow'] ?? 0}'),
        SizedBox(height: 10),
        _buildLineChart(timePeriods, values),
      ],
    );
  }

  Widget _buildLineChart(List<dynamic> periods, List<dynamic> values) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index < 0 || index >= periods.length) return Text('');
                  return Text(periods[index]);
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: values.asMap().entries.map((entry) {
                int index = entry.key;
                double value = (entry.value is int)
                    ? entry.value.toDouble()
                    : (entry.value is double)
                        ? entry.value
                        : 0.0;
                return FlSpot(index.toDouble(), value);
              }).toList(),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialRisksWidget extends StatelessWidget {
  final List<dynamic> data;

  const FinancialRisksWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Text('لا توجد مخاطر مالية لعرضها');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المخاطر المالية:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...data.map((risk) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: Icon(Icons.warning, color: Colors.red),
              title: Text(risk['title'] ?? 'عنوان غير محدد'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('القسم: ${risk['department'] ?? 'غير محدد'}'),
                  Text('التفاصيل: ${risk['details'] ?? 'غير محدد'}'),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class RecommendationsWidget extends StatelessWidget {
  final List<dynamic>? data;

  const RecommendationsWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null || data!.isEmpty) {
      return Center(child: Text('لا توجد توصيات لعرضها'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التوصيات المخصصة:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...data!.map((recommendation) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(recommendation['title'] ?? 'توصية غير محددة'),
              subtitle: Text(recommendation['details'] ?? ''),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class Part1 extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;

  const Part1({
    required this.onNextStep,
    required this.onPreviousStep,
    super.key,
  });

  @override
  _Part1State createState() => _Part1State();
}

class _Part1State extends State<Part1> {
  // TextEditingControllers for form fields
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController floorsController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController unitsController = TextEditingController();
  TextEditingController designTypeController = TextEditingController();
  TextEditingController usageController = TextEditingController();

  bool isLocked = false;

  String propertyType = 'سكني';

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      // هنا يمكنك قراءة الملف واستخراج البيانات لملء الحقول
      // لهذا المثال، سنملأ بعض البيانات الوهمية
      setState(() {
        registrationNumberController.text = "تم تحميل الملفات";
        locationController.text = "تم تحميل الملفات";
        floorsController.text = "تم تحميل الملفات";
        dateController.text = "تم تحميل الملفات";
        unitsController.text = "تم تحميل الملفات";
        designTypeController.text = "تم تحميل الملفات";
        usageController.text = "تم تحميل الملفات";
        isLocked = true;
      });

      Navigator.of(context).pop(); // إغلاق الحوار بعد اختيار الملف
    } else {
      // تم إلغاء اختيار الملف
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity, // تم إزالة هذا السطر لأنه غير ضروري مع استخدام Expanded
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'بيانات عامة',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ارفاق ملف العقار',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.folder,
                                            color: Color(0xff702DFF),
                                            size: 50,
                                          ),
                                          SizedBox(height: 10),
                                          Text('الضغط على أدناه لرفع الملفات'),
                                          TextButton(
                                            onPressed: () => _pickFile(context),
                                            child: Text(
                                              'تصفح الملفات',
                                              style: TextStyle(
                                                  color: Color(0xff702DFF)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'التالي',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff702DFF),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'إلغاء',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff702DFF),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ارفاق ملف عقار',
                          style: TextStyle(
                            color: Color(0xff702DFF),
                          ),
                        ),
                        Icon(
                          Icons.file_upload_outlined,
                          color: Color(0xff702DFF),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                children: [
                  buildTextField(
                      'الإيرادات الشهرية', registrationNumberController),
                  buildTextField('المصروفات الشهرية', locationController),
                  buildDropdownField(
                    'الديون المستحقة',
                    propertyType,
                    ['سكني', 'تجاري', 'أربطة'],
                    (String? newValue) {
                      setState(() {
                        propertyType = newValue!;
                      });
                    },
                  ),
                  buildTextField('الأصول الحالية', floorsController),
                  buildTextField('المدفوعات المتأخرة', unitsController),
                  buildTextField('الميزانية العمومية', designTypeController),
                  buildTextField('بيان التدفقات النقدية', usageController),
                  buildTextField(
                      'تقارير الأداء المالي السابقة', usageController),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: widget.onPreviousStep,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xff702DFF),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xff702DFF)),
                  ),
                  child: Text('السابق'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: widget.onNextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff702DFF),
                  ),
                  child: Text(
                    'التالي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xff6C757D),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: !isLocked, // تعطيل الحقل إذا كانت الحقول مقفلة
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: isLocked ? 'تم تحميل الملفات' : null,
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField(String label, String selectedValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Color(0xff6C757D)),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: isLocked ? null : onChanged,
          disabledHint: Text('تم تحميل الملفات'),
        ),
      ],
    );
  }

  Widget buildDateField(
      String label, BuildContext context, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Color(0xff6C757D)),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    controller.text = "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

// تعريف UploadedFile
class UploadedFile {
  final String name;
  final Uint8List? bytes;

  UploadedFile({required this.name, this.bytes});
}

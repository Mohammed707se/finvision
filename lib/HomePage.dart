// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Screen/HomeScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedMenuItem = 0;
  bool _isCollapsed = false; // متغير الحالة الجديد لتعقب حالة الشريط الجانبي

  // دالة لتغيير حالة العنصر المحدد في القائمة
  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedMenuItem = index;
    });
  }

  // دالة لتبديل حالة الشريط الجانبي بين مطوي وموسع
  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  // دالة لبناء عنصر القائمة مع دعم الطي
  Widget _buildMenuItem(int index, String svgPath, String title) {
    bool isSelected = _selectedMenuItem == index;

    // تحديد ما إذا كان يجب تغيير لون الأيقونة
    bool shouldChangeIconColor = !(index == 1 || index == 2);

    return GestureDetector(
      onTap: () => _onMenuItemSelected(index),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff702DFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: _isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  svgPath,
                  color:
                      isSelected && shouldChangeIconColor ? Colors.white : null,
                ),
                if (!_isCollapsed) ...[
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة لبناء المحتوى الرئيسي بناءً على العنصر المحدد
  Widget _buildContent() {
    switch (_selectedMenuItem) {
      case 0:
        return Homescreen();
      case 1:
        return RealEstate();
      case 2:
        return Center(
          child: Text(
            'محتوى سجل التقارير',
            style: TextStyle(fontSize: 24),
          ),
        );
      case 3:
        return Center(
          child: Text(
            'محتوى الإعدادات',
            style: TextStyle(fontSize: 24),
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(''),
      ),
      body: Row(
        children: [
          // استخدام AnimatedContainer لتسهيل انتقال عرض الشريط الجانبي
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: MediaQuery.of(context).size.height,
            width: _isCollapsed ? 80 : 250, // تغيير العرض بناءً على الحالة
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                // عرض الشعار بحجم مختلف بناءً على حالة الشريط الجانبي
                _isCollapsed
                    ? Image.asset(
                        'assets/png/Logo_mini.png',
                        width: 40,
                        height: 40,
                      )
                    : Image.asset(
                        'assets/png/logo.png',
                        width: 200,
                      ),
                SizedBox(
                  height: 50,
                ),
                // بناء عناصر القائمة
                _buildMenuItem(0, 'assets/svg/Home.svg', 'الصفحة الرئيسية'),
                SizedBox(
                  height: 10,
                ),
                _buildMenuItem(1, 'assets/svg/Document.svg', 'التحليل المالي'),
                SizedBox(
                  height: 10,
                ),
                _buildMenuItem(
                    2, 'assets/svg/Document.svg', 'التقارير المالية'),
                SizedBox(
                  height: 10,
                ),
                _buildMenuItem(3, 'assets/svg/Report.svg', 'المستشار الذكي'),
                SizedBox(
                  height: 10,
                ),
                _buildMenuItem(4, 'assets/svg/Setting.svg', 'الإعدادات'),
                Spacer(),
                Divider(),
                // زر التبديل بين الطي والتوسيع
                IconButton(
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios,
                    size: 20,
                  ),
                  onPressed: _toggleSidebar,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          // المحتوى الرئيسي
          Expanded(
            child: Center(
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}

// باقي الكود كما هو دون تغيير
class RealEstate extends StatefulWidget {
  const RealEstate({super.key});

  @override
  _RealEstateState createState() => _RealEstateState();
}

class _RealEstateState extends State<RealEstate> {
  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        height: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(38.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'العقارات الطسجلة',
                        style: TextStyle(
                          color: Color(0xff702DFF),
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: selectedImagePath != null
                            ? DeatilsProblome(
                                selectedImagePath: selectedImagePath)
                            : DataTable(
                                columnSpacing: 20.0,
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'اسم العقار',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'نوع الصيانة',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'نوع المشكلة',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'تاريخ ظهور المشكلة',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'التكلفة المتوقعة',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'حالة الصيانة',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedImagePath =
                                                  'assets/png/p1.png';
                                            });
                                          },
                                          child: Text('شقة 31'),
                                        ),
                                      ),
                                      DataCell(Text('صيانة طارئة')),
                                      DataCell(Text('تسرب مياه')),
                                      DataCell(Text('10 أغسطس 2024')),
                                      DataCell(Text('1500 ريال سعودي')),
                                      DataCell(Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'منتهي',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                    ],
                                  ),
                                  DataRow(
                                    cells: [
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedImagePath =
                                                  'assets/png/p1.png';
                                            });
                                          },
                                          child: Text('شقة 66'),
                                        ),
                                      ),
                                      DataCell(Text('صيانة دورية')),
                                      DataCell(Text('تشقق في الجدران')),
                                      DataCell(Text('15 يوليو 2024')),
                                      DataCell(Text('2500 ريال سعودي')),
                                      DataCell(Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'منتهي',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeatilsProblome extends StatelessWidget {
  const DeatilsProblome({
    super.key,
    required this.selectedImagePath,
  });

  final String? selectedImagePath;

  Future<dynamic> report(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'تقرير الوحدة السكنية رقم 31',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 300,
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 100),
                                                  Text(
                                                    'يحتاج لاصلاح عاجل جدا',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/svg/danger.svg',
                                                    width: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 110,
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Color(0xffECECEC),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'حالة المشكلة',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'تشقق الجدران يمثل خطرًا كبيرًا على سلامة المنزل وأهله. هذه التشققات قد تشير إلى مشاكل هيكلية خطيرة مثل ضعف أساسات المبنى...',
                                            style: TextStyle(
                                              fontSize: 26,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Container(
                                          width: 60,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Color(0xffE0D1FF),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'الملفات',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.attach_file),
                                                SizedBox(width: 8),
                                                Text(
                                                    'صور جدران تقرير الوحدة السكنية رقم 31'),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.attach_file),
                                                SizedBox(width: 8),
                                                Text(
                                                    'صور جدران تقرير الوحدة السكنية رقم 31'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'جهات يمكنها حل المشكلة',
                                            style: TextStyle(
                                              color: Color(0xff687A92),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(4, (index) {
                                            return Column(
                                              children: [
                                                Icon(Icons.business, size: 40),
                                                Text('شركة مقاولات'),
                                              ],
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 470,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListView(
                                    children: [],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      onSubmitted: (text) {
                                        (text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'اكتب سؤالك هنا...',
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              report(context);
            },
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(selectedImagePath!),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'رطوبه في الجدار',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'شق في الجدار',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      child: Text(
                        'الجدار يظهر عليه تقشر واضح في الطلاء مع وجود علامات رطوبة، مما يشير إلى تسرب المياه أو ارتفاع نسبة الرطوبة في المنطقة.',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

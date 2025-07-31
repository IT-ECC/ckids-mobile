import 'package:eccmobile/component/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClickTicketScreen extends StatefulWidget {
  const ClickTicketScreen({super.key});

  @override
  State<ClickTicketScreen> createState() => _ClickTicketScreenState();
}

class _ClickTicketScreenState extends State<ClickTicketScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
              height: 42.h,
              decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r))),
              child: TabBar(
                labelColor: Colors.black,
                indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(30.r))),
                automaticIndicatorColorAdjustment: false,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Active',
                  ),
                  Tab(
                    text: 'History',
                  ),
                ],
              )),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Text('Event not foundd'),
                Container(
                  height: 129.h,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) => Container(
                      height: 552.h,
                      margin: EdgeInsets.only(top: 32.h),
                      padding: EdgeInsets.symmetric(horizontal: 34.w),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          margin: EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 15.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(60.r)),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                'Christmas Eve',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 11.h,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Vector Robinson',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Place',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'ECC Bandung',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '24-12-2022',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '17.00 - 21.00 WIB',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 9.h,
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: QrButton(data: ''),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

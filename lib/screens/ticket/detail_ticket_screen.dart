import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTicketScreen extends StatefulWidget {
  const DetailTicketScreen({super.key});

  @override
  State<DetailTicketScreen> createState() => _DetailTicketScreenState();
}

class _DetailTicketScreenState extends State<DetailTicketScreen>
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
                    itemCount: 7,
                    itemBuilder: (context, index) => Container(
                      height: 128.h,
                      margin: EdgeInsets.only(top: 32.h),
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15,
                                    width: 88,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                  ),
                                  Container(
                                    width: 88.w,
                                    child: Text(
                                      'Christmas Eve',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    '24.12 - 2022',
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                  Text('17.00- 22.00 WIB',
                                      style: TextStyle(fontSize: 11.sp))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 25.h, left: 18.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Vector Robinson',
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Registered 14-02-2022',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                    Text(
                                      'RP 25.000',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 14.w),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_city,
                                              size: 11.h,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Gereja',
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.grey),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.person,
                                              size: 11.h,
                                            ),
                                            Text('Members',
                                                style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
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

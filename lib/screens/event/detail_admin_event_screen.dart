import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:eccmobile/data/models/family_selected.dart';
import 'package:eccmobile/data/models/response/participant_response.dart';
import 'package:eccmobile/data/models/response/person_event_response.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/screens/home/home_screen.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../component/app_colors.dart';

// TODO : Implement [https://ckids.iqbalhamsyah.id/api/v1/events/list-person?event_id=53f5e0d3-bc5f-4855-b4bf-ba8b739334e8]

class DetailAdminEventScreen extends StatefulWidget {
  final EventResponse eventResponse;
  const DetailAdminEventScreen({Key? key, required this.eventResponse})
      : super(key: key);

  @override
  State<DetailAdminEventScreen> createState() => _DetailAdminEventScreenState();
}

class _DetailAdminEventScreenState extends State<DetailAdminEventScreen>
    with TickerProviderStateMixin {
  final sl = GetIt.instance;
  int indexParticipant = 0;
  late TabController _tabController;
  late EventBloc eventBloc;

  @override
  void initState() {
    super.initState();
    eventBloc = sl();
    eventBloc.add(EventGetListPerson(eventId: widget.eventResponse.id));

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  final Widget defaultWidget = Container(
    alignment: Alignment.center,
    child: const Center(
        child: Text('List Participants Data Not Found',
            textAlign: TextAlign.center)),
  );

  final Widget loadingWidget = Container(
    alignment: Alignment.center,
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  Future<void> scanQR(EventState eventState) async {
    if (eventState is EventStateGetListPerson) {
      try {
        await FlutterBarcodeScanner.scanBarcode(
                '#ff6666', 'Cancel', true, ScanMode.QR)
            .then((value) {
          eventBloc.add(EventScanQUser(
              eventId: widget.eventResponse.id,
              personId: value,
              listParticipantsResponse: eventState.listParticipantsResponse));
        });
      } on PlatformException {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Failed to scan barcode'),
        ));
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Failed to scan barcode'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: false,
      child: BlocListener<EventBloc, EventState>(
        bloc: eventBloc,
        listener: (context, EventState eventState) {
          if (eventState is EventStateScanQRUser) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              content: Text(eventState.message),
            ));

            eventBloc.add(EventGetListPerson(eventId: widget.eventResponse.id));
          } else if (eventState is EventStateError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text(eventState.message),
            ));
          }
        },
        child: BlocBuilder<EventBloc, EventState>(
          bloc: eventBloc,
          builder: (context, EventState eventState) {
            return Scaffold(
              backgroundColor: AppColors.whiteSmoke,
              body: buildBodyStack(eventState),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, left: 20),
                    decoration:
                        BoxDecoration(color: AppColors.white, boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: (eventState is EventStateLoading)
                                    ? null
                                    : () => scanQR(eventState),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.qr_code_scanner,
                                        color: AppColors.white,
                                        size: Dimensions.ICON_SIZE_LARGE),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Scan Barcode',
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimensions
                                              .FONT_SIZE_MEDIUM_EXTRA_LARGE),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBodyStack(EventState eventState) {
    return Stack(
      children: [
        buildHeaderBody(),
        Padding(
            padding: const EdgeInsets.only(top: 200),
            child: buildBody(eventState)),
      ],
    );
  }

  Widget buildBody(EventState eventState) {
    List<ParticipantResponse> listCheckin = [];
    List<ParticipantResponse> listCheckout = [];
    if (eventState is EventStateGetListPerson) {
      listCheckin = eventState.listCheckin;
      listCheckout = eventState.listCheckout;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSmoke,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 55.h,
            decoration: BoxDecoration(
                color: AppColors.waxFlower,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r))),
            child: TabBar(
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.black,
              indicator: BoxDecoration(
                  color: AppColors.cadmiumOrange,
                  borderRadius: (_tabController.index == 0)
                      ? BorderRadius.only(topLeft: Radius.circular(30.r))
                      : BorderRadius.only(topRight: Radius.circular(30.r))),
              automaticIndicatorColorAdjustment: false,
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              controller: _tabController,
              tabs: [
                Tab(
                  text: 'Check In (${listCheckin.length})',
                ),
                Tab(
                  text: 'Check Out (${listCheckout.length})',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: (eventState is EventStateLoading)
                  ? [loadingWidget, loadingWidget]
                  : [
                      (eventState is EventStateGetListPerson)
                          ? buildListCheckin(eventState)
                          : defaultWidget,
                      (eventState is EventStateGetListPerson)
                          ? buildListCheckout(eventState)
                          : defaultWidget
                    ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildListCheckin(EventStateGetListPerson eventState) {
    return (eventState.listCheckin.isEmpty)
        ? defaultWidget
        : ListView.builder(
            itemCount: eventState.listCheckin.length,
            itemBuilder: (context, index) {
              final ParticipantResponse participanResponse =
                  eventState.listCheckin[index];

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, familyProfileScreen, arguments: {
                    //   'familyResponse': familyResponse
                    // });
                  },
                  child: HomeCard(
                    image: participanResponse.photo,
                    name: participanResponse.name,
                    familyrole: '-',
                    birthdate:
                        "Check In : ${participanResponse.checkinTimeFormatted}",
                  ),
                ),
              );
            },
          );
  }

  Widget buildListCheckout(EventStateGetListPerson eventState) {
    return (eventState.listCheckout.isEmpty)
        ? defaultWidget
        : ListView.builder(
            itemCount: eventState.listCheckout.length,
            itemBuilder: (context, index) {
              final ParticipantResponse participanResponse =
                  eventState.listCheckout[index];

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, familyProfileScreen, arguments: {
                    //   'familyResponse': familyResponse
                    // });
                  },
                  child: HomeCard(
                    image: participanResponse.photo,
                    name: participanResponse.name,
                    familyrole: '-',
                    birthdate:
                        "Check Out : ${participanResponse.checkoutTimeFormatted}",
                  ),
                ),
              );
            },
          );
  }

  Widget buildHeaderBody() {
    final double positionWidget = MediaQuery.of(context).size.height / 5.5;

    return Stack(
      children: [
        SizedBox(
            height: 350.h,
            child: Image.network(
              widget.eventResponse.photo,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: AppColors.black.withOpacity(0.6),
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/icons/contoh.png',
                  fit: BoxFit.cover,
                );
              },
            )),
        Positioned(
            left: 20.h,
            top: 40.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
                  decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    padding: const EdgeInsets.only(right: 2),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: Dimensions.ICON_SIZE_SMALL,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )),
        Positioned(
          left: 80.h,
          top: 60.h,
          right: 20.h,
          child: Text(widget.eventResponse.title,
              maxLines: 3,
              textAlign: TextAlign.right,
              style: montserratBold.copyWith(
                  color: AppColors.cadmiumOrange,
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
        ),
        Positioned(
          left: 20.h,
          right: 20.h,
          top: positionWidget,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin,
                          color: AppColors.white,
                          size: Dimensions.ICON_SIZE_EXTRA_SMALL),
                      const SizedBox(width: 5),
                      Text(widget.eventResponse.place,
                          style: montserratRegular.copyWith(
                              color: AppColors.white,
                              fontSize: Dimensions.FONT_SIZE_SMALL)),
                    ],
                  ),
                  Text(widget.eventResponse.visitorMember,
                      style: montserratRegular.copyWith(
                          color: AppColors.white,
                          fontSize: Dimensions.FONT_SIZE_SMALL)),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.cadmiumOrange),
                    borderRadius: const BorderRadius.all(Radius.circular(40))),
                child: LinearPercentIndicator(
                  padding: const EdgeInsets.all(0),
                  barRadius: const Radius.circular(40),
                  animation: true,
                  lineHeight: 5.0,
                  animationDuration: 1500,
                  percent: widget.eventResponse.percentVisitorMember,
                  progressColor: AppColors.cadmiumOrange,
                  backgroundColor: AppColors.whiteSmoke.withOpacity(0.4),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

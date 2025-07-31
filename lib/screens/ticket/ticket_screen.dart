import 'package:cached_network_image/cached_network_image.dart';
import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/screens/event/event_screen.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../component/app_colors.dart';

// TODO : RefreshIndicator not working
class TicketScreen extends StatefulWidget {
  final EventBloc eventBloc;
  final bool isAdmin;
  TicketScreen({Key? key, required this.eventBloc, required this.isAdmin})
      : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return CustomScreen(
      withoutPadding: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTabBar(),
          const SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildListTicketActive(),

                // TODO : Implement history ticket
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 1.33,
                  child: const Center(child: Text('Event History Not Found')),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
          color: AppColors.whiteSmoke,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
      child: TabBar(
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.black,
        indicator: BoxDecoration(
            color: AppColors.waxFlower,
            borderRadius: (_tabController.index == 0)
                ? BorderRadius.only(topLeft: Radius.circular(30.r))
                : BorderRadius.only(topRight: Radius.circular(30.r))),
        automaticIndicatorColorAdjustment: false,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        controller: _tabController,
        tabs: const [
          Tab(
            text: 'Active',
          ),
          Tab(
            text: 'History',
          ),
        ],
      ),
    );
  }

  Widget buildListTicketActive() {
    final double defaultHeight = MediaQuery.of(context).size.height / 1.33;

    return BlocBuilder<EventBloc, EventState>(
      bloc: widget.eventBloc,
      builder: (context, EventState eventState) {
        final Widget defaultWidget = Container(
          alignment: Alignment.center,
          height: defaultHeight,
          child: const Center(child: Text('Event Active Not Found')),
        );

        final Widget loadingWidget = Container(
          alignment: Alignment.center,
          height: defaultHeight,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );

        if (eventState is EventStateLoading) {
          return loadingWidget;
        } else {
          if (eventState is EventStateGetList) {
            if (eventState.listEventResponseBooked.isEmpty) {
              return defaultWidget;
            }

            return ListView(
              children: eventState.listEventResponseBooked
                  .map((EventResponse eventResponse) {
                return TicketCard(eventResponse: eventResponse);
              }).toList(),
            );

            // return ListView.builder(
            //   itemCount: eventState.listEventResponseBooked.length,
            //   itemBuilder: (context, index) {
            //     final EventResponse eventResponse = eventState.listEventResponseBooked[index];
            //
            //     return Text('data');
            //
            //     //return TicketCard(eventResponse: eventResponse);
            //   },
            // );
          } else {
            return defaultWidget;
          }
        }

        return defaultWidget;
      },
    );
  }
}

class TicketCard extends StatelessWidget {
  final EventResponse eventResponse;

  const TicketCard({
    required this.eventResponse,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/card_ticket_active.png',
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
          ),
          Positioned(
              top: 24.h,
              left: 48.w,
              child: Container(
                height: 125.h,
                width: 115.w,
                margin: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: eventResponse.photo,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //placeholder: (context, url) => LoadingWidget.loadingRingImage,
                    errorWidget: (context, url, error) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/logo.png'))),
                      );
                    },
                  ),
                ),
              )),
          Positioned(
            top: 22.h,
            left: 180.w,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventResponse.title,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: montserratBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_pin,
                          size: Dimensions.ICON_SIZE_EXTRA_SMALL),
                      const SizedBox(width: 5),
                      Text(eventResponse.place,
                          style: montserratRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.group,
                          size: Dimensions.ICON_SIZE_EXTRA_SMALL),
                      const SizedBox(width: 5),
                      // TODO : Count ticket
                      Text("5 Ticket",
                          style: montserratRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.groups,
                          size: Dimensions.ICON_SIZE_EXTRA_SMALL),
                      const SizedBox(width: 5),
                      // TODO : Count Member
                      Text("50 / 100 Members",
                          style: montserratRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.schedule,
                          size: Dimensions.ICON_SIZE_EXTRA_SMALL),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(eventResponse.startDateFormatted,
                            maxLines: 1,
                            style: montserratRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

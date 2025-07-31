import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../component/app_colors.dart';
import 'detail_event_screen.dart';

class EventScreen extends StatefulWidget {
  final EventBloc eventBloc;
  final bool isAdmin;
  const EventScreen({Key? key, required this.eventBloc, required this.isAdmin}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (widget.isAdmin) ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, addEventScreen);
        },
        child: Icon(Icons.add, color: AppColors.white),
      ) : null,
      body: BlocListener(
        bloc: widget.eventBloc,
        listener:(context, EventState eventState) {
          if (eventState is EventStateError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(eventState.message),
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        child: SafeArea(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    final double defaultHeight = MediaQuery.of(context).size.height / 1.38;

    return CustomScreen(
      withoutPadding: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming Events', style: robotoBold),
          const SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              bloc: widget.eventBloc,
              builder: (context, EventState eventState) {
                final Widget defaultWidget = Container(
                  alignment: Alignment.center,
                  height: defaultHeight,
                  child: const Center(child: Text('Event Data Not Found', textAlign: TextAlign.center)),
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
                    if (eventState.listEventResponse.isEmpty) {
                      return defaultWidget;
                    }

                    return ListView(
                      children: eventState.listEventResponse.map((EventResponse eventResponse) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: EventCard(
                            eventResponse: eventResponse,
                            isAdmin: widget.isAdmin,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return defaultWidget;
                  }
                }

                return defaultWidget;
              },
            ),
          ),
        ],
      ),
    );
  }
}


// TODO : Make widget
class EventCard extends StatelessWidget {
  final EventResponse eventResponse;
  final bool isAdmin;
  const EventCard({Key? key, required this.eventResponse, required this.isAdmin}) : super(key: key);

  void onTap(BuildContext context) {
    if (isAdmin) {
      Navigator.pushNamed(context, detailAdminEventScreen, arguments: {
        'eventResponse': eventResponse
      });
    } else {
      Navigator.pushNamed(context, detailEventScreen, arguments: {
        'eventResponse': eventResponse
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      child: SizedBox(
        height: 240,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
                        child: Image.network(eventResponse.photo,
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: AppColors.black.withOpacity(0.6),
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/icons/contoh.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_SMALL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text(eventResponse.getVisitorMember, style: montserratRegular.copyWith(color: AppColors.white, fontSize: 10)),
                                Text(eventResponse.priceEvent, style: montserratBold.copyWith(color: AppColors.cadmiumOrange))
                              ],
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_pin, color: AppColors.white, size: 13),
                                  const SizedBox(width: 5),
                                  Text(eventResponse.place, style: montserratRegular.copyWith(color: AppColors.white, fontSize: 10)),
                                ],
                              ),
                             Text(eventResponse.visitorMember, style: montserratRegular.copyWith(color: AppColors.white, fontSize: 10)),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.cadmiumOrange
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(40)
                                )
                            ),
                            child: LinearPercentIndicator(
                              padding: const EdgeInsets.all(0),
                              barRadius: const Radius.circular(40),
                              animation: true,
                              lineHeight: 5.0,
                              animationDuration: 1500,
                              percent: eventResponse.percentVisitorMember,
                              progressColor: AppColors.cadmiumOrange,
                              backgroundColor: AppColors.whiteSmoke.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(eventResponse.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: montserratBold),
                      Text(eventResponse.eventCardSubtitle, maxLines: 2, style: montserratRegular.copyWith(fontSize: 9, height: 1.7)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TODO : Implement count checkin checkout
                            Expanded(
                              child: Text((isAdmin) ? 'Check In : 0 / ${eventResponse.maxVisitor} \nCheck Out : 0 / ${eventResponse.maxVisitor}' : 'Register Before : \n${eventResponse.endRegistrationDateFormatted}', maxLines: 2, style: montserratRegular.copyWith(fontSize: 9, height: 1.9))
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(80.w, 20),
                              ),
                              onPressed: eventResponse.isBooked ? null : () {
                                onTap(context);
                              },
                              child: Text(
                                (isAdmin) ? 'View Event' : 'Book  Now',
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/bloc/family_bloc/family_bloc.dart';
import 'package:eccmobile/bloc/payment_cubit/payment_cubit.dart';
import 'package:eccmobile/data/models/family_selected.dart';
import 'package:eccmobile/data/models/response/person_event_response.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/util/custom_checkbox.dart';
import 'package:eccmobile/util/custom_radio_button.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../component/app_colors.dart';

class DetailEventScreen extends StatefulWidget {
  final EventResponse eventResponse;
  const DetailEventScreen({Key? key, required this.eventResponse}) : super(key: key);

  @override
  State<DetailEventScreen> createState() => _DetailEventScreenState();
}

class _DetailEventScreenState extends State<DetailEventScreen> {
  final sl = GetIt.instance;
  late final PaymentCubit paymentCubit;
  int indexParticipant = 0;
  List<FamilySelected> listFamilySelected = [];
  late final FamilyBloc familyBloc;

  @override
  void initState() {
    paymentCubit = sl();
    familyBloc = sl();
    familyBloc.add(FamilyEventGetList(eventId: widget.eventResponse.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FamilyBloc, FamilyState>(
          bloc: familyBloc,
          listener: (context, FamilyState familyState) {
            if (familyState is FamilyStateGetList) {
              listFamilySelected.addAll(familyState.listFamilyResponse.map((e) {
                // TODO : handle is join false for role (AYAH, IBU)
                return FamilySelected(id: e.id, name: "${e.name}", selected: false, isJoin: e.isJoin);
              }).toList());

              paymentCubit.initialState(
                eventId: widget.eventResponse.id,
                list: listFamilySelected,
                amount: widget.eventResponse.amount
              );
            }

            if (familyState is FamilyStateError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                content: Text(familyState.message),
              ));
            }
          },
        ),
        BlocListener<PaymentCubit, PaymentState>(
          bloc: paymentCubit,
          listener: (context, PaymentState paymenState) {
            if (paymenState is PaymentStateJoinEvent) {
              if (widget.eventResponse.isPaid) {
                Navigator.pushNamedAndRemoveUntil(context, paymentScreen, (route) => false, arguments: {
                  'snapToken': paymenState.snapToken,
                  'url': paymenState.url,
                  'calculateAmount': paymenState.calculateAmount,
                  'familyParticipant': paymenState.familyParticipant
                });
              } else {
                Navigator.pop(context);
              }

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(paymenState.message),
              ));
            } else if (paymenState is PaymentStateError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(paymenState.message),
                backgroundColor: Colors.red,
              ));
            }
          },
        )
      ],
      child: BlocBuilder(
        bloc: paymentCubit,
        builder: (context, PaymentState paymentState) {
          return LoadingOverlay(
            isLoading: false,
            child: Scaffold(
              backgroundColor: AppColors.whiteSmoke,
              body: buildBodyStack(paymentState),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ]
                    ),
                    child: Card(
                      elevation: 4,
                      color: AppColors.cadmiumOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Family Participant ', style: TextStyle(color: AppColors.white)),
                                Text(paymentState.calculateAmountEvent, textAlign: TextAlign.right, style: TextStyle(color: AppColors.white)),
                              ],
                            ),
                            Divider(color: AppColors.white),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Amount : ', style: TextStyle(color: AppColors.white)),
                                      SizedBox(height: 2.h),
                                      Text(paymentState.priceEvent, textAlign: TextAlign.right, style: montserratBold.copyWith(color: AppColors.white)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(AppColors.white),
                                  ),
                                  onPressed: (paymentState.isLoading) ? null : () {
                                    if (widget.eventResponse.isBooked) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Event has been fully booked.'),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    } else if (paymentState.familySelected.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Please select participant.'),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    } else {
                                      paymentCubit.createPayment();
                                    }
                                  },
                                  child: (paymentState.isLoading) ? SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: AppColors.cadmiumOrange, strokeWidth: 2)) : Text(
                                    widget.eventResponse.isBooked ? 'Full Booked' : 'Book Now',
                                    style: TextStyle(
                                        color: widget.eventResponse.isBooked ? AppColors.quillGrey : AppColors.cadmiumOrange,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }

  Widget buildBodyStack(PaymentState paymentState) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          buildHeaderBody(paymentState),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: buildBody(paymentState)
          ),
        ],
      ),
    );
  }

  Widget buildBody(PaymentState paymentState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSmoke,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget.eventResponse.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Age Event : ${widget.eventResponse.maximumAgeEvent}", style: montserratRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT.sp, height: 1.5),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              'Event Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              widget.eventResponse.eventDate, style: montserratRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT.sp, height: 1.5),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              'Registration Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text("${widget.eventResponse.startRegistrationDateFormatted} - ${widget.eventResponse.endRegistrationDateFormatted}", style: montserratRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT.sp, height: 1.5)),
            SizedBox(
              height: 25.h,
            ),
            Text(
              'Participant (s)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            // TODO : Need age information
            if (paymentState.listFamilySelected.isNotEmpty)
              CustomCheckbox(
                onChanged: (Map<String, dynamic> value) {
                  paymentCubit.selectedListFamily(value['id'], selected: value['selected']);
                },
                items: paymentState.listFamilySelected.map((FamilySelected e) {
                  return e.toJson();
                }).toList(),
              ),
            SizedBox(
              height: 29.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderBody(PaymentState paymentState) {
    final double positionWidget = MediaQuery.of(context).size.height / 5.5;

    return Stack(
      children: [
        SizedBox(
          height: 350.h,
          child: Image.network(widget.eventResponse.photo,
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
        Positioned(
          left: 20.h,
          top: 40.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
                decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                ),
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
          )
        ),
        Positioned(
          left: 20.h,
          top: 60.h,
          right: 20.h,
          child: Text(widget.eventResponse.priceEvent, textAlign: TextAlign.right, style: montserratBold.copyWith(color: AppColors.cadmiumOrange, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
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
                      Icon(Icons.location_pin, color: AppColors.white, size: Dimensions.ICON_SIZE_EXTRA_SMALL),
                      const SizedBox(width: 5),
                      Text(widget.eventResponse.place, style: montserratRegular.copyWith(color: AppColors.white, fontSize: Dimensions.FONT_SIZE_SMALL)),
                    ],
                  ),
                  Text(widget.eventResponse.visitorMember, style: montserratRegular.copyWith(color: AppColors.white, fontSize: Dimensions.FONT_SIZE_SMALL)),
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

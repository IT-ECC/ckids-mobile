import 'dart:io';

import 'package:eccmobile/bloc/branch_cubit/branch_cubit.dart';
import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/data/models/body/add_event_body.dart';
import 'package:eccmobile/util/custom_checkbox.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/appbar_home.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:eccmobile/util/widget/form/input_form.dart';
import 'package:eccmobile/util/widget/picker/picker.dart';
import 'package:eccmobile/util/widget/selected_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../component/app_colors.dart';
import '../../util/helper.dart';
import '../../util/resource/dimensions.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';


class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final sl = GetIt.instance;
  late final EventBloc eventBloc;
  late final BranchCubit branchCubit;
  late DateTime dateTime = DateTime.now();
  late TimeOfDay timeOfDay = const TimeOfDay(hour: 12, minute: 00);
  bool isVisitorUnlimited = false;
  bool isEventPaid = true;
  bool isBookingRequired = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  late DateTime startDateEvent = dateTime;
  late TimeOfDay startTimeEvent = timeOfDay;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  late DateTime endDateEvent = dateTime;
  late TimeOfDay endTimeEvent = timeOfDay;
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  late DateTime startRegisDateEvent = dateTime;
  late TimeOfDay startRegisTimeEvent = timeOfDay;
  final TextEditingController startDateRegisController = TextEditingController();
  final TextEditingController startTimeRegisController = TextEditingController();
  late DateTime endRegisDateEvent = dateTime;
  late TimeOfDay endRegisTimeEvent = timeOfDay;
  final TextEditingController endDateRegisController = TextEditingController();
  final TextEditingController endTimeRegisController = TextEditingController();

  final TextEditingController maxVisitorController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? imagePicker;

  void setVisitorUnlimited(bool? value) {
    setState(() {
      isVisitorUnlimited = (value != null) ? value : (isVisitorUnlimited) ? false : true;
    });

    if (maxVisitorController.text.isNotEmpty && isVisitorUnlimited) {
      maxVisitorController.clear();
    }
  }

  void setEventPaid(bool? value) {
    setState(() {
      isEventPaid = (value != null) ? value : (isEventPaid) ? false : true;
    });

    if (!isEventPaid) {
      priceController.clear();
    }
  }

  void setBookingRequired(bool? value) {
    setState(() {
      isBookingRequired = (value != null) ? value : (isBookingRequired) ? false : true;
    });

    if (!isBookingRequired) {
      startDateRegisController.clear();
      startTimeRegisController.clear();
      endDateRegisController.clear();
      endTimeRegisController.clear();
    }
  }

  @override
  void initState() {
    initialBloc();

    minAgeController.text = AppConstant.dataAge[0];
    maxAgeController.text = AppConstant.dataAge[0];
  }

  void initialBloc() {
    eventBloc = sl();
    branchCubit = sl();
    branchCubit.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHome.appBarWithLeading(context, title: 'Create Event'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EventBloc, EventState>(
            bloc: eventBloc,
            listener: (context, EventState eventState) {
              if (eventState is EventStateCreateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  content: Text(eventState.message),
                ));
                Navigator.pushNamedAndRemoveUntil(context, mainScreen, (route) => false, arguments: {'isAdmin': true});
              } else if (eventState is EventStateError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  content: Text(eventState.message),
                ));
              }
            },
          ),
          BlocListener<BranchCubit, BranchState>(
            bloc: branchCubit,
            listener: (context, BranchState branchState) {
              if (branchState.showList) {
                /*
                * Initialize value selected dropdown
                * */
                branchController.text = branchState.listBranch.first.id;
              }
            },
          )
        ],
        child: BlocBuilder<EventBloc, EventState>(
          bloc: eventBloc,
          builder: (context, EventState eventState) {
            return SafeArea(
              child: buildBody(eventState),
            );
          },
        ),
      )
    );
  }

  Widget buildBody(EventState eventState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomScreen(
          withoutPadding: false,
          marginTop: 10,
          child: SizedBox(
            height: constraints.maxHeight, //based on your need
            width: constraints.maxWidth,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                children: [
                  SelectedImage(imagePicker: imagePicker, onChanged: (value) {
                    setState(() {
                      imagePicker = value;
                    });
                  }),
                  InputForm(
                    titleController,
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Event Name field is required.";
                        } else {
                          return null;
                        }
                      }
                    },
                    label: 'Event Name',
                  ),
                  InputForm(
                    placeController,
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Location field is required.";
                        } else {
                          return null;
                        }
                      }
                    },
                    label: 'Location Event',
                  ),
                  BlocBuilder(
                    bloc: branchCubit,
                    builder: (context, BranchState branchState) {
                      return (branchState.showList) ? DropdownForm(
                        value: branchController.text,
                        onChangedValue: (value) {
                          setState(() {
                            branchController.text = value;
                          });
                        },
                        items: branchState.listBranch.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.id,
                            child: Text(e.name),
                          );
                        }).toList(),
                        label: 'City ECC'
                      ) : InputForm(
                        branchController,
                        enable: false,
                        readOnly: true,
                        validator: (value) {},
                        label: 'City ECC',
                      );
                    },
                  ),

                  // TODO : Description event
                  InputForm(
                    descriptionController,
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Description field is required.";
                        } else {
                          return null;
                        }
                      }
                    },
                    maxLines: 6,
                    label: 'Description Event',
                  ),
                  startEvent(),
                  const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: AppColors.cadmiumOrange),
                          child: Checkbox(
                            value: isVisitorUnlimited,
                            onChanged: (value) => setVisitorUnlimited(value),
                            activeColor: AppColors.cadmiumOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => setVisitorUnlimited,
                        child: const Text('Visitor Unlimited', style: TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                  Visibility(
                    visible: !isVisitorUnlimited,
                    child: InputForm(
                      maxVisitorController,
                      readOnly: isVisitorUnlimited,
                      enable: !isVisitorUnlimited,
                      label: 'Max Visitor',
                      validator: (value) {},
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: AppColors.cadmiumOrange),
                          child: Checkbox(
                            value: isBookingRequired,
                            onChanged: (value) => setBookingRequired(value),
                            activeColor: AppColors.cadmiumOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        onTap: () => setBookingRequired,
                        child: const Text('Booking Required', style: TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                  registrationEvent(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DropdownForm(
                          value: minAgeController.text,
                          onChangedValue: (value) {
                            setState(() {
                              minAgeController.text = value;
                            });
                          },
                          items: AppConstant.dataAge.map((e) {
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text("${e} Year"),
                            );
                          }).toList(),
                          label: 'Minimum Age'
                        )
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'To',
                          style: TextStyle(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: DropdownForm(
                            value: maxAgeController.text,
                            onChangedValue: (value) {
                              setState(() {
                                maxAgeController.text = value;
                              });
                            },
                            items: AppConstant.dataAge.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text("${e} Year"),
                              );
                            }).toList(),
                            label: 'Maximum Age'
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: AppColors.cadmiumOrange),
                          child: Checkbox(
                            value: isEventPaid,
                            onChanged: (value) => setEventPaid(value),
                            activeColor: AppColors.cadmiumOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        onTap: () => setEventPaid,
                        child: const Text('Event Paid', style: TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                  // TODO : Still error when typing on keyboard (allow String number)
                  Visibility(
                    visible: isEventPaid,
                    child: InputForm(
                      priceController,
                      validator: (value) {
                        if (isEventPaid) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "Price field is required.";
                            } else {
                              return null;
                            }
                          }
                        }
                      },
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'id',
                          decimalDigits: 3,
                        ),
                        FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      ],
                      keyboardType: TextInputType.number,
                      readOnly: !isEventPaid,
                      enable: isEventPaid,
                      label: 'Price ',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.MARGIN_SIZE_DEFAULT),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: (eventState is EventStateLoading) ? null : () {
                        if (_formKey.currentState!.validate()) {
                          AddEventBody addEventBody = AddEventBody(
                            title: titleController.text,
                            description: descriptionController.text,
                            branchId: branchController.text,
                            isVisitorUnlimited: isVisitorUnlimited,
                            maxVisitor: int.tryParse(maxVisitorController.text),
                            isPaid: isEventPaid,
                            price: int.tryParse(priceController.text.replaceAll(RegExp(r'[,.]'), '')) ?? 0,
                            place: placeController.text,
                            maximumAge: int.tryParse(maxAgeController.text),
                            minimumAge: int.tryParse(minAgeController.text),
                            startRegistrationDate: "${startDateRegisController.text} ${startRegisTimeEvent.hourOfPeriod}:${(startRegisTimeEvent.minute.toString().length <= 1) ? "0${startRegisTimeEvent.minute}" : startRegisTimeEvent.minute}",
                            endRegistrationDate: "${endDateRegisController.text} ${endRegisTimeEvent.hourOfPeriod}:${(endRegisTimeEvent.minute.toString().length <= 1) ? "0${endRegisTimeEvent.minute}" : endRegisTimeEvent.minute}",
                            startDate: "${startDateController.text} ${startTimeEvent.hourOfPeriod}:${(startTimeEvent.minute.toString().length <= 1) ? "0${startTimeEvent.minute}" : startTimeEvent.minute}",
                            endDate: "${endDateController.text} ${endTimeEvent.hourOfPeriod}:${(endTimeEvent.minute.toString().length <= 1) ? "0${endTimeEvent.minute}" : endTimeEvent.minute}",
                            bookingRequired: isBookingRequired,
                            photo: (imagePicker != null) ? imagePicker!.path : null,
                          );

                          eventBloc.add(EventCreate(addEventBody));
                        }
                      },
                      child: (eventState is EventStateLoading) ? SizedBox(child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2,), height: 21, width: 21) :  Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget startEvent() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: InputForm(
                startDateController,
                label: 'Start Event',
                readOnly: true,
                onTap: () => Picker().selectDate(context, isEventDay: true, initialDate: startDateEvent, onChanged: (DateTime value) {
                  setState(() {
                    startDateEvent = value;
                    startDateController.text = Format.convertDate(startDateEvent, 'yyyy-MM-dd');
                  });
                }),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Start Event field is required.";
                    } else {
                      return null;
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: InputForm(
                startTimeController,
                label: 'Time',
                readOnly: true,
                onTap: () => Picker().selectTime(context, initialTime: startTimeEvent, onChanged: (TimeOfDay value) {
                  setState(() {
                    startTimeEvent = value;
                    startTimeController.text = value.format(context);
                  });
                }),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Time field is required.";
                    } else {
                      return null;
                    }
                  }
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: InputForm(
                endDateController,
                label: 'End Event',
                readOnly: true,
                onTap: () => Picker().selectDate(context, isEventDay: true, initialDate: endDateEvent, onChanged: (DateTime value) {
                  setState(() {
                    endDateEvent = value;
                    endDateController.text = Format.convertDate(endDateEvent, 'yyyy-MM-dd');
                  });
                }),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "End Event field is required.";
                    } else {
                      return null;
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: InputForm(
                endTimeController,
                label: 'Time',
                readOnly: true,
                onTap: () => Picker().selectTime(context, initialTime: endTimeEvent, onChanged: (TimeOfDay value) {
                  setState(() {
                    endTimeEvent = value;
                    endTimeController.text = value.format(context);
                  });
                }),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Time field is required.";
                    } else {
                      return null;
                    }
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget registrationEvent() {
    return Visibility(
      visible: isBookingRequired,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: InputForm(
                  startDateRegisController,
                  label: 'Start Register Event',
                  readOnly: true,
                  enable: (isBookingRequired),
                  onTap: () => Picker().selectDate(context, isEventDay: true, initialDate: startRegisDateEvent, onChanged: (DateTime value) {
                    setState(() {
                      startRegisDateEvent = value;
                      startDateRegisController.text = Format.convertDate(startRegisDateEvent, 'yyyy-MM-dd');
                    });
                  }),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return "Start Register Event field is required.";
                      } else {
                        return null;
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: InputForm(
                  startTimeRegisController,
                  label: 'Time',
                  readOnly: true,
                  enable: (isBookingRequired),
                  onTap: () => Picker().selectTime(context, initialTime: startRegisTimeEvent, onChanged: (TimeOfDay value) {
                    setState(() {
                      startRegisTimeEvent = value;
                      startTimeRegisController.text = value.format(context);
                    });
                  }),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return "Time field is required.";
                      } else {
                        return null;
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: InputForm(
                  endDateRegisController,
                  label: 'End Register Event',
                  readOnly: true,
                  enable: (isBookingRequired),
                  onTap: () => Picker().selectDate(context, isEventDay: true, initialDate: endRegisDateEvent, onChanged: (DateTime value) {
                    setState(() {
                      endRegisDateEvent = value;
                      endDateRegisController.text = Format.convertDate(endRegisDateEvent, 'yyyy-MM-dd');
                    });
                  }),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return "End Event field is required.";
                      } else {
                        return null;
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: InputForm(
                  endTimeRegisController,
                  label: 'Time',
                  readOnly: true,
                  enable: (isBookingRequired),
                  onTap: () => Picker().selectTime(context, initialTime: endRegisTimeEvent, onChanged: (TimeOfDay value) {
                    setState(() {
                      endRegisTimeEvent = value;
                      endTimeRegisController.text = value.format(context);
                    });
                  }),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return "Time field is required.";
                      } else {
                        return null;
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

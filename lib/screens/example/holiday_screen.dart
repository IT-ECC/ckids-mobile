import 'package:eccmobile/data/repository/holiday_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eccmobile/data/models/holiday_model.dart';

import '../../data/bloc/holiday/holiday_bloc.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({Key? key}) : super(key: key);

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  late final HolidayBloc holidayBloc;
  final HolidayRepository holidayRepository = HolidayRepository();

  @override
  void initState() {
    holidayBloc = HolidayBloc(holidayRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Holiday'),
        actions: [
          IconButton(onPressed: () {
            holidayBloc.add(HolidayInitialEvent());
          }, icon: Icon(Icons.add))
        ],
      ),
      body: BlocListener(
        bloc: holidayBloc,
        listener: (context, holidayState) {
          print(holidayState.toString());
          ScaffoldMessenger(child: SnackBar(content: Text(holidayState.toString())));
        },
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return BlocBuilder(
      bloc: holidayBloc,
      builder: (context, HolidayState holidayState) {
        if (holidayState is HolidayLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (holidayState is HolidayLoaded) {
          return ListView.builder(
            itemCount: holidayState.listHoliday.length,
            itemBuilder: (context, index) {
              HolidayModel holiday = holidayState.listHoliday[index];

              return Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                  child: Text(holiday.holidayName),
                ),
              );
            },
          );
        }

        return Container(
          child: Text(holidayState.toString()),
        );
      },
    );
  }
}

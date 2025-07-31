import 'package:dropdown_search/dropdown_search.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../component/app_colors.dart';
import '../../component/qr_screen.dart';

class EditFamilyProfileScreen extends StatelessWidget {
  EditFamilyProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 31.w, right: 31.w),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 80.h, bottom: 40.h),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 18.h),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 37.w),
                            child: Column(
                              children: [
                                TextField(
                                  style: TextStyle(color: AppColors.cadmiumOrange),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 6),
                                    isDense: true,
                                    labelText: 'Nama Lengkap',
                                    labelStyle: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange),
                                    ),
                                  ),
                                ),
                                DropdownSearch<String>(
                                  showClearButton: true,
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                    disabledItemFn: (String s) =>
                                        s.startsWith('I'),
                                  ),
                                  items: [],
                                  dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.cadmiumOrange,
                                            width: 0.0)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.cadmiumOrange,
                                            width: 0.0)),
                                    labelText: 'Peran dalam Keluarga',
                                    labelStyle: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  onChanged: (value) {
                                    print(value);
                                  },
                                ),
                                TextField(
                                  style: TextStyle(color: AppColors.cadmiumOrange),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 6),
                                    labelText: 'Tanggal Lahir',
                                    labelStyle: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0),
                                    ),
                                  ),
                                ),
                                TextField(
                                  style: TextStyle(color: AppColors.cadmiumOrange),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 6),
                                    labelText: 'Alamat',
                                    labelStyle: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 37.h,
                          ),
                          QrButton(data: ''),
                          SizedBox(
                            height: 26.h,
                          ),
                          DefaultButton(
                            isCard: true,
                            text: 'Save',
                            press: (() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return EditFamilyProfileScreen();
                                }),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 56.r,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

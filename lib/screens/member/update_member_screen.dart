import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:eccmobile/bloc/family_bloc/family_bloc.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:eccmobile/data/models/body/add_member_body.dart';
import 'package:eccmobile/data/models/body/update_member_body.dart';
import 'package:eccmobile/data/models/response/family_role_response.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/appbar_home.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:eccmobile/util/widget/form/input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../component/app_colors.dart';

class UpdateMemberScreen extends StatefulWidget {
  final FamilyResponse familyResponse;

  const UpdateMemberScreen({Key? key, required this.familyResponse})
      : super(key: key);

  @override
  State<UpdateMemberScreen> createState() => _UpdateMemberScreenState();
}

class _UpdateMemberScreenState extends State<UpdateMemberScreen> {
  final sl = GetIt.instance;
  late final FamilyBloc familyBloc;
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String familyRoleName = '';

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController familyRoleIdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  late final List<FamilyRoleResponse> listFamilyRoleResponse = [];

  final ImagePicker _picker = ImagePicker();
  XFile? imagePicker;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.cadmiumOrange),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirthController.text = Format.convertDate(picked, 'yyyy-MM-dd');
      });
    }
  }

  @override
  void initState() {
    familyBloc = sl();
    familyBloc.add(FamilyRoleEventGetList());
    // TODO : Gender its not define from API
    genderController.text = AppConstant.LAKI_LAKI;
    fullNameController.text = widget.familyResponse.name;
    emailController.text = widget.familyResponse.email;
    familyRoleName = widget.familyResponse.familyStatus;
    dateOfBirthController.text = widget.familyResponse.birthDate;
    selectedDate = DateTime.parse(widget.familyResponse.birthDate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarHome.appBarWithLeading(context,
            title: 'Update Family Profile'),
        body: BlocListener<FamilyBloc, FamilyState>(
          bloc: familyBloc,
          listener: (context, FamilyState familyState) {
            if (familyState is FamilyStateAddorUpdateMemberSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(familyState.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ));

              Navigator.pushReplacementNamed(context, mainScreen,
                  arguments: {'currentIndex': 0});
            } else if (familyState is FamilyStateError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(familyState.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ));
            } else if (familyState is FamilyStateGetListRole) {
              setState(() {
                listFamilyRoleResponse
                    .addAll(familyState.listFamilyRoleResponse);
                familyRoleIdController.text = listFamilyRoleResponse
                    .where((FamilyRoleResponse element) =>
                        element.name.contains(familyRoleName))
                    .first
                    .id;
              });
            }
          },
          child: BlocBuilder<FamilyBloc, FamilyState>(
            bloc: familyBloc,
            builder: (context, FamilyState familyState) {
              return SafeArea(
                child: buildBody(familyState),
              );
            },
          ),
        ));
  }

  Widget buildBody(FamilyState familyState) {
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
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                children: [
                  InkWell(
                    onTap: () async {
                      await _picker
                          .pickImage(source: ImageSource.gallery)
                          .then((XFile? value) {
                        setState(() {
                          if (value != null) imagePicker = value;
                        });
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 110, vertical: 10),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          image: (imagePicker != null)
                              ? DecorationImage(
                                  image: FileImage(File(imagePicker!.path)),
                                  fit: BoxFit.cover)
                              : DecorationImage(
                                  image:
                                      NetworkImage(widget.familyResponse.photo),
                                  fit: BoxFit.cover)),
                      child: Icon(
                        Icons.edit,
                        size: 40.h,
                        color: (imagePicker != null)
                            ? AppColors.cadmiumOrange.withOpacity(0.7)
                            : AppColors.cadmiumOrange,
                      ),
                    ),
                  ),
                  InputForm(
                    fullNameController,
                    label: 'Full Name',
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Full Name field is required.";
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 21.h,
                  ),
                  DropdownButtonFormField<String>(
                    value: genderController.text,
                    items: AppConstant.dataGender
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Gender field is required.";
                        } else {
                          return null;
                        }
                      }
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: AppColors.cadmiumOrange),
                        contentPadding: const EdgeInsets.only(
                            left: Dimensions.PADDING_SIZE_SMALL,
                            right: Dimensions.PADDING_SIZE_DEFAULT),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                              color: AppColors.cadmiumOrange, width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                              color: AppColors.cadmiumOrange, width: 0.0),
                        ),
                        labelText: 'Gender',
                        hintText: 'Gender'),
                    onChanged: (value) {
                      setState(() {
                        genderController.text = value ?? "";
                      });
                    },
                  ),
                  SizedBox(
                    height: 21.h,
                  ),
                  DropdownButtonFormField<String?>(
                    value: familyRoleIdController.text,
                    items: listFamilyRoleResponse
                        .map<DropdownMenuItem<String?>>(
                            (FamilyRoleResponse value) {
                      return DropdownMenuItem<String?>(
                        value: value.id,
                        child: Text(value.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Family Role field is required.";
                        } else {
                          return null;
                        }
                      }
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: AppColors.cadmiumOrange),
                        contentPadding: const EdgeInsets.only(
                            left: Dimensions.PADDING_SIZE_SMALL,
                            right: Dimensions.PADDING_SIZE_DEFAULT),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                              color: AppColors.cadmiumOrange, width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                              color: AppColors.cadmiumOrange, width: 0.0),
                        ),
                        labelText: 'Family Role',
                        hintText: 'Family Role'),
                    onChanged: null,
                    // onChanged: (value) {
                    //   setState(() {
                    //     familyRoleIdController.text = value ?? "";
                    //     familyRoleName = listFamilyRoleResponse.where((element) => element.id.contains(value ?? "")).first.name;
                    //   });
                    // },
                  ),
                  if (familyRoleName.toUpperCase() !=
                      AppConstant.ANAK.toUpperCase())
                    InputForm(
                      emailController,
                      label: 'Email',
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Email field is required.";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                  InputForm(
                    dateOfBirthController,
                    label: 'Date of Birth',
                    readOnly: true,
                    onTap: () => _selectDate(),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Date of Birth field is required.";
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.MARGIN_SIZE_DEFAULT),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: (familyState is FamilyStateLoading)
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final UpdateMemberBody updateMemberBody =
                                    UpdateMemberBody(
                                        name: fullNameController.text,
                                        email: emailController.text,
                                        familyRoleId:
                                            familyRoleIdController.text,
                                        gender: genderController.text,
                                        birthDate: dateOfBirthController.text,
                                        personId: widget.familyResponse.id,
                                        photo: (imagePicker != null)
                                            ? imagePicker!.path
                                            : null);

                                familyBloc.add(FamilyEventUpdateMember(
                                    updateMemberBody: updateMemberBody));
                              }
                            },
                      child: (familyState is FamilyStateLoading)
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

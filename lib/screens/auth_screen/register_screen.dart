import 'dart:ffi';
import 'dart:io';

import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/bloc/branch_cubit/branch_cubit.dart';
import 'package:eccmobile/bloc/family_bloc/family_bloc.dart';
import 'package:eccmobile/component/bottom_navigation.dart';
import 'package:eccmobile/data/models/body/body.dart';
import 'package:eccmobile/data/models/response/branch_response.dart';
import 'package:eccmobile/data/models/response/family_role_response.dart';
import 'package:eccmobile/data/repository/auth_repository.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/form/input_form.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:eccmobile/component/default_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../component/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// TODO : Make keyboard default UpperCase on first Letter
class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final sl = GetIt.instance;
  late final AuthBloc authBloc;
  late final FamilyBloc familyBloc;
  late final BranchCubit branchCubit;
  late final List<FamilyRoleResponse> listFamilyRoleResponse = [];
  late final List<BranchResponse> listBranch = [];
  late FamilyRoleResponse? familyRoleResponse;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController familyRoleIdController = TextEditingController();

  final TextEditingController branchIdController = TextEditingController();

  final TextEditingController genderController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
  TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? imagePicker;
  DateTime selectedDate = DateTime.now();

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
    genderController.text = AppConstant.LAKI_LAKI;
    passwordController.addListener(() {
      setState(() {});
    });
    passwordConfirmationController.addListener(() {
      setState(() {});
    });

    authBloc = sl();
    familyBloc = sl();
    branchCubit = sl();

    branchCubit.getList();
    familyBloc.add(FamilyRoleEventGetList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO : Add button back

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, AuthState authState) {
              if (authState is AuthStateSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, mainScreen, (route) => false,
                    arguments: {'isAdmin': authState.loginResponse.isAdmin});
              } else if (authState is AuthStateError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(authState.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
          ),
          BlocListener<FamilyBloc, FamilyState>(
            bloc: familyBloc,
            listener: (context, FamilyState familyState) {
              if (familyState is FamilyStateGetListRole) {
                setState(() {
                  listFamilyRoleResponse.addAll(familyState
                      .listFamilyRoleResponse
                      .where((element) => element.name != AppConstant.ANAK)
                      .toList());
                  familyRoleIdController.text = listFamilyRoleResponse.first.id;
                });
              }

              if (familyState is FamilyStateError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(familyState.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
          ),
          BlocListener<BranchCubit, BranchState>(
            bloc: branchCubit,
            listener: (context, BranchState branchState) {
              if (branchState.listBranch.isNotEmpty) {
                setState(() {
                  listBranch.addAll(branchState
                      .listBranch
                      .toList());
                  branchIdController.text = listBranch.first.id;
                });
              }

              if (branchState is BranchStateError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(branchState.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
          )
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: authBloc,
          builder: (context, AuthState authState) {
            return LoadingOverlay(
                isLoading: (authState is AuthStateLoading),
                child: Container(
                  margin: const EdgeInsets.only(top: 90),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildBody(),
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          SizedBox(
            width: 265.w,
            height: 265.h,
            child: Image.asset('assets/images/logo.png'),
          ),
          Center(
            child: Text(
              'Create an Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
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
              margin: const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
              height: 130,
              decoration: BoxDecoration(
                  color: AppColors.quillGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  image: (imagePicker != null)
                      ? DecorationImage(
                      image: FileImage(File(imagePicker!.path)),
                      fit: BoxFit.cover)
                      : null),
              child: Icon(
                (imagePicker != null) ? Icons.edit : Icons.photo_library,
                size: 40.h,
                color: (imagePicker != null)
                    ? AppColors.cadmiumOrange.withOpacity(0.7)
                    : AppColors.cadmiumOrange,
              ),
            ),
          ),
          DropdownForm(
              value: familyRoleIdController.text,
              onChangedValue: (value) {
                setState(() {
                  familyRoleIdController.text = value;
                  familyRoleResponse = listFamilyRoleResponse.where((element) => element.id.contains(value)).first;

                  if (familyRoleResponse != null) {
                    if (familyRoleResponse!.name.contains(AppConstant.AYAH)) {
                      genderController.text = AppConstant.LAKI_LAKI;
                    } else {
                      genderController.text = AppConstant.PEREMPUAN;
                    }
                  }
                });
              },
              items: listFamilyRoleResponse.map((FamilyRoleResponse e) {
                return DropdownMenuItem<String>(
                  value: e.id,
                  child: Text(e.name),
                );
              }).toList(),
              label: 'Family Role'
          ),
          InputForm(
            fullNameController,
            label: 'Full Name',
            hintText: 'ex : Alexander Graham Bell',
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
          InputForm(
            familyNameController,
            label: "Family's Name",
            hintText: "ex : Bell's Family",
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return "Family Name field is required.";
                } else {
                  return null;
                }
              }
            },
          ),
          DropdownForm(
              value: genderController.text,
              onChangedValue: (value) {
                setState(() {
                  genderController.text = value;
                });
              },
              items: AppConstant.dataGender.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              label: 'Gender'
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
          InputForm(
            addressController,
            maxLines: 5,
            label: 'Address',
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return "Address field is required.";
                } else {
                  return null;
                }
              }
            },
          ),
          InputForm(
            phoneController,
            keyboardType: TextInputType.number,
            label: 'Phone Number',
            hintText: 'ex : 08123456789',
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
          DropdownForm(
              value: branchIdController.text,
              onChangedValue: (value) {
                setState(() {
                  branchIdController.text = value;
                });
              },
              items: listBranch.map((BranchResponse e) {
                return DropdownMenuItem<String>(
                  value: e.id,
                  child: Text(e.name),
                );
              }).toList(),
              label: 'City'
          ),
          SizedBox(height: 15.h),
          Divider(height: 5.h),

          InputForm(
            emailController,
            label: 'Email',
            hintText: 'ex : Alexander@example.com',
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
            passwordController,
            isPassword: true,
            label: 'Password',
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return "Password field is required.";
                } else {
                  if (!validatePassword()) {
                    return "Password doesn't macth";
                  } else {
                    return null;
                  }
                }
              }
            },
          ),
          InputForm(
            passwordConfirmationController,
            isPassword: true,
            label: 'Password Confirmation',
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return "Password Confirmation field is required.";
                } else {
                  if (!validatePassword()) {
                    return "Password Confirmation doesn't macth";
                  } else {
                    return null;
                  }
                }
              }
            },
          ),
          SizedBox(
            height: 35.h,
          ),
          Container(
            margin: EdgeInsets.only(left: 32.w, right: 33.w, bottom: 14.h),
            width: 267.w,
            height: 49.h,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  authBloc.add(AuthEventRegistration(
                      registerBody: RegisterBody(
                          name: fullNameController.text,
                          email: emailController.text,
                          branchId: branchIdController.text,
                          address: addressController.text,
                          phone: phoneController.text,
                          familyName: familyNameController.text,
                          familyRoleId: familyRoleIdController.text,
                          password: passwordController.text,
                          birthDate: dateOfBirthController.text,
                          passwordConfirmation: passwordConfirmationController.text,
                          photo: (imagePicker != null) ? imagePicker!.path : null,
                          gender: genderController.text.toLowerCase()))
                  );
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validatePassword() {
    if (passwordController.text != passwordConfirmationController.text) {
      return false;
    }

    return true;
  }
}

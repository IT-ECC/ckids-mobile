import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/data/repository/auth_repository.dart';
import 'package:eccmobile/screens/event/add_event_screen.dart';
import 'package:eccmobile/screens/home/home_screen.dart';
import 'package:eccmobile/screens/screens.dart';
import 'package:eccmobile/util/custom_checkbox.dart';
import 'package:eccmobile/util/util.dart';
import 'package:flutter/material.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../component/bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  bool _termCondition = false;
  late final GlobalKey<FormState> _formKey;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final sl = GetIt.instance;
  late final AuthBloc authBloc;

  @override
  void initState() {
    authBloc = sl();
    _formKey = GlobalKey<FormState>();
    // usernameController.text = 'adminckids@mail.com';
    // passwordController.text = 'test1234';
    //usernameController.text = 'fauzannoor98@gmail.com';
    //passwordController.text = 'admin123';

    usernameController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, AuthState authState) {
            if (authState is AuthStateSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, mainScreen, (route) => false,
                  arguments: {'isAdmin': authState.loginResponse.isAdmin});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                content: Text(authState.loginResponse.message),
              ));
            } else if (authState is AuthStateError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                content: Text(authState.message),
              ));
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
            ),
            child: BlocBuilder(
              bloc: authBloc,
              builder: (context, AuthState authState) {
                return buildBody(authState);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody(AuthState authState) {
    return ListView(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 300.h,
          width: 300.w,
          child: Image.asset('assets/images/logo.png'),
        ),
        const SizedBox(height: 50),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: TextFormField(
                  controller: usernameController,
                  style: TextStyle(fontSize: 16.sp),
                  validator: (value) {
                    if (value == null) {
                      return 'Email cannot be empty';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      fillColor: Colors.white,
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                            color: AppColors.cadmiumOrange, width: 0.0),
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
                      labelText: 'Email',
                      labelStyle:
                      TextStyle(color: Colors.black, fontSize: 16.sp),
                      hintText: 'Enter email'),
                ),
              ),
              SizedBox(
                height: 17.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: TextFormField(
                  controller: passwordController,
                  style: TextStyle(fontSize: 16.sp),
                  validator: (value) {
                    if (value != null && value.length < 2) {
                      return 'Enter min. 8 Characters';
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                            color: AppColors.cadmiumOrange, width: 0.0),
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
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'Enter password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.cadmiumOrange,
                          ))),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Row(
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 11.sp),
              ),
              SizedBox(
                width: 2.w,
              ),
              InkWell(
                onTap: (authState is AuthStateLoading)
                    ? null
                    : () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return RegisterScreen();
                      }));
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: AppColors.cadmiumOrange, fontSize: 11.sp),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: (authState is AuthStateLoading)
                    ? null
                    : () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return ForgotScreen();
                      }));
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(fontSize: 11.sp),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 245.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: CustomCheckboxPrivacy(
            value: _termCondition,
            onChanged: (value) {
              setState(() {
                _termCondition = value;
              });
            },
          )
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 32.w, right: 33.w, bottom: 14.h),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: (authState is AuthStateLoading)
                        ? null
                        : (usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty && _termCondition)
                        ? () {
                      final bool validate =
                      _formKey.currentState!.validate();

                      authBloc.add(AuthEventLogin(
                          username: usernameController.text,
                          password: passwordController.text));
                    }
                        : null,
                    child: (authState is AuthStateLoading)
                        ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                        : Text(
                      'Log In',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: null,
                  child: Icon(Icons.fingerprint, color: Colors.white),
                  // style: ElevatedButton.styleFrom(
                  //   primary: AppColors.mainColor,
                  //   onPrimary: Colors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(7.0),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

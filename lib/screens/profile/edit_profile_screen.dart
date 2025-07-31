import 'package:flutter/material.dart';
import '../../component/app_colors.dart';
import '../../component/qr_screen.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 31, right: 31),
          child: ListView(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 25),
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(
                                  color: AppColors.cadmiumOrange, fontSize: 15),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 6),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0)),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                            TextFormField(
                              obscureText: !_passwordVisible,
                              style: TextStyle(
                                  color: AppColors.cadmiumOrange, fontSize: 15),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 6),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0)),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
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
                            TextFormField(
                              obscureText: !_passwordVisible,
                              style: TextStyle(
                                  color: AppColors.cadmiumOrange, fontSize: 15),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 6),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cadmiumOrange,
                                          width: 0.0)),
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
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
                            TextFormField(
                              style: TextStyle(
                                  color: AppColors.cadmiumOrange, fontSize: 15),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 6),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.cadmiumOrange,
                                        width: 0.0)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.cadmiumOrange,
                                        width: 0.0)),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            QrButton(data: ''),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.cadmiumOrange),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
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
                          radius: 40,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:eccmobile/data/shared_pref.dart';
import 'package:eccmobile/util/util.dart';
import 'package:flutter/material.dart';
import 'package:eccmobile/splash_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final sl = GetIt.instance;
  late final SharedPref sharedPref;

  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "image": "assets/images/onboarding1.png",
      "text1": "Welcome to ECC Kids",
      "text": "Creative Kids children's chruch has a commitment not only to introduce Jesus as Lord and Savior, but to disciple children so that they have the character of Jesus. Creative kids are fun, a great place to learn, encourage spritual growth, give encouragement to children"
    },
  ];

  @override
  void initState() {
    sharedPref = sl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteSmoke,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 86,
                    width: 86,
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () => lewati(context),
                      child: Text(
                        "Lewati",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ))
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                          image: splashData[index]["image"].toString(),
                          text1: splashData[index]["text1"].toString(),
                          text: splashData[index]["text"].toString(),
                        ))),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    splashData.length,
                    (index) => buildDot(index: index),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> lewati(context) async {
    await sharedPref.setOnBoarding(false);
    Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 15 : 6,
      decoration: BoxDecoration(
          color: currentPage == index ? AppColors.cadmiumOrange : Colors.grey,
          borderRadius: BorderRadius.circular(3)),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text1,
    required this.text,
    required this.image,
  }) : super(key: key);

  final String text, image, text1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 398,
          height: 227,
        ),
        Text(
          text1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
            width: 300,
            margin: EdgeInsets.only(top: 20),
            child: Text(
              text,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}

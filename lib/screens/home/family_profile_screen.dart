import 'package:cached_network_image/cached_network_image.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:eccmobile/component/qr_screen.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/screens/home/edit_family_profile_screen.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/appbar_home.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../component/app_colors.dart';

class FamilyPersonScreen extends StatelessWidget {
  final FamilyResponse familyResponse;

  const FamilyPersonScreen({Key? key, required this.familyResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHome.appBarWithLeading(context, title: ''),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: Dimensions.MARGIN_SIZE_LARGE),
              child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: familyResponse.photo,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //placeholder: (context, url) => LoadingWidget.loadingRingImage,
                            errorWidget: (context, url, error) {
                              return Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/images/logo.png')
                                    )
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                      Text(
                        familyResponse.name,
                        style: robotoBold.copyWith(color: AppColors.white, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                      ),
                      const SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      Text(
                        familyResponse.familyStatus,
                        style: robotoRegularSmall.copyWith(color: AppColors.white),
                      ),
                      const SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      Text(
                        familyResponse.email,
                        style: robotoRegularSmall.copyWith(color: AppColors.white),
                      ),
                    ],
                  )
              ),
            ),
            buildBody(context)
          ],
        ),
      )
    );
  }

  Widget buildBody(BuildContext context) {
    return CustomScreen(
      withoutPadding: false,
      marginTop: 200,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Card(
              child: QrButton(data: familyResponse.id, size: 320),
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: Dimensions.MARGIN_SIZE_DEFAULT),
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, updateMemberScreen, arguments: {
                  'familyResponse': familyResponse
                });
              },
              child: Text(
                'Update Family Profile',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

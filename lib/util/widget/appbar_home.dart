import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppBarHome {
  static Widget notificationWidget(int notificationCount, VoidCallback? onNotificationScreen) {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      showBadge: (notificationCount > 0),
      badgeContent: Text(
        notificationCount.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      child: IconButton(
          onPressed: onNotificationScreen,
          icon: const Icon(Icons.notifications, color: Colors.white, size: 20)
      ),
    );
  }

  static Widget _appBarWidget(String username, String avatar, {int notificationCount = 0, bool isLoading = false, bool? onlineDoctorStatus, ValueChanged<bool>? onlineDoctorChanged, VoidCallback? onNotificationScreen}) {
    Widget widget = Row(
      children: [
        Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            radius: 30.0,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatar,
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
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome Back', style: robotoRegular.copyWith(color: Colors.white)),
              Text('${username}', maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoBold.copyWith(color: AppColors.white))
            ],
          ),
        )
      ],
    );

    // Loading Widget
    if (isLoading) {
      widget = Row(
        children: [
          Shimmer.fromColors(
              child: Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: AppColors.quillGrey
                ),
              ),
              baseColor: AppColors.quillGrey,
              highlightColor: Colors.white
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 8,
                  width: 115,
                  child: Shimmer.fromColors(
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: AppColors.quillGrey,
                        ),
                      ),
                      baseColor: AppColors.quillGrey,
                      highlightColor: Colors.white
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 10,
                  width: 80,
                  child: Shimmer.fromColors(
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: AppColors.quillGrey,
                        ),
                      ),
                      baseColor: AppColors.quillGrey,
                      highlightColor: Colors.white
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: widget,
        ),
        notificationWidget(notificationCount, onNotificationScreen),
      ],
    );
  }

  static AppBar appBarHome(BuildContext context, String username, String avatar, {int notificationCount = 0, bool isLoading = false, VoidCallback? onNotificationScreen}) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.cadmiumOrange,
      toolbarHeight: 75,
      title: _appBarWidget(
        username, avatar,
        notificationCount: notificationCount,
        isLoading: isLoading,
        onNotificationScreen: onNotificationScreen
      ),
    );
  }

  static AppBar appBarWithLeading(BuildContext context, {required String title, VoidCallback? onPressed}) {
    return AppBar(
      centerTitle: true,
      leadingWidth: 80,
      leading: Stack(
        children: [
          Positioned(
            left: 20,
            child: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
              decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.30),
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
                  if (onPressed == null ) {
                    Navigator.pop(context);
                  } else {
                    onPressed;
                  }
                },
              ),
            ),
          )
        ],
      ),
      elevation: 0,
      backgroundColor: AppColors.cadmiumOrange,
      toolbarHeight: 70,
      title: Text(title, style: montserratRegular.copyWith(color: AppColors.white))
    );
  }

  static Widget appBarHomeWidget(BuildContext context, String username, String avatar, {int notificationCount = 0, bool isLoading = false, VoidCallback? onNotificationScreen}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 20, 17, 15),
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: _appBarWidget(
          username, avatar,
          notificationCount: notificationCount,
          isLoading: isLoading,
          onNotificationScreen: onNotificationScreen
      ),
    );
  }
}
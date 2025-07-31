import 'dart:collection';
import 'dart:io';

import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/appbar_home.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentScreen extends StatefulWidget {
  final String snapToken;
  final String url;
  final String familyParticipant;
  final double calculateAmount;

  const PaymentScreen({Key? key, required this.snapToken, required this.url, required this.familyParticipant, required this.calculateAmount}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey webViewKey = GlobalKey();
  DateTime? currentBackPressTime;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.cadmiumOrange,
        title: Text('Payment', style: montserratRegular.copyWith(color: AppColors.white)),
      ),
      body: WillPopScope(
        child: SafeArea(child: buildBody()),
        onWillPop: () {
          var currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
            return Future.value(false);
          } else {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null) {
              currentBackPressTime = now;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Press again to go back',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
              Navigator.pushReplacementNamed(context, mainScreen, arguments: {
                'currentIndex': 1,
              });

              return Future.value(true);
            }

            return Future.value(false);
          }

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Payment has been cancel.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
            decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ]
            ),
            child: Card(
              elevation: 4,
              color: AppColors.cadmiumOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_DEFAULT),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Family Participant ', style: TextStyle(color: AppColors.white)),
                        Text(widget.familyParticipant, textAlign: TextAlign.right, style: TextStyle(color: AppColors.white)),
                      ],
                    ),
                    Divider(color: AppColors.white),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Amount : ', style: TextStyle(color: AppColors.white)),
                              SizedBox(height: 2.h),
                              Text(Format.money(widget.calculateAmount), textAlign: TextAlign.right, style: montserratBold.copyWith(color: AppColors.white)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(AppColors.white),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Payment has been process.',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pushReplacementNamed(context, mainScreen, arguments: {
                              'currentIndex': 1,
                            });

                          },
                          child: Text(
                            'Close Payment',
                            style: TextStyle(
                                color: AppColors.cadmiumOrange,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return CustomScreen(
      withoutPadding: true,
      marginTop: 0,
      child: InAppWebView(
        key: webViewKey,
        // contextMenu: contextMenu,
        initialUrlRequest:
        URLRequest(url: Uri.parse(widget.url)),
        // initialFile: "assets/index.html",
        initialUserScripts: UnmodifiableListView<UserScript>([]),
        initialOptions: options,
        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
        },
        androidOnPermissionRequest:
            (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        shouldOverrideUrlLoading:
            (controller, navigationAction) async {
          var uri = navigationAction.request.url!;

          if (![
            "http",
            "https",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri.scheme)) {
            if (await canLaunchUrlString(url)) {
              // Launch the App
              await launchUrlString(
                url,
              );
              // and cancel the request
              return NavigationActionPolicy.CANCEL;
            }
          }

          return NavigationActionPolicy.ALLOW;
        },
        onLoadStop: (controller, url) async {
          pullToRefreshController.endRefreshing();
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
        },
        onLoadError: (controller, url, code, message) {
          pullToRefreshController.endRefreshing();
        },
        onProgressChanged: (controller, progress) {
          if (progress == 100) {
            pullToRefreshController.endRefreshing();
          }
          setState(() {
            this.progress = progress / 100;
            urlController.text = url;
          });
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
      )
    );
  }
}

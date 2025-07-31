import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/bloc/family_bloc/family_bloc.dart';
import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/data/shared_pref.dart';
import 'package:eccmobile/initialize.dart';
import 'package:eccmobile/screens/example/holiday_screen.dart';
import 'package:eccmobile/splash_screen.dart';
import 'package:eccmobile/util/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'onboarding_screen.dart';

final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialize();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => sl<EventBloc>()),
      BlocProvider(create: (context) => sl<AuthBloc>()),
      BlocProvider(create: (context) => sl<FamilyBloc>()),
    ],
    child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData.light();

    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: globalAlice.getNavigatorKey(),
          builder: (context, child) {
            MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                child: child!
            );
            return ScrollConfiguration(
              behavior: RemoveScrollGlowBehavior(),
              child: child,
            );
          },
          theme: ThemeData(
            colorScheme: ColorScheme(
                brightness: base.brightness,
                primary: AppColors.cadmiumOrange,
                onPrimary: AppColors.cadmiumOrange,
                secondary: AppColors.cadmiumOrange,
                onSecondary: AppColors.cadmiumOrange,
                error: base.errorColor,
                onError: base.errorColor,
                background: AppColors.cadmiumOrange,
                onBackground: AppColors.black,
                // The background color for widgets like Card.
                surface: AppColors.white,
                onSurface: AppColors.mountainMist
            ),
            appBarTheme: const AppBarTheme(
                color: Color(0xFFE5E5E5),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black)
            ),
            scaffoldBackgroundColor: AppColors.cadmiumOrange,
            //primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 16)
                    ),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                          } else if (states.contains(MaterialState.disabled)) {
                            return AppColors.quillGrey;
                          }

                          return AppColors.cadmiumOrange;
                        }
                    )
                )
            ),
            fontFamily: "Montserrat",
            textTheme: const TextTheme(
              bodyText1: TextStyle(color: Color(0xFF000000)),
              bodyText2: TextStyle(color: Color(0xFF000000)),
            ),
            //visualDensity: VisualDensity.adaptivePlatformDensity
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: splashScreen,
          onGenerateRoute: Routes().onGenerateRoute,
        );
      },
    );
  }
}

class RemoveScrollGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

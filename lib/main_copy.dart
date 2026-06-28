import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/core/theme/cubit/theme_cubit.dart';
import 'package:edulink_app/platform/Admin1/core/services/service_locator.dart';
import 'package:edulink_app/platform/Admin1/main_shell/main_shell.dart';
import 'package:edulink_app/platform/landing_page/cubit/admin_cubit.dart';
import 'package:edulink_app/platform/landing_page/cubit/login_cubit.dart';
import 'package:edulink_app/platform/landing_page/views/landing.dart';
import 'package:edulink_app/site/features/modrator/views/dashboard_screen.dart';
import 'package:edulink_app/site/features/teacher/views/dashboard_screen.dart';
import 'package:edulink_app/students/features/Messages/cubit/unread_messages_cubit.dart';
import 'package:edulink_app/students/features/Messages/data/messages_repo.dart';
import 'package:edulink_app/students/features/startScreens/splashScreen/splashScreen.dart';
import 'package:edulink_app/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupLocator();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/localization',
      fallbackLocale: Locale('en'),
      saveLocale: true,
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => AdminCubit(getIt(), getIt())),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => UnreadMessagesCubit(MessagesRepository()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            scrollBehavior: AppScrollBehavior(),
            theme: buildAppTheme(),
            darkTheme: buildDarkAppTheme(),
            themeMode:
                themeState.isDark ? ThemeMode.dark : ThemeMode.light,
            builder: (context, child) {
              ScreenConfig.init(context);
              return child!;
            },
            //home: Splashscreen(),
             home: LandingPage(),
            routes: {
              '/admin': (_) => const MainShell(),
              '/moderator': (_) => const ModratorDashboardScreen(),
              '/teacher': (_) => const TeacherDashboardScreen(),
            },
          );
        },
      ),
    );
  }
}

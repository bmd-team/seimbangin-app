import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seimbangin_app/blocs/analytics/analytics_bloc.dart';
import 'package:seimbangin_app/blocs/homepage/homepage_bloc.dart';
import 'package:seimbangin_app/blocs/transaction/transaction_bloc.dart';
import 'package:seimbangin_app/routes/routes.dart';
import 'package:seimbangin_app/services/transaction/transaction_service.dart';
import 'package:seimbangin_app/services/user_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:seimbangin_app/blocs/theme/theme_cubit.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_EN', null);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  ).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => HomepageBloc(userService: UserService())),
        BlocProvider(
          create: (context) =>
              TransactionBloc(transactionService: TransactionService()),
        ),
        BlocProvider(create: (context) => AnalyticsBloc()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: routes,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: mode,
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qris_analyzer/blocs/analyzer_bloc.dart';
import 'package:qris_analyzer/blocs/dashboard_bloc.dart';
import 'package:qris_analyzer/blocs/setting_bloc.dart';
import 'package:qris_analyzer/data/cached_code_repository.dart';
import 'package:qris_analyzer/data/favorite_code_repository.dart';
import 'package:qris_analyzer/screens/routes.dart';
import 'package:qris_analyzer/utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(const QrisAnalyzerApp(),);
}

class QrisAnalyzerApp extends StatelessWidget {
  const QrisAnalyzerApp({super.key,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designScreenSize,
      useInheritedMediaQuery: true,
      child: MultiProvider(
        providers: [
          RepositoryProvider(
            create: (_,) => CachedCodeRepository(),
            lazy: false,
          ),
          RepositoryProvider(
            create: (_,) => FavoriteCodeRepository(),
            lazy: false,
          ),
          BlocProvider(
            create: (_,) => SettingBloc(),
          ),
          BlocProvider(
            create: (_,) => AnalyzerBloc(
              RepositoryProvider.of<CachedCodeRepository>(_,),
            ),
          ),
          BlocProvider(
            create: (_,) => DashboardBloc(
              RepositoryProvider.of<CachedCodeRepository>(_,),
              RepositoryProvider.of<FavoriteCodeRepository>(_,),
            ),
            lazy: true,
          ),
        ],
        child: MaterialApp(
          title: 'QRIS Analyzer',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.red,
          ),
          routes: AppRoutes(),
        ),
      ),
    );
  }
}

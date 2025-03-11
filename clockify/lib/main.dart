import 'package:clockify/core/themes/theme.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/save_activity.dart';
import 'package:clockify/features/activity/data/datasources/activity_local_data_source.dart';
import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:clockify/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:clockify/features/activity/presentation/pages/activity_screen.dart';
import 'package:clockify/features/home/presentation/pages/home_screen.dart';
import 'package:clockify/features/login/presentation/pages/login_screen.dart';
import 'package:clockify/features/password/presentation/pages/password_screen.dart';
import 'package:clockify/features/create_account/presentation/pages/create_account_screen.dart';
import 'package:clockify/features/splash/presentation/pages/splash_screen.dart';
import 'package:clockify/features/timer/presentation/pages/timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setup Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityModelAdapter());
  final activityBox =  Hive.openBox<ActivityModel>('activityBox');

  // Data source, Repository
  final localDataSource = ActivityLocalDataSourceImpl(await activityBox);
  final activityRepository = ActivityRepositoryImpl(localDataSource: localDataSource);

  // Use cases
  final saveActivity = SaveActivity(activityRepository); 
  final getAllActivities = GetAllActivities(activityRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider<ActivityRepository>.value(value: activityRepository,),
        Provider<SaveActivity>.value(value: saveActivity),
        Provider<GetAllActivities>.value(value: getAllActivities,)
      ],
      child: MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/createAccount': (context) => CreateAccountScreen(),
        '/password': (context) => PasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/timer': (context) => TimerScreen(),
        '/activity': (context) => ActivityScreen()
      },
      theme: appTheme,
    );
  }
}

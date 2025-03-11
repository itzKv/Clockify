import 'package:clockify/core/themes/theme.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/save_activity.dart';
import 'package:clockify/features/activity/data/datasources/activity_local_data_source.dart';
import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:clockify/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:clockify/features/activity/presentation/pages/activity_screen.dart';
import 'package:clockify/features/activity/presentation/providers/activity_provider.dart';
import 'package:clockify/features/activity_detail/presentation/pages/activity_detail_screen.dart';
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
  final activityBox = await Hive.openBox<ActivityModel>('activityBox');

  // Data source, Repository
  final localDataSource = ActivityLocalDataSourceImpl(activityBox);
  final activityRepository = ActivityRepositoryImpl(localDataSource: localDataSource);

  // Use cases
  final saveActivity = SaveActivity(activityRepository); 
  final getAllActivities = GetAllActivities(activityRepository);
  final deleteActivity = DeleteActivity(activityRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ActivityProvider(
            getAllActivities: getAllActivities, 
            saveActivity: saveActivity, 
            deleteActivity: deleteActivity
          ),
        )
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
      onGenerateRoute: (settings) {
        if (settings.name == '/activityDetail') {
          final activity = settings.arguments as ActivityEntity;
          return MaterialPageRoute(
            builder: (context) => ActivityDetailScreen(activity: activity)
          );
        }
        return null;
      },
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/createAccount': (context) => CreateAccountScreen(),
        '/password': (context) => PasswordScreen(),
        '/home': (context) => HomeScreen(),
      },
      theme: appTheme,
    );
  }

}

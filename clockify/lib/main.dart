import 'package:clockify/core/network/dio_client.dart';
import 'package:clockify/core/themes/theme.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/create_activity.dart';
import 'package:clockify/features/activity/business/usecases/update_activity.dart';
import 'package:clockify/features/activity/data/datasources/activity_local_data_source.dart';
import 'package:clockify/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:clockify/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:clockify/features/activity/presentation/providers/activity_provider.dart';
import 'package:clockify/features/activity/presentation/pages/activity_detail_screen.dart';
import 'package:clockify/features/auth/business/usecases/forgot_password.dart';
import 'package:clockify/features/auth/business/usecases/login.dart';
import 'package:clockify/features/auth/business/usecases/register.dart';
import 'package:clockify/features/auth/business/usecases/reset_password.dart';
import 'package:clockify/features/auth/business/usecases/verify_email.dart';
import 'package:clockify/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clockify/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clockify/features/auth/presentation/pages/forgot_password.dart';
import 'package:clockify/features/auth/presentation/pages/login_screen.dart';
import 'package:clockify/features/auth/presentation/providers/auth_provider.dart';
import 'package:clockify/features/home/presentation/pages/home_screen.dart';
import 'package:clockify/features/auth/presentation/pages/password_screen.dart';
import 'package:clockify/features/auth/presentation/pages/create_account_screen.dart';
import 'package:clockify/core/session/business/usecases/clear_session.dart';
import 'package:clockify/core/session/business/usecases/get_session.dart';
import 'package:clockify/core/session/business/usecases/save_session.dart';
import 'package:clockify/core/session/data/datasources/session_local_data_source.dart';
import 'package:clockify/core/session/data/models/session_model.dart';
import 'package:clockify/core/session/data/repositories/session_repository_impl.dart';
import 'package:clockify/core/session/presentation/providers/session_provider.dart';
import 'package:clockify/core/widgets/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(SessionModelAdapter());
  Hive.registerAdapter(ActivityModelAdapter());

  // Open the boxes
      // TEMP
      // await Hive.deleteBoxFromDisk('sessionBox');
      // await Hive.deleteBoxFromDisk('activityBox');
  final sessionBox = await Hive.openBox<SessionModel>('sessionBox');
  final activityBox = await Hive.openBox<ActivityModel>('activityBox');
  // Clear old local data

  // Data sources
  final localActivityDataSource = ActivityLocalDataSourceImpl(activityBox);
  final localSessionDataSource = SessionLocalDataSourceImpl(sessionBox); 

  // Init Dio
  final dioClient = DioClient();

  final remoteAuthDataSource = AuthRemoteDataSourceImpl(dioClient);
  final remoteActivityDataSource = ActivityRemoteDataSourceImpl(dioClient);

  // Check connection
  final bool isOnline = await checkInternetConnection();

  // Repository & Use cases
    // AUTH
  final authRepository = AuthRepositoryImpl(remoteDataSource: remoteAuthDataSource);
  final loginUsecase = Login(authRepository);
  final registerUsecase = Register(authRepository);
  final verifyEmailUsecase = VerifyEmail(authRepository);
  final forgotPasswordUseCase = ForgotPassword(authRepository);
  final resetPasswordUseCase = ResetPassword(authRepository);

    // --- SESSION
  final sessionRepository = SessionRepositoryImpl(localDataSource: localSessionDataSource);
  final saveSession = SaveSession(sessionRepository);
  final getSession = GetSession(sessionRepository);
  final clearSession = ClearSession(sessionRepository);
  final sessionProvider = SessionProvider(
    saveSession: saveSession, 
    getSession: getSession, 
    clearSession: clearSession
  );
  debugPrint("Is Connected to Internet: $isOnline");
    // --- ACTIVITY
  final activityRepository = ActivityRepositoryImpl(localDataSource: localActivityDataSource, remoteDataSource: remoteActivityDataSource, sessionProvider: sessionProvider, isOnline: isOnline);
  final createActivity = CreateActivity(activityRepository);
  final updateActivity = UpdateActivity(activityRepository); 
  final getAllActivities = GetAllActivities(activityRepository);
  final deleteActivity = DeleteActivity(activityRepository);


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ActivityProvider(
            getAllActivities: getAllActivities, 
            createActivity: createActivity, 
            updateActivity: updateActivity,
            deleteActivity: deleteActivity,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionProvider(
            saveSession: saveSession, 
            getSession: getSession, 
            clearSession: clearSession,
          )..loadUserSession(), // load session when app starts
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            login: loginUsecase, 
            register: registerUsecase, 
            verifyEmail: verifyEmailUsecase,
            forgotPassword: forgotPasswordUseCase,
            resetPassword: resetPasswordUseCase,
            sessionProvider: sessionProvider
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
    return FutureBuilder<bool>(
      future: checkInternetConnection(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        }
        final isOnline = snapshot.data ?? false; 

        return Consumer<SessionProvider>(
          builder: (context, sessionProvider, child) {
            if (sessionProvider.session == null && !isOnline) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: LoginScreen(),
              );
            } else {
              return MaterialApp(
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  if (settings.name == '/activityDetail') {
                    final activity = settings.arguments as ActivityEntity;
                    return PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ActivityDetailScreen(activity: activity),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 300),
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
                  'forgotPassword': (context) => ForgotPasswordScreen(),
                },
                theme: appTheme,
              );
            }
          },
        );
      },
    );
  }
}

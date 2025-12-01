import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_splash/flutter_native_splash.dart';

// ✅ Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// 🔥 NotificationManager import EDİLMESİ GEREKİYOR
import 'managers/notification_manager.dart';

// Services
import 'core/services/token_storage_service.dart';
import 'core/services/api_service.dart';
import 'core/services/connection_service.dart';

// Data sources
import 'data/sources/user_remote_data_source.dart';
import 'data/sources/auth_remote_data_source.dart';
import 'data/sources/place_remote_data_source.dart';
import 'data/sources/feedback_remote_data_source.dart';
import 'data/sources/favorite_remote_data_source.dart';
import 'data/sources/event_remote_data_source.dart';
import 'data/sources/follow_remote_data_source.dart';
import 'data/sources/profile_view_remote_data_source.dart';
import 'data/sources/subscription_remote_data_source.dart';
import 'data/sources/message_access_remote_data_source.dart';
import 'data/sources/restriction_remote_data_source.dart';
import 'data/sources/message_remote_data_source.dart';

import 'data/sources/app_notification_remote_data_source.dart';
import 'data/sources/fcm_token_remote_data_source.dart';

// Repositories
import 'data/repositories/user_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/place_repository.dart';
import 'data/repositories/feedback_repository.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/event_repository.dart';
import 'data/repositories/follow_repository.dart';
import 'data/repositories/profile_view_repository.dart';
import 'data/repositories/subscription_repository.dart';
import 'data/repositories/message_access_repository.dart';
import 'data/repositories/restriction_repository.dart';
import 'data/repositories/message_repository.dart';

import 'data/repositories/app_notification_repository.dart';
import 'data/repositories/fcm_token_repository.dart';

// Navigation
import 'navigation/main_navigation_wrapper.dart';
import 'screens/01_welcome_screen/01_welcome_screen.dart';
import 'models/user_model.dart';

// States
import 'states/user_state_notifier.dart';
import 'states/place_state_notifier.dart';
import 'states/event_state_notifier.dart';
import 'states/follow_state_notifier.dart';
import 'states/profile_view_state_notifier.dart';
import 'states/subscription_state_notifier.dart';
import 'states/message_access_state_notifier.dart';
import 'states/restriction_state_notifier.dart';

import 'states/app_notification_state_notifier.dart';
import 'states/fcm_token_state_notifier.dart';

import 'managers/language_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late PlaceStateNotifier placeNotifier;
late EventStateNotifier eventNotifier;
late UserStateNotifier userNotifier;

// 🔥 BACKGROUND HANDLER → main'in EN ÜSTÜNE EKLENMESİ ZORUNLU
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationManager.firebaseMessagingBackgroundHandler(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 iOS Arka plan push için ZORUNLU
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FlutterError.onError = (FlutterErrorDetails details) {
    final message = details.exceptionAsString();
    if (message.contains('HTTP request failed, statusCode: 403') &&
        message.contains('maps.googleapis.com/maps/api/place/photo')) {
      return;
    }
    FlutterError.dumpErrorToConsole(details);
  };

  // ✅ Firebase başlat
  await Firebase.initializeApp();

  // 🔥🔥🔥 FCM Notification Manager BURADA çalıştırılmalı
  await NotificationManager().initialize(requestPermission: true);

  // Splash ve timezone setup
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  tz.initializeTimeZones();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  final languageManager = LanguageManager();
  await languageManager.loadLocale();

  final apiService = ApiService();

  // Data sources
  final userDataSource = UserRemoteDataSource(apiService);
  final authDataSource = AuthRemoteDataSource(apiService);
  final placeDataSource = PlaceRemoteDataSource(apiService);
  final feedbackDataSource = FeedbackRemoteDataSource(apiService);
  final favoriteDataSource = FavoriteRemoteDataSource(apiService);
  final eventDataSource = EventRemoteDataSource(apiService);
  final followDataSource = FollowRemoteDataSource(apiService);
  final profileViewDataSource = ProfileViewRemoteDataSource(apiService);
  final subscriptionDataSource = SubscriptionRemoteDataSource(apiService);
  final messageAccessDataSource = MessageAccessRemoteDataSource(apiService);
  final restrictionDataSource = RestrictionRemoteDataSource(apiService);
  final messageDataSource = MessageRemoteDataSource(apiService);

  final appNotificationDataSource = AppNotificationRemoteDataSource(apiService);
  final fcmTokenDataSource = FcmTokenRemoteDataSource(apiService);

  // Repositories
  final userRepo = UserRepository(userDataSource);
  final authRepo = AuthRepository(authDataSource);
  final placeRepo = PlaceRepository(placeDataSource);
  final feedbackRepo = FeedbackRepository(feedbackDataSource);
  final favoriteRepo = FavoriteRepository(favoriteDataSource);
  final eventRepo = EventRepository(eventDataSource);
  final followRepo = FollowRepository(followDataSource);
  final profileViewRepo = ProfileViewRepository(profileViewDataSource);
  final subscriptionRepo = SubscriptionRepository(subscriptionDataSource);
  final messageAccessRepo = MessageAccessRepository(messageAccessDataSource);
  final restrictionRepo = RestrictionRepository(restrictionDataSource);
  final messageRepo = MessageRepository(messageDataSource);

  final appNotificationRepo = AppNotificationRepository(appNotificationDataSource);
  final fcmTokenRepo = FcmTokenRepository(fcmTokenDataSource);

  // State notifiers
  eventNotifier = EventStateNotifier(eventRepo);
  placeNotifier = PlaceStateNotifier(
    placeRepo: placeRepo,
    feedbackRepo: feedbackRepo,
    favoriteRepo: favoriteRepo,
  );
  userNotifier = UserStateNotifier(
    authRepo: authRepo,
    userRepo: userRepo,
  );

  await placeNotifier.loadFavorites();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<UserRepository>.value(value: userRepo),
        Provider<AuthRepository>.value(value: authRepo),
        Provider<PlaceRepository>.value(value: placeRepo),
        Provider<FeedbackRepository>.value(value: feedbackRepo),
        Provider<FavoriteRepository>.value(value: favoriteRepo),
        Provider<EventRepository>.value(value: eventRepo),
        Provider<FollowRepository>.value(value: followRepo),
        Provider<ProfileViewRepository>.value(value: profileViewRepo),
        Provider<SubscriptionRepository>.value(value: subscriptionRepo),
        Provider<MessageAccessRepository>.value(value: messageAccessRepo),
        Provider<RestrictionRepository>.value(value: restrictionRepo),
        Provider<MessageRepository>.value(value: messageRepo),
        Provider<AppNotificationRepository>.value(value: appNotificationRepo),
        Provider<FcmTokenRepository>.value(value: fcmTokenRepo),

        ChangeNotifierProvider.value(value: userNotifier),
        ChangeNotifierProvider.value(value: placeNotifier),
        ChangeNotifierProvider.value(value: eventNotifier),
        ChangeNotifierProvider.value(value: languageManager),

        ChangeNotifierProvider(create: (_) => FollowStateNotifier(followRepo)),
        ChangeNotifierProvider(create: (_) => ProfileViewStateNotifier(profileViewRepo)),
        ChangeNotifierProvider(create: (_) => SubscriptionStateNotifier(subscriptionRepo)),
        ChangeNotifierProvider(create: (_) => MessageAccessStateNotifier(messageAccessRepo)),
        ChangeNotifierProvider(create: (_) => RestrictionStateNotifier(restrictionRepo)),

        ChangeNotifierProvider(
          create: (context) => AppNotificationStateNotifier(
            appNotificationRepo,
            context.read<MessageRepository>(),
          ),
        ),

        ChangeNotifierProvider(create: (_) => FcmTokenStateNotifier(fcmTokenRepo)),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<(Widget, User?)> _initialScreenFuture;

  @override
  void initState() {
    super.initState();
    _initialScreenFuture = determineInitialScreen();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ConnectionService().init(navigatorKey);
    });
  }

  @override
  void dispose() {
    ConnectionService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);

    return FutureBuilder<(Widget, User?)>(
      future: _initialScreenFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final (screen, user) = snapshot.data!;

        if (user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            userNotifier.setUser(user);
            final parsedCity = user.location.split(',').first.trim();
            await placeNotifier.loadPlaces(city: parsedCity);
          });
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FlutterNativeSplash.remove();
        });

        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'TieWork',
          debugShowCheckedModeBanner: false,
          locale: languageManager.locale,
          supportedLocales: LanguageManager.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            colorScheme: const ColorScheme.light(
              primary: Colors.white,
              surface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black54,
            ),
          ),
          home: screen,
        );
      },
    );
  }
}

Future<(Widget, User?)> determineInitialScreen() async {


  final tokenService = TokenStorageService();

  // 🔍 Mevcut tokenları oku
  final storedAccessToken = await tokenService.getToken();
  final storedRefreshToken = await tokenService.getRefreshToken();



  // Refresh token yoksa direkt onboarding
  if (storedRefreshToken == null) {
  
    return (const WelcomeScreen(), null);
  }

  try {
  

    final apiService = ApiService();
    final userRepo = UserRepository(UserRemoteDataSource(apiService));

    // Refresh isteği
    final response = await apiService.post('/api/Auth/refresh', {
      'refreshToken': storedRefreshToken,
    });


    print(response.data);

    final data = response.data['data'];

    if (data == null) {
      
      return (const WelcomeScreen(), null);
    }

    final newAccessToken = data['accessToken'];
    final newRefreshToken = data['refreshToken'];



    if (newAccessToken == null || newRefreshToken == null) {
    
      return (const WelcomeScreen(), null);
    }

    await tokenService.saveToken(newAccessToken, newRefreshToken);

    final savedAccess = await tokenService.getToken();
    final savedRefresh = await tokenService.getRefreshToken();

    try {
      final user = await userRepo.getMe();

      return (const MainNavigationWrapper(initialIndex: 0), user);

    } catch (e) {
      
      return (const WelcomeScreen(), null);
    }

  } catch (e) {
    
    return (const WelcomeScreen(), null);
  } finally {
  
    FlutterNativeSplash.remove();
  }
}



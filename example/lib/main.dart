import 'package:dio/dio.dart';
import 'package:dio_spy/dio_spy.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final DioSpy _dioSpy;
  late final Dio _dio;
  late final ApiService _apiService;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeDio();
  }

  void _initializeDio() {
    // Initialize DioSpy with shake gesture enabled
    _dioSpy = DioSpy(
      showOnShake: true,
      maxCalls: 1000,
    );

    // Set the navigator key (required for DioSpy to work)
    _dioSpy.setNavigatorKey(_navigatorKey);

    // Initialize Dio with interceptors
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add DioSpy interceptor to Dio
    _dio.interceptors.add(_dioSpy.interceptor);

    // Optional: Add logging interceptor for console output
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );

    // Initialize API service
    _apiService = ApiService(_dio);
  }

  @override
  void dispose() {
    _dioSpy.dispose();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DioSpy Example',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: HomeScreen(apiService: _apiService),
      debugShowCheckedModeBanner: false,
    );
  }
}

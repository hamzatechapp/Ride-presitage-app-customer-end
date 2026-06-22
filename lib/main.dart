import 'package:customer_end_app/theme/app_theme.dart';
import 'package:customer_end_app/view/screens/splash_screen.dart';
import 'package:customer_end_app/viewmodels/map_viewmodel.dart';
import 'package:customer_end_app/viewmodels/booking_viewmodel.dart';
import 'package:customer_end_app/viewmodels/driver_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => BookingViewModel()),
        ChangeNotifierProvider(create: (_) => DriverViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Prestige',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}
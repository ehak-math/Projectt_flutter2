// filepath: e:\flutter\time_tracking\lib\main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/providers/race_provider.dart';
import 'package:time_tracking/providers/segment_time_provider.dart';
import 'package:time_tracking/screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/participant_provider.dart';
import 'providers/sagment_provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RaceProvider()),
        ChangeNotifierProvider(create: (_) => SegmentTimeProvider()),
        ChangeNotifierProvider(create: (_) => SegmentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Triathlon Tracker',
      home: LoginScreen(), // Set initial screen
    );
  }
}
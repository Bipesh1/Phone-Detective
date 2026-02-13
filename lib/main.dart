// Phone Detective - Main Entry Point

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/game_state_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Supabase

  await Supabase.initialize(
    url: 'https://blclthryzbdpbtaradsc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJsY2x0aHJ5emJkcGJ0YXJhZHNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5NDY4NTksImV4cCI6MjA4NjUyMjg1OX0.aDDn-FGk2JeAqIZbwjnyTMHWdeaAveQqe2E3zeJmgg0',
  );
  // Supabase initialized

  // Initialize game state
  final gameState = GameStateProvider();
  await gameState.init();

  runApp(
    ChangeNotifierProvider.value(
      value: gameState,
      child: const PhoneDetectiveApp(),
    ),
  );
}

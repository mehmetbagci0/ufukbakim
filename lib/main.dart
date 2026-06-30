import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/app_state.dart';

void main() {
  runApp(const UfukAsansorBakimApp());
}

class UfukAsansorBakimApp extends StatefulWidget {
  const UfukAsansorBakimApp({super.key});

  @override
  State<UfukAsansorBakimApp> createState() => _UfukAsansorBakimAppState();
}

class _UfukAsansorBakimAppState extends State<UfukAsansorBakimApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ufuk Asansör Bakım',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(appState: _appState),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:virtual_home_demo/screens/welcome_screen.dart';
import 'package:virtual_home_demo/state/smart_home_state.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';

void main() {
  runApp(const VirtualHomeApp());
}

class VirtualHomeApp extends StatefulWidget {
  const VirtualHomeApp({super.key});

  @override
  State<VirtualHomeApp> createState() => _VirtualHomeAppState();
}

class _VirtualHomeAppState extends State<VirtualHomeApp> {
  late final SmartHomeState _homeState;

  @override
  void initState() {
    super.initState();
    _homeState = SmartHomeState();
  }

  @override
  void dispose() {
    _homeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartHomeScope(
      notifier: _homeState,
      child: MaterialApp(
        title: 'Virtual Home',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const WelcomeScreen(),
      ),
    );
  }
}

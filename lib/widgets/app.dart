import 'package:flutter/material.dart';
import 'package:kurs_app/widgets/start_page.dart';
import 'package:kurs_app/widgets/user_profile.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(),
    );
  }
}

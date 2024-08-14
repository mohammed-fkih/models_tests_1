import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:models_tests_1/control/creatACcounte.dart';
import 'package:models_tests_1/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نماذج إختبارات',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home:   isLoggedIn ? const MyTabPage() : const CreateACcount(),
      
    );
  }
}

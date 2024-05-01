import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:specathon/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Connect',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF4BAE6C), 
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4BAE6C),
        ),
      ),
      debugShowCheckedModeBanner: false,      
      home: const EmailPasswordLogin(),
    );
  }
}
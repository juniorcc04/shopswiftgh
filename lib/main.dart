import 'package:adminpanelapp/firebase_options.dart';
import 'package:adminpanelapp/screens/splash/splash_screen.dart';
import 'package:adminpanelapp/screens/home/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 🔑 Use StreamBuilder to listen to auth state changes
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Loading indicator while checking
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If logged in → go to Home
          if (snapshot.hasData) {
            return HomeView();
          }

          // If not logged in → go to Splash (then Login/Signup)
          return const SplashScreen();
        },
      ),
    );
  }
}

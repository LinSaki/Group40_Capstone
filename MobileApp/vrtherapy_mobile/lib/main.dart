import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'screens/welcome_screen.dart';
//import 'screens/login_screen.dart';
import 'screens/patient_home_screen.dart';
import 'screens/therapist_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    Widget homeWidget;
    if (authProvider.token != null) {
      homeWidget = authProvider.role == 'PATIENT'
          ? const PatientHomeScreen()
          : const TherapistHomeScreen();
    } else {
      homeWidget = const WelcomeScreen();
    }

    return MaterialApp(
      title: 'therapīa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,  
        textTheme: GoogleFonts.nunitoSansTextTheme(),  
        colorScheme: ColorScheme.light(
          primary: Color(0xFFB8C1EC), 
          secondary: Color(0xFFFAE1DD), 
          background: Color(0xFFFDE2E4), 
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB8C1EC),  
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          elevation: 5,
        ),
      ),
      home: homeWidget,
    );
  }
}

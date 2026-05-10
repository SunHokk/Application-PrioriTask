import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_routes.dart';
import 'core/constants.dart';

void main() {
  runApp(const PrioriTaskApp());
}

class PrioriTaskApp extends StatelessWidget {
  const PrioriTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrioriTask',
      debugShowCheckedModeBanner: false,
      // Mengatur tema global aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(AppConstants.primaryColor),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // Menggunakan sistem routing pusat
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
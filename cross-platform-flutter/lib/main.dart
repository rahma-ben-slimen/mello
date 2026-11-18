
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/welcome_page.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MelloApp());
}

class MelloApp extends StatelessWidget {
  const MelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mello',
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: MelloColors.linen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MelloColors.cocoa,
          primary: MelloColors.cocoa,
          secondary: MelloColors.camel,
          surface: MelloColors.linen,
        ),
        fontFamily: 'Roboto',
      ),
      home: const WelcomePage(),
    );
  }
}

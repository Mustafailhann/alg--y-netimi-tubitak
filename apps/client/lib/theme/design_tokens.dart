import 'package:flutter/material.dart';

abstract class AppColors {
  // Common Semantic Colors
  static const Color success = Color(0xFF2A9D8F);
  static const Color warning = Color(0xFFF4A261);
  static const Color info = Color(0xFF457B9D);
  static const Color error = Color(0xFFE76F51);
  static const Color disabled = Color(0xFFBDBDBD);

  // Gamified Student Theme
  static const Color studentPrimary = Color(0xFF1B263B);
  static const Color studentSecondary = Color(0xFF00A896);
  static const Color studentAccent = Color(0xFFF4A261);
  static const Color studentSurface = Color(0xFFF8F9FA);
  static const Color studentBackground = Color(0xFFE9ECEF);
  static const Color studentOnPrimary = Color(0xFFFFFFFF);
  static const Color studentOnSurface = Color(0xFF2B2D42);

  // Digital Forensics Theme (Canvas)
  static const Color forensicsPrimary = Color(0xFF11151C);
  static const Color forensicsSecondary = Color(0xFF00F5D4);
  static const Color forensicsAccent = Color(0xFFF15BB5);
  static const Color forensicsSurface = Color(0xFF212529);
  static const Color forensicsBackground = Color(0xFF000000);
  static const Color forensicsOnPrimary = Color(0xFFFFFFFF);
  static const Color forensicsOnSurface = Color(0xFFE9ECEF);

  // Professional Admin/Teacher Theme
  static const Color adminPrimary = Color(0xFF2B2D42);
  static const Color adminSecondary = Color(0xFF8D99AE);
  static const Color adminAccent = Color(0xFF0077B6);
  static const Color adminSurface = Color(0xFFFFFFFF);
  static const Color adminBackground = Color(0xFFEDF2F4);
  static const Color adminOnPrimary = Color(0xFFFFFFFF);
  static const Color adminOnSurface = Color(0xFF11151C);
}

abstract class AppSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

abstract class AppRadius {
  static const double none = 0.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double pill = 999.0;
}

abstract class AppShadows {
  static final List<BoxShadow> studentCard = [
    BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 6)),
  ];
  
  static final List<BoxShadow> adminCard = [
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
  ];
}

abstract class AppMotion {
  static const Duration transitionDuration = Duration(milliseconds: 200);
  
  static const Duration hoverDuration = Duration(milliseconds: 150);
  static const Curve hoverCurve = Curves.easeOut;
  
  static const Duration pressDuration = Duration(milliseconds: 100);
  static const Curve pressCurve = Curves.easeIn;
  
  static const Duration successDuration = Duration(milliseconds: 500);
  static const Curve successCurve = Curves.elasticOut;
  
  static const Duration errorDuration = Duration(milliseconds: 300);
  static const Curve errorCurve = Curves.linear;
}

abstract class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
}

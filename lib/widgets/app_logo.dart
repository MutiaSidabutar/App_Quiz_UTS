import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/responsive.dart';

/// Logo aplikasi: stopwatch + tanda tanya, dengan teks "QUIZ" opsional.
class AppLogo extends StatelessWidget {
  /// Ukuran logo sebagai fraksi dari sisi terpendek layar.
  final double sizeFactor;
  final bool showText;

  const AppLogo({super.key, this.sizeFactor = 0.4, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize.shortestSide * sizeFactor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/logo.svg',
          width: size,
          height: size,
          semanticsLabel: 'Logo Quiz App',
        ),
        if (showText)
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
            ).createShader(bounds),
            child: Text(
              'QUIZ',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.32,
                fontWeight: FontWeight.w700,
                letterSpacing: size * 0.04,
                height: 1.1,
              ),
            ),
          ),
      ],
    );
  }
}

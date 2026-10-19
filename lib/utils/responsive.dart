import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Jenis perangkat berdasarkan lebar layar (breakpoint Material).
enum DeviceType { mobile, tablet, desktop }

/// Helper ukuran dinamis agar UI menyesuaikan ukuran layar,
/// dipakai lewat `context.rw(...)`, `context.sp(...)`, dst.
extension Responsive on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isLandscape => screenWidth > screenHeight;

  DeviceType get deviceType {
    if (screenWidth >= 1024) return DeviceType.desktop;
    if (screenWidth >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isWide => !isMobile;

  /// Faktor skala relatif terhadap layar acuan 390 dp (sisi terpendek),
  /// dibatasi agar teks tidak terlalu kecil/besar di tablet & web.
  double get scale =>
      (screenSize.shortestSide / 390).clamp(0.85, 1.35).toDouble();

  /// Persentase lebar layar.
  double rw(double fraction) => screenWidth * fraction;

  /// Persentase tinggi layar.
  double rh(double fraction) => screenHeight * fraction;

  /// Ukuran (font, ikon, padding, radius) yang diskalakan sesuai layar.
  double sp(double size) => size * scale;

  /// Lebar maksimum konten supaya tidak melebar di tablet / browser.
  double get maxContentWidth => switch (deviceType) {
        DeviceType.mobile => screenWidth,
        DeviceType.tablet =>
          isLandscape ? screenWidth * 0.94 : math.min(screenWidth * 0.85, 720),
        DeviceType.desktop => math.min(screenWidth * 0.8, 1100),
      };

  /// Layout dua kolom untuk layar landscape (HP/tablet) atau layar
  /// sangat lebar (web/desktop); portrait tetap satu kolom.
  bool useTwoColumns(double availableWidth) =>
      availableWidth >= 600 && (isLandscape || availableWidth >= 840);
}

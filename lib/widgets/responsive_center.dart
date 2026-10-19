import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Membatasi lebar konten agar tetap proporsional di tablet & browser,
/// sekaligus memberi padding horizontal yang menyesuaikan layar.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveCenter({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      // Tinggi mengikuti anak, agar aman dipakai di bottomNavigationBar.
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? context.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.sp(20)),
          child: child,
        ),
      ),
    );
  }
}

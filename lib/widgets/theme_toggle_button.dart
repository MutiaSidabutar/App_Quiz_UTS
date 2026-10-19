import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return IconButton(
      tooltip: theme.isDark ? 'Mode Terang' : 'Mode Gelap',
      onPressed: theme.toggleTheme,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) =>
            RotationTransition(turns: anim, child: child),
        child: Icon(
          theme.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey(theme.isDark),
        ),
      ),
    );
  }
}

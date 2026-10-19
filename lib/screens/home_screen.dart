import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/app_logo.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        actions: [
          const ThemeToggleButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(sizeFactor: 0.35),
            SizedBox(height: context.sp(24)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Masukkan Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Mulai Kuis',
              onPressed: () {
                if (_nameController.text.trim().isEmpty) return;
                provider.setUserName(_nameController.text.trim());
                Navigator.pushNamed(context, '/quiz');
              },
            ),
          ],
        ),
      ),
    );
  }
}

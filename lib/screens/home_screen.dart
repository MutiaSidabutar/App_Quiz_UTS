import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/app_logo.dart';
import '../widgets/category_card.dart';
import '../widgets/continue_quiz_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/responsive_center.dart';
import '../widgets/theme_toggle_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: context.read<QuizProvider>().userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _startQuiz() async {
    final provider = context.read<QuizProvider>();
    if (provider.hasQuizInProgress) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Mulai kuis baru?'),
          content: const Text('Progres kuis yang sedang berjalan akan hilang.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Mulai Baru'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    provider
      ..setUserName(_nameController.text.trim())
      ..startQuiz();
    Navigator.pushNamed(context, '/quiz');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final canStart = _nameController.text.trim().isNotEmpty &&
        provider.selectedCategory != null;

    final header = _Header(nameController: _nameController, onChanged: () => setState(() {}));
    final categories = _CategorySection(
      canStart: canStart,
      onStart: _startQuiz,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: context.sp(16)),
          child: ResponsiveCenter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Tablet / web / landscape lebar: dua kolom berdampingan.
                if (constraints.maxWidth >= 700) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: header),
                      SizedBox(width: context.sp(24)),
                      Expanded(flex: 6, child: categories),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header,
                    SizedBox(height: context.sp(24)),
                    categories,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onChanged;

  const _Header({required this.nameController, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final text = Theme.of(context).textTheme;
    final category = provider.selectedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLogo(sizeFactor: context.isLandscape ? 0.22 : 0.32),
        SizedBox(height: context.sp(8)),
        Text(
          'Uji pengetahuanmu dan raih skor tertinggi!',
          textAlign: TextAlign.center,
          style: text.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.sp(24)),
        TextField(
          controller: nameController,
          onChanged: (_) => onChanged(),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Nama kamu',
            hintText: 'Masukkan nama',
            prefixIcon: Icon(Icons.person_rounded),
          ),
        ),
        if (provider.hasQuizInProgress && category != null) ...[
          SizedBox(height: context.sp(16)),
          ContinueQuizCard(
            category: category,
            answered: provider.answeredCount,
            total: provider.totalQuestions,
            onContinue: () => Navigator.pushNamed(context, '/quiz'),
          ),
        ],
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final bool canStart;
  final VoidCallback onStart;

  const _CategorySection({required this.canStart, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Pilih Kategori',
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: context.sp(12)),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns =
                (constraints.maxWidth / context.sp(170)).floor().clamp(2, 4);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: context.sp(12),
                crossAxisSpacing: context.sp(12),
                // Bagian gambar ikut skala layar, bagian teks ikut skala font.
                mainAxisExtent: context.sp(96) +
                    MediaQuery.textScalerOf(context).scale(112),
              ),
              itemBuilder: (context, i) {
                final category = provider.categories[i];
                return CategoryCard(
                  category: category,
                  isSelected: provider.selectedCategory?.id == category.id,
                  bestScore: provider.bestScoreFor(category.id),
                  onTap: () => provider.selectCategory(category),
                );
              },
            );
          },
        ),
        SizedBox(height: context.sp(20)),
        PrimaryButton(
          label: 'Mulai Kuis',
          icon: Icons.play_arrow_rounded,
          onPressed: canStart ? onStart : null,
        ),
        if (!canStart) ...[
          SizedBox(height: context.sp(8)),
          Text(
            'Isi nama dan pilih kategori untuk memulai',
            textAlign: TextAlign.center,
            style: text.bodySmall,
          ),
        ],
      ],
    );
  }
}

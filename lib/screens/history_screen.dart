import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_history_model.dart';
import '../providers/quiz_provider.dart';
import '../themes/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_logo.dart';
import '../widgets/history_tile.dart';
import '../widgets/responsive_center.dart';
import '../widgets/stat_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  /// null = semua kategori.
  String? _categoryFilter;

  Future<void> _confirmClear() async {
    final provider = context.read<QuizProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_sweep_rounded),
        title: const Text('Hapus semua riwayat?'),
        content: const Text('Riwayat yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.wrong),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) provider.clearHistory();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuizProvider>();
    final entries = _categoryFilter == null
        ? p.history
        : p.history.where((h) => h.categoryId == _categoryFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kuis'),
        actions: [
          if (p.history.isNotEmpty)
            IconButton(
              tooltip: 'Hapus semua',
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: _confirmClear,
            ),
        ],
      ),
      body: SafeArea(
        child: !p.isHistoryLoaded
            ? const Center(child: CircularProgressIndicator())
            : p.history.isEmpty
                ? const _EmptyHistory()
                : ResponsiveCenter(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _Summary(entries: entries)),
                        SliverToBoxAdapter(child: _filterChips(p)),
                        if (entries.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text('Belum ada riwayat di kategori ini.',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          )
                        else
                          SliverList.builder(
                            itemCount: entries.length,
                            itemBuilder: (context, i) => _dismissible(p, entries[i]),
                          ),
                        SliverToBoxAdapter(child: SizedBox(height: context.sp(16))),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _filterChips(QuizProvider p) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.sp(10)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: context.sp(8)),
              child: ChoiceChip(
                label: const Text('Semua'),
                selected: _categoryFilter == null,
                onSelected: (_) => setState(() => _categoryFilter = null),
              ),
            ),
            for (final c in p.categories)
              Padding(
                padding: EdgeInsets.only(right: context.sp(8)),
                child: ChoiceChip(
                  label: Text(c.name),
                  selected: _categoryFilter == c.id,
                  onSelected: (_) => setState(() => _categoryFilter = c.id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dismissible(QuizProvider p, QuizHistory entry) {
    final category = p.categories.where((c) => c.id == entry.categoryId).firstOrNull;
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: context.sp(20)),
        margin: EdgeInsets.symmetric(vertical: context.sp(6)),
        decoration: BoxDecoration(
          color: AppTheme.wrong,
          borderRadius: BorderRadius.circular(context.sp(20)),
        ),
        child: Icon(Icons.delete_rounded, color: Colors.white, size: context.sp(26)),
      ),
      onDismissed: (_) {
        p.deleteHistory(entry.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Riwayat ${entry.categoryName} dihapus')),
        );
      },
      child: HistoryTile(entry: entry, category: category),
    );
  }
}

class _Summary extends StatelessWidget {
  final List<QuizHistory> entries;

  const _Summary({required this.entries});

  @override
  Widget build(BuildContext context) {
    final count = entries.length;
    final average = count == 0
        ? 0
        : (entries.fold<int>(0, (sum, h) => sum + h.nilai) / count).round();
    final best = entries.fold<int>(0, (m, h) => h.nilai > m ? h.nilai : m);
    final scheme = Theme.of(context).colorScheme;

    final tiles = [
      StatTile(
        icon: Icons.assignment_rounded,
        value: '$count',
        label: 'Kuis selesai',
        color: scheme.primary,
      ),
      StatTile(
        icon: Icons.insights_rounded,
        value: '$average',
        label: 'Rata-rata',
        color: Colors.orange.shade700,
      ),
      StatTile(
        icon: Icons.emoji_events_rounded,
        value: '$best',
        label: 'Nilai tertinggi',
        color: AppTheme.correct,
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(top: context.sp(8)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < tiles.length; i++) ...[
              if (i > 0) SizedBox(width: context.sp(10)),
              Expanded(child: tiles[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.sp(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.6,
              child: AppLogo(sizeFactor: 0.3, showText: false),
            ),
            SizedBox(height: context.sp(16)),
            Text('Belum ada riwayat',
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: context.sp(4)),
            Text(
              'Selesaikan kuis pertamamu, hasilnya akan tercatat di sini.',
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

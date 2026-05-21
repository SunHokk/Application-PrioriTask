import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../models/task.dart';
import '../services/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen>
    with SingleTickerProviderStateMixin {
  late double _progress;
  final _noteController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _progress = widget.task.progressPercent;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        // Selalu ambil task terbaru dari provider agar data selalu sinkron
        final task = provider.tasks.firstWhere(
          (t) => t.id == widget.task.id,
          orElse: () => widget.task,
        );
        final diffColor = _difficultyColor(task.difficulty);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.subjectName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.taskName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: const [
                    Tab(text: 'Detail & Progress'),
                    Tab(text: 'Riwayat Progress'),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailTab(task, diffColor),
                _buildHistoryTab(task),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Tab 1: Detail & Update Progress ──────────────────────────────────────

  Widget _buildDetailTab(Task task, Color diffColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Deadline',
                  value: DateFormat('d MMM yyyy, HH:mm').format(task.deadline),
                  color: task.isOverdue ? AppColors.urgent : AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoCard(
                  icon: Icons.signal_cellular_alt_rounded,
                  label: 'Kesulitan',
                  value: _difficultyLabel(task.difficulty),
                  color: diffColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.timer_outlined,
                  label: 'Sisa Waktu',
                  value: task.isOverdue
                      ? 'Terlambat'
                      : '${task.daysUntilDeadline} hari lagi',
                  color:
                      task.isOverdue ? AppColors.urgent : AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoCard(
                  icon: Icons.trending_up_rounded,
                  label: 'Skor Prioritas',
                  value: task.priorityScore != null
                      ? task.priorityScore!.toStringAsFixed(1)
                      : '-',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Deskripsi',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(
                task.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            'Update Progress',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressSection(task),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProgressSection(Task task) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 10,
            percent: _progress / 100,
            center: Text(
              '${_progress.toInt()}%',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            progressColor:
                _progress >= 100 ? AppColors.success : AppColors.primary,
            backgroundColor: AppColors.divider,
            animation: true,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Geser untuk update',
                style:
                    TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '${_progress.toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          Slider(
            value: _progress,
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: AppColors.gold,
            inactiveColor: AppColors.divider,
            onChanged: (val) => setState(() => _progress = val),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Tulis catatan progress...',
              prefixIcon:
                  Icon(Icons.edit_note_rounded, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _submitProgress(task),
              icon: const Icon(Icons.save_rounded, size: 18),
              label: const Text('Simpan Progress'),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab 2: Riwayat Progress ───────────────────────────────────────────────

  Widget _buildHistoryTab(Task task) {
    final updates = task.progressUpdates;

    if (updates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 64,
              color: AppColors.textHint.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada riwayat progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Update progress pertamamu di tab\nDetail & Progress',
              style: TextStyle(fontSize: 13, color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final sorted = [...updates]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final update = sorted[index];
        final isLatest = index == 0;

        return _buildHistoryItem(
          update: update,
          isLatest: isLatest,
          isLast: index == sorted.length - 1,
        );
      },
    );
  }

  Widget _buildHistoryItem({
    required ProgressUpdate update,
    required bool isLatest,
    required bool isLast,
  }) {
    final percent = update.progressPercent;
    final color = percent >= 100
        ? AppColors.success
        : percent >= 60
            ? AppColors.primary
            : percent >= 30
                ? AppColors.warning
                : AppColors.urgent;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline column
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isLatest ? color : color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color,
                      width: isLatest ? 0 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${percent.toInt()}%',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: isLatest ? Colors.white : color,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isLatest
                      ? color.withOpacity(0.06)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLatest
                        ? color.withOpacity(0.3)
                        : AppColors.divider,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${percent.toInt()}% selesai',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ),
                            if (isLatest) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Terbaru',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress bar mini
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent / 100,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 5,
                      ),
                    ),
                    if (update.note.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.notes_rounded,
                            size: 14,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              update.note,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('EEEE, d MMMM yyyy  •  HH:mm')
                              .format(update.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _difficultyColor(String d) {
    switch (d) {
      case 'easy':
        return AppColors.easy;
      case 'hard':
        return AppColors.hard;
      default:
        return AppColors.medium;
    }
  }

  String _difficultyLabel(String d) {
    switch (d) {
      case 'easy':
        return 'Mudah';
      case 'hard':
        return 'Sulit';
      default:
        return 'Sedang';
    }
  }

  void _submitProgress(Task task) {
    final note = _noteController.text.trim();

    // Tambah ke riwayat progress lokal
    final newUpdate = ProgressUpdate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: task.id,
      note: note,
      progressPercent: _progress,
      createdAt: DateTime.now(),
    );

    context.read<TaskProvider>().updateTaskProgressWithHistory(
          task.id,
          _progress,
          note,
          newUpdate,
        );

    _noteController.clear();

    // Pindah ke tab riwayat setelah simpan
    _tabController.animateTo(1);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress berhasil disimpan'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
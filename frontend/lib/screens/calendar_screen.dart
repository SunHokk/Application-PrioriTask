import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_list_item.dart';
import 'task_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            final tasksOnSelected = _selectedDay != null
                ? provider.getTasksForDate(_selectedDay!)
                : [];

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kalender',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_focusedDay),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Calendar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TableCalendar<Task>(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2027, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day),
                    eventLoader: (day) => provider.getTasksForDate(day),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() => _calendarFormat = format);
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: const TextStyle(
                          color: AppColors.accentOrange,
                          fontWeight: FontWeight.w500),
                      defaultTextStyle: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500),
                      todayDecoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: AppColors.accentOrange,
                        shape: BoxShape.circle,
                      ),
                      markerSize: 6,
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      formatButtonTextStyle:
                          TextStyle(color: Colors.white, fontSize: 12),
                      titleTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      leftChevronIcon: Icon(Icons.chevron_left,
                          color: AppColors.primary),
                      rightChevronIcon: Icon(Icons.chevron_right,
                          color: AppColors.primary),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      weekendStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tasks for selected day
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Tugas pada tanggal ini',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (tasksOnSelected.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${tasksOnSelected.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentOrange,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: tasksOnSelected.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_available_outlined,
                                size: 44,
                                color: AppColors.textHint.withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tidak ada deadline pada tanggal ini',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                          itemCount: tasksOnSelected.length,
                          itemBuilder: (context, index) {
                            final task = tasksOnSelected[index] as Task;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TaskListItem(
                                task: task,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TaskDetailScreen(task: task),
                                  ),
                                ),
                                onDelete: () =>
                                    provider.deleteTask(task.id),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:daily_planner_app/models/api_service.dart';
import 'package:daily_planner_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'task_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ApiService apiService = ApiService();
  Map<DateTime, List<Task>> _events = {};
  Set<DateTime> _markedDays = {}; // Used to mark days with tasks

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

   Future<void> _fetchTasks() async {
    try {
      final fetchedTasks = await apiService.fetchTasks();

      Map<DateTime, List<Task>> groupedTasks = {};
      Set<DateTime> daysWithTasks = {};

      for (var task in fetchedTasks) {
        if (task.date != null) {
          try {
            DateTime taskDate = DateFormat('EEEE, dd/MM/yyyy').parse(task.date!).toLocal();
            
            // Format taskDate before using it as a key
            DateTime formattedTaskDate = DateTime.utc(taskDate.year, taskDate.month, taskDate.day);

            daysWithTasks.add(formattedTaskDate);

            if (groupedTasks.containsKey(formattedTaskDate)) {
              groupedTasks[formattedTaskDate]?.add(task);
            } else {
              groupedTasks[formattedTaskDate] = [task];
            }

          } catch (e) {
            print("Invalid date format for task: ${task.title}, date: ${task.date}, Error: $e");
          }
        }
      }

      setState(() {
        _events = groupedTasks;
        _markedDays = daysWithTasks; 
      });
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  List<Task> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _buildTaskListForSelectedDay() {
    final tasksForDay = _getEventsForDay(_selectedDay!);
    if (tasksForDay.isEmpty) {
      return const Center(child: Text('No tasks for this day'));
    }
    return ListView.builder(
      itemCount: tasksForDay.length,
      itemBuilder: (context, index) {
        final task = tasksForDay[index];
        return ListTile(
          title: Text(task.title ?? ''),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.date != null)
                Text(
                  DateFormat('EEEE, dd/MM/yyyy').format(
                    DateFormat('EEEE, dd/MM/yyyy').parse(task.date!),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              if (task.startTime != null && task.endTime != null)
                Text(
                  'Time: ${task.startTime} - ${task.endTime}',
                  style: const TextStyle(fontSize: 12),
                ),
              if (task.location != null)
                Text(
                  'Location: ${task.location}',
                  style: const TextStyle(fontSize: 12),
                ),
              if (task.notes != null)
                Text(
                  'Notes: ${task.notes}',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(
                  task: task,
                  taskId: task.id!,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              // Check if the day is in _markedDays
              return _markedDays.contains(day) ? [''] : [];
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: Colors.blue[200],
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedDay != null
                ? _buildTaskListForSelectedDay()
                : const Center(child: Text('Select a date to view tasks')),
          ),
        ],
      ),
    );
  }
}
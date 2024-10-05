import 'package:daily_planner_app/models/api_service.dart';
import 'package:daily_planner_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task, required int taskId});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final ApiService apiService = ApiService();

  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late String _selectedStatus;
  late String _selectedHost; // Declare as late here

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _dateController = TextEditingController(text: widget.task.date);
    _startTimeController = TextEditingController(text: widget.task.startTime);
    _endTimeController = TextEditingController(text: widget.task.endTime);
    _locationController = TextEditingController(text: widget.task.location);
    _notesController = TextEditingController(text: widget.task.notes);
    _selectedStatus = widget.task.status ?? 'New';
    // Assign a value to _selectedHost in initState
    _selectedHost = widget.task.host ?? 'Thanh Ngân';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      final updatedTask = Task(
        id: widget.task.id,
        date: _dateController.text,
        title: _titleController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        location: _locationController.text,
        notes: _notesController.text,
        host: _selectedHost,
        status: _selectedStatus,
      );

      await apiService.updateTask(updatedTask);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            color: const Color.fromRGBO(83, 13, 126, 10),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        DateFormat('EEEE, dd/MM/yyyy').format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          _startTimeController.text =
                              pickedTime.format(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          _endTimeController.text = pickedTime.format(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedHost,
                decoration: const InputDecoration(
                  labelText: 'Host',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Thanh Ngân',
                    child: Text('Thanh Ngân'),
                  ),
                  DropdownMenuItem(
                    value: 'Hữu Nghĩa',
                    child: Text('Hữu Nghĩa'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedHost = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'New',
                    child: Text('New'),
                  ),
                  DropdownMenuItem(
                    value: 'InProgress',
                    child: Text('InProgress'),
                  ),
                  DropdownMenuItem(
                    value: 'Completed',
                    child: Text('Completed'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

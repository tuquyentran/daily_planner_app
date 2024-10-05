import 'package:daily_planner_app/models/api_service.dart';
import 'package:daily_planner_app/models/task.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final List<Task> tasks; // Thêm thuộc tính tasks

  const AddTaskScreen(
      {super.key,
      required this.tasks,
      required void Function(Task newTask) onAddTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedHost = 'Thanh Ngân'; // Default value for dropdown
  final List<String> _hostToList = ['Thanh Ngân', 'Hữu Nghĩa'];
  String _selectedStatus = 'New';
  final List<String> _statusOptions = [
    'New',
    'Completed',
    'InProgress',
  ];

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //date picked
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                      'Selected Date: ${DateFormat('EEEE, dd/MM/yyyy').format(_selectedDate)}'),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
                //start time picked
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(
                            'Start Time: ${_selectedStartTime.format(context)}'),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedStartTime,
                          );
                          if (picked != null && picked != _selectedStartTime) {
                            setState(() {
                              _selectedStartTime = picked;
                            });
                          }
                        },
                      ),
                    ),
                    //endtime picked
                    Expanded(
                      child: ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(
                            'End Time: ${_selectedEndTime.format(context)}'),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedEndTime,
                          );
                          if (picked != null && picked != _selectedEndTime) {
                            setState(() {
                              _selectedEndTime = picked;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                //title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter task title';
                    }
                    return null;
                  },
                ),
                //location
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                //host
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Host'),
                  value: _selectedHost,
                  items: _hostToList
                      .map((String assignedTo) => DropdownMenuItem(
                            value: assignedTo,
                            child: Text(assignedTo),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedHost = newValue!;
                    });
                  },
                ),
                //status
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Status'),
                  value: _selectedStatus,
                  items: _statusOptions
                      .map((String status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                ),
                //note
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 60,),
                //btn
                InkWell(
                  onTap: () {
                    _addTask(widget.tasks);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(83, 13, 126, 10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Add Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTask(List<Task> tasks) {
    if (_formKey.currentState!.validate()) {
      int newId = generateUniqueId(tasks); // Tạo id tự động

      Task newTask = Task(
        id: newId, // Gán id cho task mới
        date: _selectedDate.toIso8601String().substring(0, 10),
        startTime: _selectedStartTime.format(context),
        endTime: _selectedEndTime.format(context),
        location: _locationController.text,
        host: _selectedHost,
        title: _titleController.text,
        notes: _noteController.text,
        status: _selectedStatus,
      );

      apiService.addTask(newTask).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
        Navigator.pop(context, true);
      }).catchError((error) => print('Error adding task: $error'));
    }
  }

  int generateUniqueId(List<Task> tasks) {
    if (tasks.isEmpty) {
      return 1;
    }

    int maxId = tasks.map((task) => task.id ?? 0).reduce(max);
    return maxId + 1;
  }
}

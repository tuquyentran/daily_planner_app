import 'package:daily_planner_app/models/api_service.dart';
import 'package:daily_planner_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen(
      {super.key,
      required this.task,
      required void Function(Task updateTask) onChangeTask});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  String _selectedHost = 'Thanh Ngân';
  final List<String> _hostToList = ['Thanh Ngân', 'Hữu Nghĩa'];
  String _selectedStatus = 'New';
  final List<String> _statusOptions = [
    'New',
    'Completed',
    'InProgress',
  ];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title ?? '';
    _noteController.text = widget.task.notes ?? '';
    _locationController.text = widget.task.location ?? '';
    _selectedDate = DateTime.now();
    if (widget.task.date != null) {
      _selectedDate = DateFormat('EEEE, dd/MM/yyyy').parse(widget.task.date!);
    }
    _selectedHost = widget.task.host ?? 'Thanh Ngân';
    _selectedStatus = widget.task.status ?? 'New';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //date picked
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                      'Selected Date: ${DateFormat('EEEE, dd/MM/yyyy').format(_selectedDate)}'),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
                Row(
                  children: [
                    //start time picked
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
                    Expanded(
                      // endtime picked
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
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
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
                    _updateTask();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(83, 13, 126, 10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Save Changes',
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

  void _updateTask() {
    final updatedTask = Task(
        id: widget.task.id,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        title: _titleController.text,
        startTime: _selectedStartTime.format(context),
        endTime: _selectedEndTime.format(context),
        location: _locationController.text,
        host: _selectedHost,
        notes: _noteController.text,
        status: _selectedStatus);

    apiService
        .updateTask(updatedTask)
        .then((_) => Navigator.pop(context, true))
        .catchError((error) => print('Error updating task: $error'));
  }
}

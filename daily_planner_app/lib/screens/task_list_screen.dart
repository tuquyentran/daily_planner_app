import 'package:daily_planner_app/models/api_service.dart';
import 'package:daily_planner_app/models/task.dart';

import 'add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_task_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final fetchedTasks = await apiService.fetchTasks();
      setState(() {
        tasks = fetchedTasks;
      });
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  Future<void> deleteTask(String taskId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      try {
        await apiService.deleteTask(taskId);
        fetchTasks(); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully!')),
        );
      } catch (error) {
        print('Error deleting task: $error');
      }
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1; 
      }
      final Task task = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        automaticallyImplyLeading: false,
      ),
      body: ReorderableListView.builder(
        itemCount: tasks.length,
        onReorder: _onReorder, 
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            key: ValueKey(task.id),
            //detail task
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TaskDetailScreen(task: task, taskId: task.id!),
                  ),
                );
              },
              child: ListTile(
                title: Text(task.title ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.date != null
                          ? DateFormat('EEEE, dd/MM/yyyy').format(
                              DateFormat('EEEE, dd/MM/yyyy').parse(task.date!),
                            )
                          : '',
                    ),
                    Text(
                      'Status: ${task.status ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //btn edit task
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color:
                                              const Color.fromRGBO(83, 13, 126, 10),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(
                              task: task,
                              onChangeTask: (Task updateTask) {
                                setState(() {
                                  int index = tasks.indexWhere((t) => t.id == updateTask.id);
                                  if (index != -1) {
                                    tasks[index] = updateTask;
                                  }
                                });
                              },
                            ),
                          ),
                        ).then((value) {
                          fetchTasks();
                        });
                      },
                    ),
                    //btn delete task
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color:
                                              const Color.fromRGBO(83, 13, 126, 10),
                      onPressed: () {
                        if (task.id != null) {
                          deleteTask(task.id.toString());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      //btn add task
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTaskScreen(
                      onAddTask: (Task newTask) {
                        setState(() {
                          tasks.add(newTask);
                        });
                      },
                      tasks: tasks,
                    )),
          ).then((value) {
            if (value != null) {
              fetchTasks();
            }
          });
        },
      ),
    );
  }
}
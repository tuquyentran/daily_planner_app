// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import '../models/task_list.dart';

// // class TaskItem extends StatefulWidget {
// //   final TaskList task;
// //   final Function() onDelete;
// //   final Function() onEdit;
// //   final Function(TaskStatus) onStatusChanged;

// //   const TaskItem({
// //     Key? key,
// //     required this.task,
// //     required this.onDelete,
// //     required this.onEdit,
// //     required this.onStatusChanged,
// //   }) : super(key: key);

// //   @override
// //   _TaskItemState createState() => _TaskItemState();
// // }

// // class _TaskItemState extends State<TaskItem> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       child: ListTile(
// //         title: Text(widget.task.content!),
// //         subtitle: Text(
// //             '${DateFormat('EEEE, dd/MM/yyyy').format(widget.task.date!)} - ${widget.task.time} - ${widget.task.assignedTo} - ${widget.task.location}'),
// //         trailing: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             IconButton(
// //               icon: Icon(Icons.edit),
// //               onPressed: widget.onEdit,
// //             ),
// //             DropdownButton<TaskStatus>(
// //               value: widget.task.status,
// //               items: TaskStatus.values.map((status) {
// //                 return DropdownMenuItem<TaskStatus>(
// //                   value: status,
// //                   child: Text(status.name),
// //                 );
// //               }).toList(),
// //               onChanged: (newStatus) {
// //                 widget.onStatusChanged(newStatus!);
// //               },
// //             ),
// //             IconButton(
// //               icon: Icon(Icons.delete),
// //               onPressed: widget.onDelete,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:daily_planner_app/models/task_list.dart';
// import 'package:flutter/material.dart';

// class TaskItem extends StatefulWidget {
//   const TaskItem({super.key, required Null Function() onDelete, required TaskList task, required Null Function() onEdit, required Null Function(dynamic TaskStatus) onStatusChanged});

//   @override
//   State<TaskItem> createState() => _TaskItemState();
// }

// class _TaskItemState extends State<TaskItem> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
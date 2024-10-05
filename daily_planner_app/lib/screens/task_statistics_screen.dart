import 'package:daily_planner_app/models/api_service.dart';
import 'package:daily_planner_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class TaskStatisticsScreen extends StatefulWidget {
  const TaskStatisticsScreen({super.key});

  @override
  _TaskStatisticsScreenState createState() => _TaskStatisticsScreenState();
}

class _TaskStatisticsScreenState extends State<TaskStatisticsScreen> {
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

  Map<String, int> groupTasksByStatus() {
    Map<String, int> groupedTasks = {};
    for (Task task in tasks) {
      if (groupedTasks.containsKey(task.status)) {
groupedTasks[task.status!] = (groupedTasks[task.status!] ?? 0) + 1;      } else {
        groupedTasks[task.status!] = 1;
      }
    }
    return groupedTasks;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> groupedTasks = groupTasksByStatus();

    // Chuyển đổi dữ liệu cho pie chart
    List<ChartData> chartData = groupedTasks.entries.map((entry) => ChartData(entry.key, entry.value)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê công việc'),
      ),
      body: Center(
        child: SfCircularChart(
          title: const ChartTitle(text: 'Trạng thái công việc'),
          legend: const Legend(isVisible: true), 
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ]
        ),
      ),
    );
  }
}

// Class để lưu trữ dữ liệu cho chart
class ChartData {
  final String x;
  final int y;

  ChartData(this.x, this.y);
}
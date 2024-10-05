import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/task.dart';
import 'api_urls.dart';

class ApiService {
  // Fetch tasks
  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(ApiUrls.tasksUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(Uri.parse(ApiUrls.taskUrl(taskId)));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    if (task.id != null) {
      final response = await http.put(
        Uri.parse(ApiUrls.taskUrl(task.id.toString())),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task');
      }
    } else {
      throw Exception('Error: Task ID is null');
    }
  }

  // Add task
  Future<void> addTask(Task newTask) async {
    final response = await http.post(
      Uri.parse(ApiUrls.tasksUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newTask.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }
  }

  // User functions
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(ApiUrls.usersUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  // Login function
  Future<User?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiUrls.usersUrl), // Replace with your login endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null) {
        return User.fromJson(data); 
      } else {
        return null; 
      }
    } else {
      throw Exception('Failed to login. Check your credentials.');
    }
  }
}
class ApiUrls {
  static const String tasksUrl = 'http://192.168.1.12:3000/api/tasks';//ip cục bộ(ipconfig->IPv4 Address) 
  static const String usersUrl = 'http://192.168.1.12:3000/api/users';
  static String taskUrl(String taskId) => '$tasksUrl/$taskId';
}
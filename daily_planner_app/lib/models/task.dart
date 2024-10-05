class Task{
  int? id;
  String? date;
  String? title;
  String? startTime; 
  String? endTime; 
  String? location;
  String? host;
  String? notes;
  String? status;

  Task({
    this.id,
    this.date, 
    this.title,
    this.startTime, 
    this.endTime, 
    this.location,
    this.host,
    this.notes,
    this.status,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    startTime = json['startTime']; 
    endTime = json['endTime'];  
    location = json['location'];
    host = json['host'];
    notes = json['notes'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date; 
    data['title'] = title;
    data['startTime'] = startTime; 
    data['endTime'] = endTime;  
    data['location'] = location;
    data['host'] = host;
    data['notes'] = notes;
    data['status'] = status;
    return data;
  }
}
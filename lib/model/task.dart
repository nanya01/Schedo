class Task {
  String title;
  String category;
  String timeCreated;
  bool status;
  Task(
      {required this.title,
      required this.category,
      required this.timeCreated,
      required this.status});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        title: json["title"],
        category: json["category"],
        timeCreated: json["timeCreated"],
        status: json["status"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["category"] = category;
    data["timeCreated"] = timeCreated;
    data["status"] = status;
    return data;
  }
}

class Todo{
  String title;
  String desc;
  bool checked = false;

  Todo({required this.title,required this.desc,required this.checked});
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'isCompleted': checked,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      desc: json['desc'],
      checked: json['isCompleted'] ?? false,
    );
  }
}
class NoteModel {
  int? id;
  String description;
  String date;

  NoteModel({this.id, required this.description, required this.date});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
        id: json['id'], description: json['description'], date: json['date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'description': description,
    };
  }
}

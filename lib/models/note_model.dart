class Note {
  final String id;
  String title;
  String content;

  Note({required this.id, required this.title, required this.content});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
  };
  
}
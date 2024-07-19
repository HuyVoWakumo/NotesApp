class Note {
  String id;
  String title;
  String content;
  String createdAt;
  String? idUser;

  Note({required this.id, required this.title, required this.content, required this.createdAt, this.idUser});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json['id'].toString(),
    title: json['title'],
    content: json['content'],
    createdAt: json['created_at'] ?? '',
    idUser: json['id_user'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'created_at': createdAt,
    'id_user': idUser
  };

  void assign (Note other) {
    title = other.title;
    content = other.content;
    createdAt = other.createdAt;
  }
}

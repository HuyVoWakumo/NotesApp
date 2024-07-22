class Note {
  String id;
  String title;
  String content;
  String updatedAt;
  String? idUser;
  bool isTrash;

  Note({required this.id, required this.title, required this.content, required this.updatedAt, this.idUser, required this.isTrash});

  factory Note.fromMapLocal(Map<String, dynamic> json) => Note(
    id: json['id'].toString(),
    title: json['title'],
    content: json['content'],
    updatedAt: json['updated_at'] ?? '',
    idUser: json['id_user'] ?? '',
    isTrash: json['is_trash'] == 1
  );

  factory Note.fromMapRemote(Map<String, dynamic> json) => Note(
    id: json['id'].toString(),
    title: json['title'],
    content: json['content'],
    updatedAt: json['updated_at'] ?? '',
    idUser: json['id_user'],
    isTrash: json['is_trash'] 
  );

  Map<String, dynamic> toMapLocal() => {
    'id': id,
    'title': title,
    'content': content,
    'updated_at': updatedAt,
    'id_user': idUser,
    'is_trash': isTrash ? 1 : 0,
  };

  Map<String, dynamic> toMapRemote() => {
    'id': id,
    'title': title,
    'content': content,
    'updated_at': updatedAt,
    'id_user': idUser,
    'is_trash': isTrash,
  };

  void assign (Note other) {
    title = other.title;
    content = other.content;
    updatedAt = other.updatedAt;
    isTrash = other.isTrash;
  }
}

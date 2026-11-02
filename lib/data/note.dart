class Note {
  final int? id;
  final String title;
  final String content;
  final String createdAt;

  const Note({this.id, required this.title, required this.content, required this.createdAt});

  Note copyWith({int? id, String? title, String? content}) => Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt,
      );

  // id sengaja tidak disertakan: SQLite dan Sembast sama-sama membuat id otomatis.
  Map<String, Object?> toMap() => {
        'title': title,
        'content': content,
        'created_at': createdAt,
      };

  factory Note.fromMap(Map<String, Object?> map, {required int id}) => Note(
        id: id,
        title: map['title'] as String,
        content: map['content'] as String,
        createdAt: map['created_at'] as String,
      );
}
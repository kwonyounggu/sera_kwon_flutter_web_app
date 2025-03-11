class Comment {
  int id;
  String content;
  String author;

  Comment({required this.id, required this.content, required this.author});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      author: json['author'],
    );
  }
}

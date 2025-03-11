class BlogPost {
  int id;
  String title;
  String content;
  String author;
  String date;

  BlogPost({required this.id, required this.title, required this.content, required this.author, required this.date});

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      date: json['date'],
    );
  }
}

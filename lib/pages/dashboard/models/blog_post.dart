class BlogPost {
  int id;
  String title;
  String content;

  BlogPost({required this.id, required this.title, required this.content});

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}

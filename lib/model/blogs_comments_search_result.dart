class SearchResult 
{
  final int id;
  final String title;
  final String contentPreview;
  final ResultType type; // blog or comment
  final String authorName;
  final int likes;
  final int dislikes;
  final String date;

  SearchResult
  (
    {
      required this.id,
      required this.title,
      required this.contentPreview,
      required this.type,
      required this.authorName,
      required this.likes,
      required this.dislikes,
      required this.date
    }
  );

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult
  (
    id: json['id'] ?? 0,
    title: json['title'] ?? 'Untitled',
    contentPreview: json['content'] ?? '',
    type: ResultType.values.byName(json['type']),
    authorName: json['author_name'] ?? 'Unknown',
    likes: json['likes'] ?? 0,
    dislikes: json['dislikes'] ?? 0,
    date: json['date']
  );
}

enum ResultType { blog, comment }
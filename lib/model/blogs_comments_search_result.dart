class SearchResult 
{
  final String id;
  final String title;
  final String contentPreview;
  final ResultType type; // blog or comment
  final String authorName;

  SearchResult
  (
    {
      required this.id,
      required this.title,
      required this.contentPreview,
      required this.type,
      required this.authorName
    }
  );

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult
  (
    id: json['id'],
    title: json['title'],
    contentPreview: json['content'],
    type: ResultType.values.byName(json['type']),
    authorName: json['author_name']
  );
}

enum ResultType { blog, comment }
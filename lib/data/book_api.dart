/// Fake remote API. Stands in for an HTTP backend and simulates latency.
class BookApi {
  BookApi({this.latency = const Duration(milliseconds: 300)});

  final Duration latency;

  final List<Map<String, Object?>> _rows = [
    {
      'id': 'b1',
      'title': 'The Pragmatic Programmer',
      'author': 'Hunt & Thomas',
      'status': 'reading',
    },
    {
      'id': 'b2',
      'title': 'Designing Data-Intensive Applications',
      'author': 'Kleppmann',
      'status': 'wantToRead',
    },
    {
      'id': 'b3',
      'title': 'Refactoring',
      'author': 'Fowler',
      'status': 'finished',
    },
  ];

  Future<List<Map<String, Object?>>> getBooks() async {
    await Future<void>.delayed(latency);
    return List.unmodifiable(_rows.map(Map<String, Object?>.of));
  }

  Future<Map<String, Object?>> patchStatus(String id, String status) async {
    await Future<void>.delayed(latency);
    final row = _rows.firstWhere(
      (r) => r['id'] == id,
      orElse: () => throw StateError('404: book $id not found'),
    );
    row['status'] = status;
    return Map.of(row);
  }
}

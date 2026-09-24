import '../domain/book.dart';
import '../domain/book_repository.dart';
import '../domain/result.dart';
import 'book_api.dart';

final class ApiBookRepository implements BookRepository {
  ApiBookRepository(this._api);

  final BookApi _api;

  @override
  Future<Result<List<Book>>> fetchReadingList() async {
    try {
      final rows = await _api.getBooks();
      return Ok(rows.map(_toBook).toList());
    } on Object catch (e) {
      return Err(Exception('Failed to load reading list: $e'));
    }
  }

  @override
  Future<Result<Book>> updateStatus(BookId id, ReadingStatus status) async {
    try {
      final row = await _api.patchStatus(id.value, status.name);
      return Ok(_toBook(row));
    } on Object catch (e) {
      return Err(Exception('Failed to update ${id.value}: $e'));
    }
  }

  static Book _toBook(Map<String, Object?> row) => Book(
    id: BookId(row['id']! as String),
    title: row['title']! as String,
    author: row['author']! as String,
    status: ReadingStatus.values.byName(row['status']! as String),
  );
}

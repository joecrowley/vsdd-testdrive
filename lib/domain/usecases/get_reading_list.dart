import '../book.dart';
import '../book_repository.dart';
import '../result.dart';

/// Returns the reading list with books currently being read first.
final class GetReadingList {
  const GetReadingList(this._repository);

  final BookRepository _repository;

  Future<Result<List<Book>>> call() async {
    final result = await _repository.fetchReadingList();
    return switch (result) {
      Ok(value: final books) => Ok([...books]..sort(_byStatus)),
      Err() => result,
    };
  }

  static int _byStatus(Book a, Book b) =>
      _rank(a.status).compareTo(_rank(b.status));

  static int _rank(ReadingStatus status) => switch (status) {
    ReadingStatus.reading => 0,
    ReadingStatus.wantToRead => 1,
    ReadingStatus.finished => 2,
  };
}

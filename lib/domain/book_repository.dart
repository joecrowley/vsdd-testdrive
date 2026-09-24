import 'book.dart';
import 'result.dart';

abstract interface class BookRepository {
  Future<Result<List<Book>>> fetchReadingList();

  Future<Result<Book>> updateStatus(BookId id, ReadingStatus status);
}

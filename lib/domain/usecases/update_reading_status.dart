import '../book.dart';
import '../book_repository.dart';
import '../result.dart';

final class UpdateReadingStatus {
  const UpdateReadingStatus(this._repository);

  final BookRepository _repository;

  Future<Result<Book>> call(BookId id, ReadingStatus status) =>
      _repository.updateStatus(id, status);
}

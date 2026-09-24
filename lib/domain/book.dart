import 'package:equatable/equatable.dart';

extension type const BookId(String value) {}

enum ReadingStatus { wantToRead, reading, finished }

final class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.status = ReadingStatus.wantToRead,
  });

  final BookId id;
  final String title;
  final String author;
  final ReadingStatus status;

  Book copyWith({ReadingStatus? status}) =>
      Book(id: id, title: title, author: author, status: status ?? this.status);

  @override
  List<Object?> get props => [id, title, author, status];
}

import 'package:equatable/equatable.dart';

import '../../domain/book.dart';

sealed class ReadingListState extends Equatable {
  const ReadingListState();

  @override
  List<Object?> get props => [];
}

final class ReadingListInitial extends ReadingListState {
  const ReadingListInitial();
}

final class ReadingListLoading extends ReadingListState {
  const ReadingListLoading();
}

final class ReadingListLoaded extends ReadingListState {
  const ReadingListLoaded(this.books);

  final List<Book> books;

  @override
  List<Object?> get props => [books];
}

final class ReadingListError extends ReadingListState {
  const ReadingListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

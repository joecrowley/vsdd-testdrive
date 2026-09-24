import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsdd_testdrive/domain/book.dart';
import 'package:vsdd_testdrive/domain/book_repository.dart';
import 'package:vsdd_testdrive/domain/result.dart';
import 'package:vsdd_testdrive/domain/usecases/get_reading_list.dart';
import 'package:vsdd_testdrive/domain/usecases/update_reading_status.dart';
import 'package:vsdd_testdrive/presentation/reading_list/reading_list_cubit.dart';
import 'package:vsdd_testdrive/presentation/reading_list/reading_list_state.dart';

class FakeBookRepository implements BookRepository {
  FakeBookRepository(this.books, {this.fail = false});

  List<Book> books;
  bool fail;

  @override
  Future<Result<List<Book>>> fetchReadingList() async =>
      fail ? Err(Exception('offline')) : Ok(books);

  @override
  Future<Result<Book>> updateStatus(BookId id, ReadingStatus status) async {
    if (fail) return Err(Exception('offline'));
    books = [
      for (final b in books) b.id == id ? b.copyWith(status: status) : b,
    ];
    return Ok(books.firstWhere((b) => b.id == id));
  }
}

const _done = Book(
  id: BookId('1'),
  title: 'A',
  author: 'x',
  status: ReadingStatus.finished,
);
const _reading = Book(
  id: BookId('2'),
  title: 'B',
  author: 'y',
  status: ReadingStatus.reading,
);

ReadingListCubit _cubit(FakeBookRepository repo) =>
    ReadingListCubit(GetReadingList(repo), UpdateReadingStatus(repo));

void main() {
  blocTest<ReadingListCubit, ReadingListState>(
    'load emits Loading then Loaded, currently-reading first',
    build: () => _cubit(FakeBookRepository([_done, _reading])),
    act: (c) => c.load(),
    expect: () => [
      const ReadingListLoading(),
      const ReadingListLoaded([_reading, _done]),
    ],
  );

  blocTest<ReadingListCubit, ReadingListState>(
    'load emits Error when the repository fails',
    build: () => _cubit(FakeBookRepository([], fail: true)),
    act: (c) => c.load(),
    expect: () => [const ReadingListLoading(), isA<ReadingListError>()],
  );

  blocTest<ReadingListCubit, ReadingListState>(
    'setStatus updates the book and reloads',
    build: () => _cubit(FakeBookRepository([_done])),
    act: (c) => c.setStatus(const BookId('1'), ReadingStatus.reading),
    expect: () => [
      const ReadingListLoading(),
      ReadingListLoaded([_done.copyWith(status: ReadingStatus.reading)]),
    ],
  );
}

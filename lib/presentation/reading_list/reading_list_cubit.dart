import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/book.dart';
import '../../domain/result.dart';
import '../../domain/usecases/get_reading_list.dart';
import '../../domain/usecases/update_reading_status.dart';
import 'reading_list_state.dart';

class ReadingListCubit extends Cubit<ReadingListState> {
  ReadingListCubit(this._getReadingList, this._updateReadingStatus)
    : super(const ReadingListInitial());

  final GetReadingList _getReadingList;
  final UpdateReadingStatus _updateReadingStatus;

  Future<void> load() async {
    emit(const ReadingListLoading());
    final result = await _getReadingList();
    if (isClosed) return;
    emit(switch (result) {
      Ok(value: final books) => ReadingListLoaded(books),
      Err(error: final e) => ReadingListError(e.toString()),
    });
  }

  Future<void> setStatus(BookId id, ReadingStatus status) async {
    final result = await _updateReadingStatus(id, status);
    if (isClosed) return;
    switch (result) {
      case Ok():
        await load();
      case Err(error: final e):
        emit(ReadingListError(e.toString()));
    }
  }
}

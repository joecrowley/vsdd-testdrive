import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/api_book_repository.dart';
import 'data/book_api.dart';
import 'domain/book.dart';
import 'domain/book_repository.dart';
import 'domain/usecases/get_reading_list.dart';
import 'domain/usecases/update_reading_status.dart';
import 'presentation/book_detail/book_detail_screen.dart';
import 'presentation/reading_list/reading_list_cubit.dart';
import 'presentation/reading_list/reading_list_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ReadingListScreen(),
      routes: [
        GoRoute(
          path: 'books/:id',
          builder: (context, state) =>
              BookDetailScreen(id: BookId(state.pathParameters['id']!)),
        ),
      ],
    ),
  ],
);

class ReadingListApp extends StatelessWidget {
  const ReadingListApp({super.key, this.repository});

  /// Injectable for tests; defaults to the fake remote API.
  final BookRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? ApiBookRepository(BookApi());
    return BlocProvider(
      create: (_) =>
          ReadingListCubit(GetReadingList(repo), UpdateReadingStatus(repo))
            ..load(),
      child: MaterialApp.router(
        title: 'Reading list',
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        routerConfig: _router,
      ),
    );
  }
}
